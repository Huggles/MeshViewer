/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/
public with sharing class BusinessServiceImpl implements IBusinessService {

    // TODO: implement a proper DTO so the dependency on CI is removed
    public static List<DutchBusinessDto.DutchBusinessReference> searchForDossiers(DutchBusinessDto.dutchBusinessSearchParametersRequest searchParams){
        // Handle valid postcodes that the web service does not like
        if (searchParams.postcode != null){ // fix for postal code
            searchParams.postcode = searchParams.postcode.replaceAll('(\\s+)', '').toUpperCase();
        }

        IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
        List<DutchBusinessDto.DutchBusinessReference> searchResults;
        try{
            DutchBusinessDto.DutchBusinessSearchParametersResponse returnedResults = service.dutchBusinessSearchParameters(searchParams);
            if(returnedResults != null && returnedResults.items != null && returnedResults.items.size()>0){
                searchResults=returnedResults.items;
            }
            //return parsed result
            return searchResults;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception, ex);
        }
    }


    public List<Business_Dossier__c> updateDossiersWithDataVendorData(List<UpdateDossierRequestDTO> updateDossierRequestDTOS) {
        // no CRUD and FLS checks since this needs to be done in system mode. The customer has paid for the data fetched
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        List<Business_Dossier__c> dossiers = updateDossiers(updateDossierRequestDTOS, unitOfWork);
        unitOfWork.commitWork();
        return dossiers;
    }
    
    public InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromDataVendorData(String dossierNumber, String establishmentNumber, Id accountId) {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        InsertDossiersFromDataVendorResponseDTO response = null;
        Account account = null;

        // first find any dossiers that are already existing
        List<CheckDuplicateDossierResponse> duplicateDossierResponses = BusinessDuplicateService.checkForDuplicateDossiers(
                new List<CheckDuplicateDossierRequest>{new CheckDuplicateDossierRequest(dossierNumber, establishmentNumber)}
        );
        if (duplicateDossierResponses.get(0).dossierFound != null) { // duplicate found
            Business_Dossier__c duplicateDossier = duplicateDossierResponses.get(0).dossierFound;
            response = new InsertDossiersFromDataVendorResponseDTO(duplicateDossier, true);
        } else { // no duplicate, we need to insert the dossier
            try {
                // get the dossier from the datavendor
                DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier = getDossier(dossierNumber, establishmentNumber);

                // create an account if the account id is null
                if (accountId == null) {
                    List<InsertAccountResponseDTO> accountResponseDTOS = insertAccount(new List<DutchBusinessDto.DutchBusinessGetDossierResponse>{dataVendorDossier}, unitOfWork);
                    // since somebody thought of let's have a circular relationship between dossier and account, we need to commit the work up until now
                    // or we don't have an id on the account and cannot create the other side of the relationship when we insert the dossier
                    account = accountResponseDTOS.get(0).account;
                } else {
                    List<Account> accounts = AccountSelector.newInstance().selectById(new Set<Id>{accountId});
                    account = accounts.get(0);
                }
                List<Business_Dossier__c> dossierDBs = insertDossier(new List<InsertDossierRequestDTO>{new InsertDossierRequestDTO(dataVendorDossier, account)}, unitOfWork);

                response = new InsertDossiersFromDataVendorResponseDTO(dossierDBs.get(0), false);
                unitOfWork.commitWork();

                // now update the account in a new round since only now we have the id of the dossier.
                // Someone had the smart idea of creating a circular relationship in the database...
                // Since the id of the account is not known before creation, registering a relationship doesn't work
                unitOfWork = Application.UnitOfWork.newInstance();
                unitOfWork.registerDirty(account, Schema.Account.Business_Dossier__c, dossierDBs.get(0));
                unitOfWork.commitWork();

            } catch (CCDuplicateException e) { // multiple duplicate accounts have been found
                throw e;
            } catch (Exception e) {
                ErrorLogUtil.logException(e);
                throw new CCException(e);
            }
        }
        return response;
    }

    public static Boolean deleteDossier(Id accountId) {
        List<Account> accounts = AccountSelector.newInstance().selectById(new Set<Id>{
                accountId
        });
        List<Business_Dossier__c> dossierList = BusinessDossierSelector.newInstance().selectById(new Set<Id>{
                accounts.get(0).Business_Dossier__c
        });
        Boolean response = false;
        if (dossierList.size() == 1) {
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
            unitOfWork.registerDeleted(dossierList[0]);
            unitOfWork.commitWork();
            response = true;
        }
        return response;
    }

    public Business_Dossier__c setVatNumber(Id dossierId) {
        if (dossierId == null) {
            throw new CCException('DossierId must be filled when setting VAT number'); // shouldn't happen but let's check the input
        }

        List<Business_Dossier__c> dossiersDB = ((IBusinessDossierSelector)Application.Selector.newInstance(Business_Dossier__c.SObjectType)).selectById(new Set<Id>{dossierId});
        if (dossiersDB.isEmpty()) {
            throw new CCException('User doesn\'t have access to dossier with ID: ' + dossierId);
        }

        Business_Dossier__c dossierDB = dossiersDB.get(0);
        String vatNumber = BusinessDuplicateService.checkForExistingVatNumberInDB(dossierDB.Dossier_Number__c);

        // if no vat number in the db, get it from the data vendor
        if (String.isEmpty(vatNumber)) { // no VAT number for any other dossier in the database
            DutchBusinessDto.DutchBusinessGetVatNumberRequest vatRequest = new DutchBusinessDto.DutchBusinessGetVatNumberRequest();
            vatRequest.dossier_number = dossierDB.Dossier_Number__c;
            DutchBusinessDto.DutchBusinessVatNumber vatResponse = WebServicesNLSOAPDutchBusiness.newInstance().businessGetVatNumber(vatRequest);
            if (String.isEmpty(vatResponse.vat_number)) {
                throw new CCVatNotFoundException(Label.VAT_Not_Found);
            } else {
                vatNumber = vatResponse.vat_number;
            }
        }

        // update the dossier with the vatnumber
        dossierDB.VAT_Number__c = vatNumber;
        // without CRUD/FLS check since the user has paid for the data and has access to the original record
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        unitOfWork.registerDirty(dossierDB);
        unitOfWork.commitWork();
        return dossierDB;
    }

    /**************
     * Implementation methods
     **************/

    @TestVisible
    private List<InsertAccountResponseDTO> insertAccount(List<DutchBusinessDto.DutchBusinessGetDossierResponse> dataVendorDossiers, fflib_ISObjectUnitOfWork unitOfWork) {
        List<InsertAccountResponseDTO> responses = new List<InsertAccountResponseDTO>();
        for (DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier : dataVendorDossiers) {
            Account account = mapDataVendorToAccount(dataVendorDossier, new Account());
            // TODO: make this bulkified and move it outside of the loop
            List<Account> duplicateAccounts = BusinessDuplicateService.checkForAccountDuplicates(account);
            if (duplicateAccounts.size() > 1) { // too many duplicates found. Cannot map them.
                throw new CCDuplicateException(Label.Dossier_Multiple_Account_Duplicates_Found);
            } else
            if (duplicateAccounts.size() == 1) { // one duplicate found, let's reuse that one
                account = duplicateAccounts.get(0);
            } else { // no duplicates found, create a new account
                unitOfWork.registerNew(account);
            }
            InsertAccountResponseDTO response = new InsertAccountResponseDTO(dataVendorDossier, account);
            responses.add(response);
        }
        return responses;
    }

    private Account mapDataVendorToAccount(DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier, Account account) {
        account.Name = dataVendorDossier.trade_name_full;
        return account;
    }

    private List<Business_Dossier__c> insertDossier(List<InsertDossierRequestDTO> InsertDossierRequestDTOS, fflib_ISObjectUnitOfWork unitOfWork) {
        List<Business_Dossier__c> returnList = new List<Business_Dossier__c>();
        for (InsertDossierRequestDTO insertDossierRequestDTO : InsertDossierRequestDTOS) {
            Business_Dossier__c dossier = mapDataVendorDataToDossier(insertDossierRequestDTO.dossier, new Business_Dossier__c());
            unitOfWork.registerNew(dossier, Business_Dossier__c.Account__c, insertDossierRequestDTO.account);

            // unitOfWork.registerRelationship(insertDossierRequestDTO.account, Account.Business_Dossier__c, dossier);
            
            Dossier_Address__c establishmentAddress = mapDataVendorDataToEstablishmentAddress(insertDossierRequestDTO.dossier, new Dossier_Address__c());
            unitOfWork.registerNew(establishmentAddress, Dossier_Address__c.Business_Data__c, dossier);

            Dossier_Address__c correspondenceAddress = mapDataVendorDataToCorrespondenceAddress(insertDossierRequestDTO.dossier, new Dossier_Address__c());
            unitOfWork.registerNew(correspondenceAddress, Dossier_Address__c.Business_Data__c, dossier);
            
            List<Business_Data_SBI__c> sbiCodes = mapDataVendorDataToSBICodes(insertDossierRequestDTO.dossier, new List<Business_Data_SBI__c>());
            for (Business_Data_SBI__c businessDataSBI : sbiCodes) {
                unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, dossier);
            }
            returnList.add(dossier);
        }
        return returnList;
    }

    private List<Business_Dossier__c> updateDossiers(List<UpdateDossierRequestDTO> updateDossierRequestDTOS, fflib_ISObjectUnitOfWork unitOfWork) {
        List<Business_Dossier__c> returnList = new List<Business_Dossier__c>();
        for (UpdateDossierRequestDTO updateDossierRequestDTO : updateDossierRequestDTOS) {
            Business_Dossier__c dossier = mapDataVendorDataToDossier(updateDossierRequestDTO.dataVendorDossier, updateDossierRequestDTO.dossierDB);
            unitOfWork.registerDirty(dossier);

            // *** handle addresses ***
            // delete the addresses
            List<Dossier_Address__c> currentAddresses = DossierAddressSelector.newInstance().selectByDossierId(new Set<Id>{dossier.Id});
            unitOfWork.registerDeleted(currentAddresses);
            // create new addresses
            Dossier_Address__c establishmentAddress = mapDataVendorDataToEstablishmentAddress(updateDossierRequestDTO.dataVendorDossier, new Dossier_Address__c());
            unitOfWork.registerNew(establishmentAddress, Dossier_Address__c.Business_Data__c, dossier);
            Dossier_Address__c correspondenceAddress = mapDataVendorDataToCorrespondenceAddress(updateDossierRequestDTO.dataVendorDossier, new Dossier_Address__c());
            unitOfWork.registerNew(correspondenceAddress, Dossier_Address__c.Business_Data__c, dossier);

            // *** handle SBI codes ***
            // delete the SBI codes
            List<Business_Data_SBI__c> currentSBICodes = SbiCodeSelector.newInstance().selectByDossierId(new Set<Id>{dossier.Id});
            unitOfWork.registerDeleted(currentSBICodes);
            // create new SBI codes
            List<Business_Data_SBI__c> sbiCodes = mapDataVendorDataToSBICodes(updateDossierRequestDTO.dataVendorDossier, new List<Business_Data_SBI__c>());
            for (Business_Data_SBI__c businessDataSBI : sbiCodes) {
                unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, dossier);
            }

            returnList.add(dossier);
        }
        return returnList;

    }

    private Business_Dossier__c mapDataVendorDataToDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier, Business_Dossier__c dossierDB) {
        String trade_names = '';
        // TODO: move this to a list of tradelist (seperate sObject)
        if (dataVendorDossier.trade_names != null && dataVendorDossier.trade_names.size() > 0) {
            // Condense all trade names into single field, seperated by new lines.
            for (Integer i = 0; i < dataVendorDossier.trade_names.size(); i++) {
                trade_names += dataVendorDossier.trade_names[i] + (i == dataVendorDossier.trade_names.size()-1 ? '' : ', ');
            }
            dossierDB.Trade_Names__c = trade_names;
        }
        if(dataVendorDossier.legal_name != null && dataVendorDossier.legal_name != ''){
            dossierDB.Name = dataVendorDossier.legal_name;//dataVendorDossier.legal_name;
        }else{
            dossierDB.Name = dataVendorDossier.trade_name_full;//dataVendorDossier.legal_name;
        }
        dossierDB.Dossier_Number__c = dataVendorDossier.dossier_number;
        dossierDB.Establishment_Number__c = dataVendorDossier.establishment_number;
        dossierDB.Main_Establishment_Number__c = dataVendorDossier.main_establishment_number;
        dossierDB.Indication_Main_Establishment__c = dataVendorDossier.indication_main_establishment; //convertToBoolean(dataVendorDossier.indication_main_establishment);
        dossierDB.Rsin_Number__c = String.valueOf(dataVendorDossier.rsin_number);
        dossierDB.Chamber_Number__c = convertToInteger(dataVendorDossier.chamber_number);
        dossierDB.Legal_Form_Code__c = convertToInteger(dataVendorDossier.legal_form_code);
        dossierDB.Legal_Form_Text__c = dataVendorDossier.legal_form_text;//;convertToString(dataVendorDossier.legal_form_text);
        dossierDB.Indication_Organisation_Code__c = dataVendorDossier.indication_organisation_code;//convertToString(dataVendorDossier.indication_organisation_code);
        dossierDB.Trade_Name_45__c = dataVendorDossier.trade_name_45;
        dossierDB.Trade_Name_Full__c = dataVendorDossier.trade_name_full;
        dossierDB.Trade_Names__c = trade_names;
        dossierDB.Telephone_Number__c = dataVendorDossier.telephone_number;
        dossierDB.Mobile_Number__c = dataVendorDossier.mobile_number;
        dossierDB.Domain_Name__c = dataVendorDossier.domain_name;

        dossierDB.Authorized_Share_Capital__c = dataVendorDossier.authorized_share_capital;
        dossierDB.Authorized_Share_Capital_Currency__c = dataVendorDossier.authorized_share_capital_currency;
        dossierDB.Class_Personnel__c = convertToString(dataVendorDossier.class_personnel);
        dossierDB.Class_Personnel_Fulltime__c = convertToString(dataVendorDossier.class_personnel_fulltime);
        dossierDB.Continuation_Date__c = validDate(dataVendorDossier.continuation_date);
        dossierDB.Discontinuation_Date__c = validDate(dataVendorDossier.discontinuation_date);
        dossierDB.Establishment_Date__c = validDate(dataVendorDossier.establishment_date);
        dossierDB.Founding_Date__c = validDate(dataVendorDossier.founding_date);
        dossierDB.Issued_Share_Capital__c = convertToInteger(dataVendorDossier.issued_share_capital);
        dossierDB.Issued_Share_Capital_Currency__c = dataVendorDossier.issued_share_capital_currency;
        dossierDB.Paid_Up_Share_Capital__c = convertToInteger(dataVendorDossier.paid_up_share_capital);
        dossierDB.Paid_Up_Share_Capital_Currency__c = dataVendorDossier.paid_up_share_capital_currency;
        dossierDB.Personnel__c = dataVendorDossier.personnel;
        dossierDB.Personnel_Fulltime__c = dataVendorDossier.personnel_fulltime;
        dossierDB.Personnel_Reference_Date__c = validDate(dataVendorDossier.personnel_reference_date);
        dossierDB.Primary_Sbi_Code__c = dataVendorDossier.primary_sbi_code;
        dossierDB.Primary_Sbi_Code_Text__c = dataVendorDossier.primary_sbi_code_text;
        dossierDB.Secondary_Sbi_Code_1__c = dataVendorDossier.secondary_sbi_code1;
        dossierDB.Secondary_Sbi_Code_1_Text__c = dataVendorDossier.secondary_sbi_code1_text;
        dossierDB.Secondary_Sbi_Code_2__c = dataVendorDossier.secondary_sbi_code2;
        dossierDB.Secondary_Sbi_Code_2_Text__c = dataVendorDossier.secondary_sbi_code2_text;

        dossierDB.Chamber_Code__c = dataVendorDossier.chamber_number;
        dossierDB.Status__c = determineStatus(dataVendorDossier);

        dossierDB.Annual_Financial_Statement_Summary__c = dataVendorDossier.annual_financial_statement_summary;
        dossierDB.Year__c = dataVendorDossier.annual_financial_statement_summary_year;
        dossierDB.Profit__c = dataVendorDossier.annual_financial_statement_summary_profit;
        dossierDB.Turnover__c = dataVendorDossier.annual_financial_statement_summary_turnover;
        dossierDB.Assets__c = dataVendorDossier.annual_financial_statement_summary_assets;

        dossierDB.Personnel_CI__c = dataVendorDossier.personnel_ci;
        dossierDB.Class_Personnel_CI__c = convertToString(dataVendorDossier.class_personnel_ci);
        dossierDB.Personnel_CI_Reference_Date__c = validDate(dataVendorDossier.personnel_ci_reference_date);
        dossierDB.Contact_Initials__c = dataVendorDossier.contact_initials;
        dossierDB.Contact_Prefix__c = dataVendorDossier.contact_prefix;
        dossierDB.Contact_Surname__c = dataVendorDossier.contact_surname;
        dossierDB.Contact_Title1__c = dataVendorDossier.contact_title1;
        dossierDB.Contact_Title2__c = dataVendorDossier.contact_title2;
        dossierDB.Contact_Gender__c = dataVendorDossier.contact_gender;
        if (dataVendorDossier.indication_bankruptcy != null) { dossierDB.Indication_Bankruptcy__c = dataVendorDossier.indication_bankruptcy;}
        if (dataVendorDossier.indication_dip != null) { dossierDB.Indication_Dip__c = dataVendorDossier.indication_dip;}
        if (dataVendorDossier.indication_economically_active != null) { dossierDB.Indication_Economically_Active__c = dataVendorDossier.indication_economically_active;}
        if (dataVendorDossier.indication_export != null) { dossierDB.Indication_Export__c = dataVendorDossier.indication_export;}
        if (dataVendorDossier.indication_import != null) { dossierDB.Indication_Import__c = dataVendorDossier.indication_import;}
        if (dataVendorDossier.indication_main_establishment != null) { dossierDB.Indication_Main_Establishment__c = dataVendorDossier.indication_main_establishment;}
        if (dataVendorDossier.indication_non_mailing != null) { dossierDB.Indication_Non_Mailing__c = dataVendorDossier.indication_non_mailing;}
        dossierDB.Insolvencies__c = dataVendorDossier.insolvencies;

        //dossierDB.Sbi_Collection__c = dataVendorDossier.sbi_collection;

        dossierDB.Structure__c = dataVendorDossier.structure;
        dossierDB.Number_Of_Subsidiaries__c = dataVendorDossier.structure_number_of_subsidiaries;
        dossierDB.Parent_Chamber_Of_Commerce_Number__c = dataVendorDossier.structure_parent;
        dossierDB.Ultimate_Parent_Chamber_Of_Commerce_Nr__c = dataVendorDossier.structure_ultimate_parent;
        return dossierDB;
    }

    private Dossier_Address__c mapDataVendorDataToEstablishmentAddress(DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier, Dossier_Address__c addressDB) {
        addressDB.Name = dataVendorDossier.establishment_address_original_postcode + ' ' + dataVendorDossier.establishment_address_original_street; //dataVendorDossier.establishment_address_original_address;
        addressDB.Postcode__c = dataVendorDossier.establishment_address_original_postcode;
        addressDB.Street__c = dataVendorDossier.establishment_address_original_street;
        addressDB.City__c = dataVendorDossier.establishment_address_original_city;
        addressDB.House_Number__c = String.valueOf(dataVendorDossier.establishment_address_original_house_number);
        addressDB.House_Number_Addition__c = dataVendorDossier.establishment_address_original_house_number_addition;
        addressDB.Country__c = dataVendorDossier.establishment_address_original_country;
        addressDB.Type__c = 'Establishment';
        return addressDB;
    }

    private Dossier_Address__c mapDataVendorDataToCorrespondenceAddress(DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier, Dossier_Address__c addressDB) {
        addressDB.Name = dataVendorDossier.correspondence_address_original_postcode + ' ' + dataVendorDossier.correspondence_address_original_street; //dataVendorDossiercorrespondence_address_original_address;
        addressDB.Postcode__c = dataVendorDossier.correspondence_address_original_postcode;
        addressDB.Street__c = dataVendorDossier.correspondence_address_original_street;
        addressDB.City__c = dataVendorDossier.correspondence_address_original_city;
        addressDB.House_Number__c = String.valueOf(dataVendorDossier.correspondence_address_original_house_number);
        addressDB.House_Number_Addition__c = dataVendorDossier.correspondence_address_original_house_number_addition;
        addressDB.Country__c = dataVendorDossier.correspondence_address_original_country;
        addressDB.Type__c = 'Correspondence';
        return addressDB;
    }

    private List<Business_Data_SBI__c> mapDataVendorDataToSBICodes(DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier, List<Business_Data_SBI__c> sbiCodesDB) {
        sbiCodesDB = dataVendorDossier.sbi_collection;
        return sbiCodesDB;
    }



    private static Date validDate(Date theDate) {
        if (theDate == null) return null;
        Date d = Date.valueOf(theDate);
        if (d.year() < 1000) return null;
        return d;
    }

    // method to skip doing if for every value
    @TestVisible
    private static Integer convertToInteger(String value){
        try{
            return Integer.valueOf(value);
        }catch(Exception e){
            return null;
        }
    }
    // method to skip doing if for every value
    private static Integer convertToInteger(Long value){
        try{
            return Integer.valueOf(value);
        }catch(Exception e){
            return null;
        }
    }
    // method to skip doing if for every value
    private static String convertToString(Integer value){
        return String.valueOf(value);
    }


    @TestVisible
    private DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber, String establishmentNumber) {
        if (dossierNumber == null){ return null;}
        IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
        DutchBusinessDto.DutchBusinessGetDossierRequest requestParams = new DutchBusinessDto.DutchBusinessGetDossierRequest();// = new DutchBusinessDto.DutchBusinessGetDossierRequest(dossier_number = dossierNumber, establishment_number = null);
        requestParams.dossier_number = dossierNumber;
        requestParams.establishment_number = establishmentNumber;
        return service.dutchBusinessGetDossier(requestParams);
    }

    private static String determineStatus(DutchBusinessDto.DutchBusinessGetDossierResponse dossier) {
        List<String> status = new List<String>();
        if (dossier.indication_import != null && Boolean.valueOf(dossier.indication_import) == true) status.add('Import');
        if (dossier.indication_export != null && Boolean.valueOf(dossier.indication_export) == true) status.add('Export');
        if (dossier.indication_economically_active != null && Boolean.valueOf(dossier.indication_economically_active) == true) status.add('Economically Active');
        if (dossier.indication_non_mailing != null && Boolean.valueOf(dossier.indication_non_mailing) == true) status.add('Non Mailing');
        if (dossier.indication_bankruptcy != null && Boolean.valueOf(dossier.indication_bankruptcy) == true) status.add('Bankruptcy');
        if (dossier.indication_dip != null && Boolean.valueOf(dossier.indication_dip) == true) status.add('DIP');
        return String.join(status, ';');
    }

}