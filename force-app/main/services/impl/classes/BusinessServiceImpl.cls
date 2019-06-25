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
                Account account = null;
                if (accountId == null) {
                    // TODO: add validation exception handling
                    List<InsertAccountResponseDTO> accountResponseDTOS = insertAccount(new List<DutchBusinessDto.DutchBusinessGetDossierResponse>{dataVendorDossier}, unitOfWork);
                    account = accountResponseDTOS.get(0).account;
                } else {
                    account = new Account(Id = accountId);
                }
                List<Business_Dossier__c> dossierDBs = insertDossier(new List<InsertDossierRequestDTO>{new InsertDossierRequestDTO(dataVendorDossier, account)}, unitOfWork);

                response = new InsertDossiersFromDataVendorResponseDTO(dossierDBs.get(0), false);
            } catch (CCDuplicateException e) { // multiple duplicate accounts have been found
                throw e;
            } catch (Exception e) {
                ErrorLogUtil.logException(e);
                throw new CCException(e);
            }
        }
        unitOfWork.commitWork();
        return response;
    }

    public static Boolean deleteDossier(Id accountId) {
        try{
            List<Account> accounts = AccountSelector.newInstance().selectById(new Set<Id>{accountId});
            List<Business_Dossier__c> dossierList = BusinessDossierSelector.newInstance().selectById(new Set<Id>{accounts.get(0).Business_Dossier__c});
            if (dossierList.size() == 1) {
                delete dossierList[0];
                return true;
            }
            return false;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception, ex);
        }
    }

    public static Business_Dossier__c selectDossier(Id dossierId) {
        try{
            List<Business_Dossier__c> dossierList = BusinessDossierSelector.newInstance().selectById(new set<Id>{dossierId});
            if (dossierList.size() == 1) {
                return dossierList[0];
            }
            return null;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    public Business_Dossier__c setVatNumber(Id dossierId) {
        String vatNumber = '';
        // TODO: move this to another 'without sharing' in between layer to ensure all VAT numbers are found
        List<Business_Dossier__c> dossiersDB = ((IBusinessDossierSelector)Application.Selector.newInstance(Business_Dossier__c.SObjectType)).selectById(new Set<Id>{dossierId});
        Business_Dossier__c dossierDB = dossiersDB.get(0);
        List<Business_Dossier__c> dossiersWithSameDossierNumber = ((IBusinessDossierSelector)Application.Selector.newInstance(Business_Dossier__c.SObjectType)).selectByDossierNumber(new Set<String>{dossierDB.Dossier_Number__c}, false);
        for (Business_Dossier__c businessDossier : dossiersWithSameDossierNumber) {
            if (!String.isEmpty(businessDossier.VAT_Number__c)) {
                vatNumber = businessDossier.VAT_Number__c;
                break;
            }
        }

        // if no vat number in the db, get it from the data vendor
        if (String.isEmpty(vatNumber)) { // no VAT number for any other dossier in the database
            DutchBusinessDto.DutchBusinessGetVatNumberRequest vatRequest = new DutchBusinessDto.DutchBusinessGetVatNumberRequest();
            vatRequest.dossier_number = dossierDB.Dossier_Number__c;
            DutchBusinessDto.DutchBusinessVatNumber vatResponse = WebServicesNLSOAPDutchBusiness.newInstance().businessGetVatNumber(vatRequest);
            if (String.isEmpty(vatResponse.vat_number)) {
                // TODO: need to add error message
                throw new CCVatNotFoundException();
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
        // currently just returns the sbi collection of the dataVendorDossie since we used the SObject as a DTO
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
        try{
            return String.valueOf(value);
        }catch(Exception e){
            return null;
        }
    }


    @TestVisible
    private DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber, String establishmentNumber) {
        if (dossierNumber == null){ return null;}
        try{
            IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
            DutchBusinessDto.DutchBusinessGetDossierRequest requestParams = new DutchBusinessDto.DutchBusinessGetDossierRequest();// = new DutchBusinessDto.DutchBusinessGetDossierRequest(dossier_number = dossierNumber, establishment_number = null);
            requestParams.dossier_number = dossierNumber;
            requestParams.establishment_number = establishmentNumber;
            return service.dutchBusinessGetDossier(requestParams);
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception, ex);
        }
    }

//    private static List<Object> upsertDossier(Business_Dossier__c dossier){
//        try{
//            List<Object> result = new List<Object>();
//            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance(new DMLWithCrud());
//            unitOfWork.registerDirty(dossier);
//            unitOfWork.commitWork();
//            result.add(dossier);
//            return result;
//        }catch(CCException ex){
//            throw ex; // we dont log bds exceptions, only throwing them further
//        }catch(System.Exception ex){
//            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
//            throw new CCException(System.Label.DBSCall_Unknown_Exception, ex);
//        }
//    }

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

//    private static Business_Dossier__c saveBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork) {
//        try{
//            List<Business_Dossier__c> dbds = BusinessDossierSelector.newInstance().selectByDossierNumbers(new Set<DossierQueryDTO>{new DossierQueryDTO(dossier.dossier_number, dossier.establishment_number)}, false);
//            String trade_names = '';
//            if (dossier.trade_names != null && dossier.trade_names.size() > 0) {
//                // Condense all trade names into single field, seperated by new lines.
//                for (Integer i = 0; i < dossier.trade_names.size(); i++) {
//                    trade_names += dossier.trade_names[i] + (i == dossier.trade_names.size()-1 ? '' : ', ');
//                }
//
//            }
//            System.debug(dbds);
//            Boolean dossierExists = dbds.size() == 1 ? true : false;
//            Business_Dossier__c d = dossierExists ? (Business_Dossier__c)dbds[0] : new Business_Dossier__c();
//
//            // if we will need legal name on name field
//            if(dossier.legal_name != null && dossier.legal_name != ''){
//                d.Name = dossier.legal_name;//dossier.legal_name;
//            }else{
//                d.Name = dossier.trade_name_full;//dossier.legal_name;
//            }
//            //d.Name = dossier.trade_name_full;
//            d.Dossier_Number__c = dossier.dossier_number;
//            d.Establishment_Number__c = dossier.establishment_number;
//            d.Main_Establishment_Number__c = dossier.main_establishment_number;
//            d.Indication_Main_Establishment__c = dossier.indication_main_establishment; //convertToBoolean(dossier.indication_main_establishment);
//            d.Rsin_Number__c = String.valueOf(dossier.rsin_number);
//            d.Chamber_Number__c = convertToInteger(dossier.chamber_number);
//            d.Legal_Form_Code__c = convertToInteger(dossier.legal_form_code);
//            d.Legal_Form_Text__c = dossier.legal_form_text;//;convertToString(dossier.legal_form_text);
//            d.Indication_Organisation_Code__c = dossier.indication_organisation_code;//convertToString(dossier.indication_organisation_code);
//            d.Trade_Name_45__c = dossier.trade_name_45;
//            d.Trade_Name_Full__c = dossier.trade_name_full;
//            d.Trade_Names__c = trade_names;
//            d.Telephone_Number__c = dossier.telephone_number;
//            d.Mobile_Number__c = dossier.mobile_number;
//            d.Domain_Name__c = dossier.domain_name;
//
//            d.Authorized_Share_Capital__c = dossier.authorized_share_capital;
//            d.Authorized_Share_Capital_Currency__c = dossier.authorized_share_capital_currency;
//            d.Class_Personnel__c = convertToString(dossier.class_personnel);
//            d.Class_Personnel_Fulltime__c = convertToString(dossier.class_personnel_fulltime);
//            d.Continuation_Date__c = validDate(dossier.continuation_date);
//            d.Discontinuation_Date__c = validDate(dossier.discontinuation_date);
//            d.Establishment_Date__c = validDate(dossier.establishment_date);
//            d.Founding_Date__c = validDate(dossier.founding_date);
//            d.Issued_Share_Capital__c = convertToInteger(dossier.issued_share_capital);
//            d.Issued_Share_Capital_Currency__c = dossier.issued_share_capital_currency;
//            d.Paid_Up_Share_Capital__c = convertToInteger(dossier.paid_up_share_capital);
//            d.Paid_Up_Share_Capital_Currency__c = dossier.paid_up_share_capital_currency;
//            d.Personnel__c = dossier.personnel;
//            d.Personnel_Fulltime__c = dossier.personnel_fulltime;
//            d.Personnel_Reference_Date__c = validDate(dossier.personnel_reference_date);
//            d.Primary_Sbi_Code__c = dossier.primary_sbi_code;
//            d.Primary_Sbi_Code_Text__c = dossier.primary_sbi_code_text;
//            d.Secondary_Sbi_Code_1__c = dossier.secondary_sbi_code1;
//            d.Secondary_Sbi_Code_1_Text__c = dossier.secondary_sbi_code1_text;
//            d.Secondary_Sbi_Code_2__c = dossier.secondary_sbi_code2;
//            d.Secondary_Sbi_Code_2_Text__c = dossier.secondary_sbi_code2_text;
//
//            d.Chamber_Code__c = dossier.chamber_number;
//            d.Status__c = determineStatus(dossier);
//
//            d.Annual_Financial_Statement_Summary__c = dossier.annual_financial_statement_summary;
//            d.Year__c = dossier.annual_financial_statement_summary_year;
//            d.Profit__c = dossier.annual_financial_statement_summary_profit;
//            d.Turnover__c = dossier.annual_financial_statement_summary_turnover;
//            d.Assets__c = dossier.annual_financial_statement_summary_assets;
//
//            d.Personnel_CI__c = dossier.personnel_ci;
//            d.Class_Personnel_CI__c = convertToString(dossier.class_personnel_ci);
//            d.Personnel_CI_Reference_Date__c = validDate(dossier.personnel_ci_reference_date);
//            d.Contact_Initials__c = dossier.contact_initials;
//            d.Contact_Prefix__c = dossier.contact_prefix;
//            d.Contact_Surname__c = dossier.contact_surname;
//            d.Contact_Title1__c = dossier.contact_title1;
//            d.Contact_Title2__c = dossier.contact_title2;
//            d.Contact_Gender__c = dossier.contact_gender;
//            if (dossier.indication_bankruptcy != null) { d.Indication_Bankruptcy__c = dossier.indication_bankruptcy;}
//            if (dossier.indication_dip != null) { d.Indication_Dip__c = dossier.indication_dip;}
//            if (dossier.indication_economically_active != null) { d.Indication_Economically_Active__c = dossier.indication_economically_active;}
//            if (dossier.indication_export != null) { d.Indication_Export__c = dossier.indication_export;}
//            if (dossier.indication_import != null) { d.Indication_Import__c = dossier.indication_import;}
//            if (dossier.indication_main_establishment != null) { d.Indication_Main_Establishment__c = dossier.indication_main_establishment;}
//            if (dossier.indication_non_mailing != null) { d.Indication_Non_Mailing__c = dossier.indication_non_mailing;}
//            d.Insolvencies__c = dossier.insolvencies;
//
//            //d.Sbi_Collection__c = dossier.sbi_collection;
//
//            d.Structure__c = dossier.structure;
//            d.Number_Of_Subsidiaries__c = dossier.structure_number_of_subsidiaries;
//            d.Parent_Chamber_Of_Commerce_Number__c = dossier.structure_parent;
//            d.Ultimate_Parent_Chamber_Of_Commerce_Nr__c = dossier.structure_ultimate_parent;
//
//            if(dossierExists){
//                unitOfWork.registerDirty(d, Business_Dossier__c.Account__c, acc);
//            }else{
//                unitOfWork.registerNew(d, Business_Dossier__c.Account__c, acc);
//            }
//
//            // let's do the addresses
//            List<Dossier_Address__c> adds = DossierAddressSelector.newInstance().selectByDossierId(new set<Id>{d.Id});
//
//            Dossier_Address__c establishmentAddress = new Dossier_Address__c();
//            Dossier_Address__c correspondenceAddress =  new Dossier_Address__c();
//            for (Dossier_Address__c dossierAddress : adds) {
//                if (dossierAddress.Type__c == 'Establishment') {
//                    establishmentAddress = dossierAddress;
//                } else
//                        if (dossierAddress.Type__c == 'Correspondence') {
//                            correspondenceAddress = dossierAddress;
//                        }
//            }
//
//            establishmentAddress.Name = dossier.establishment_address_original_postcode + ' ' + dossier.establishment_address_original_street; //dossier.establishment_address_original_address;
//            establishmentAddress.Postcode__c = dossier.establishment_address_original_postcode;
//            establishmentAddress.Street__c = dossier.establishment_address_original_street;
//            establishmentAddress.City__c = dossier.establishment_address_original_city;
//            establishmentAddress.House_Number__c = String.valueOf(dossier.establishment_address_original_house_number);
//            establishmentAddress.House_Number_Addition__c = dossier.establishment_address_original_house_number_addition;
//            establishmentAddress.Country__c = dossier.establishment_address_original_country;
//            establishmentAddress.Type__c = 'Establishment';
//
//            correspondenceAddress.Name = dossier.correspondence_address_original_postcode + ' ' + dossier.correspondence_address_original_street; //dossier.correspondence_address_original_address;
//            correspondenceAddress.Postcode__c = dossier.correspondence_address_original_postcode;
//            correspondenceAddress.Street__c = dossier.correspondence_address_original_street;
//            correspondenceAddress.City__c = dossier.correspondence_address_original_city;
//            correspondenceAddress.House_Number__c = String.valueOf(dossier.correspondence_address_original_house_number);
//            correspondenceAddress.House_Number_Addition__c = dossier.correspondence_address_original_house_number_addition;
//            correspondenceAddress.Country__c = dossier.correspondence_address_original_country;
//            correspondenceAddress.Type__c = 'Correspondence';
//
//            if(correspondenceAddress.Id != null){
//                unitOfWork.registerDirty(correspondenceAddress, Dossier_Address__c.Business_Data__c, d);
//            }else{
//                unitOfWork.registerNew(correspondenceAddress, Dossier_Address__c.Business_Data__c, d);
//            }
//
//            if(establishmentAddress.Id != null){
//                unitOfWork.registerDirty(establishmentAddress, Dossier_Address__c.Business_Data__c, d);
//            }else{
//                unitOfWork.registerNew(establishmentAddress, Dossier_Address__c.Business_Data__c, d);
//            }
//
//            // now the sbi collections:
//            List<Business_Data_SBI__c> sbiCodesDB = SbiCodeSelector.newInstance().selectByDossierId(new set<Id>{d.Id});
//
//            // let's see if there are existing SBI collections
//            // create a map for easy search
//            if (sbiCodesDB.size() > 0 && dossier.sbi_collection != null) {
//                // handle new SBI codes
//                Map<String, Business_Data_SBI__c> sbiCodesByTypeAndCode = new Map<String, Business_Data_SBI__c>();
//                for (Business_Data_SBI__c businessDataSBI : sbiCodesDB) {
//                    sbiCodesByTypeAndCode.put(businessDataSBI.SBI_Code__c + businessDataSBI.SBI_Type__c, businessDataSBI);
//                }
//                List<Business_Data_SBI__c> newSbiCodes = new List<Business_Data_SBI__c>();
//                for (Integer i = 0; i < dossier.sbi_collection.size(); i++) {
//                    // if the code of the SBI collection is existing in the fetched info don't do anything with it
//                    if (sbiCodesByTypeAndCode.get(dossier.sbi_collection[i].SBI_Code__c + dossier.sbi_collection[i].SBI_Type__c) == null) {
//                        newSbiCodes.add(dossier.sbi_collection[i]);
//                    }
//                }
//                for (Business_Data_SBI__c businessDataSBI : newSbiCodes) {
//                    unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, d);
//                }
//
//                // handle deleted SBI codes
//                Map<String, Business_Data_SBI__c> sbiCodesFromDataVendorByTypeAndCode = new Map<String, Business_Data_SBI__c>();
//                for (Business_Data_SBI__c businessDataSBI : dossier.sbi_collection) {
//                    sbiCodesFromDataVendorByTypeAndCode.put(businessDataSBI.SBI_Code__c + businessDataSBI.SBI_Type__c, businessDataSBI);
//                }
//                List<Business_Data_SBI__c> sbiCodesToBeDeleted = new List<Business_Data_SBI__c>();
//                for (Integer i = 0; i < sbiCodesDB.size() ; i++) {
//                    if (sbiCodesFromDataVendorByTypeAndCode.get(sbiCodesDB[i].SBI_Code__c + sbiCodesDB[i].SBI_Type__c) == null) { // the sbi code is not present in what we got from the vendor
//                        sbiCodesToBeDeleted.add(sbiCodesDB[i]);
//                    }
//                }
//                unitOfWork.registerDeleted(sbiCodesToBeDeleted);
//            } else { // no existing SBI records
//                // just add all SBI records we got from the database
//                for (Business_Data_SBI__c businessDataSBI : dossier.sbi_collection) {
//                    unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, d);
//                }
//            }
//
//            return d;
//        }catch(System.Exception ex){
//            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
//            System.debug('Exception:' +  ex.getStackTraceString());
//            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
//        }
//    }

}