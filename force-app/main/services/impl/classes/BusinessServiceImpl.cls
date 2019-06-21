/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/
public with sharing class BusinessServiceImpl implements IBusinessService {

    public List<Business_Dossier__c> insertDossier(List<InsertDossierRequestDTO> InsertDossierRequestDTOS) {
        List<Business_Dossier__c> returnList = new List<Business_Dossier__c>();
        for (InsertDossierRequestDTO insertDossierRequestDTO : InsertDossierRequestDTOS) {
            // returnList.add(map());
        }
        return returnList;
    }

    //DutchBusinessDto.DutchBusinessGetDossierResponse dossier
    public static List<Object> upsertAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){

        try{
            List<Object> result = new List<Object>();
            // Jaap Branderhorst: removed DMLWithCrud since saving the data should run in system context, not in user context (enforcing CRUD and FLS).
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
            List<String> existinAccountIds;
            Account acc = createAccountForDossier(accountId, dossier, unitOfWork);
            Business_Dossier__c d = saveBusinessDossierUow(dossier, acc, unitOfWork);
            //unitOfWork.registerRelationship(acc, Account.Business_Dossier__c, d);
            unitOfWork.commitWork();
            //unitOfWork.registerDirty(acc, Account.Business_Dossier__c, d); // to update a field on account level once dossier is inserted
            //unitOfWork.commitWork(); // need to wait until circullar references are releassed ion fflib. so far using another method link: https://github.com/financialforcedev/fflib-apex-common/pull/195
            // TODO wtf....using a List for this? Use a DTO
            result.add(d);
            result.add(acc);
            return result;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    public static Account getDossierAccount(String dossierNum){
        try{
            //TODO: enhance with duplicate logic. mb account is there but has no dossier
            List<Business_Dossier__c> dossList = new List<Business_Dossier__c>();

            //set<Integer> dossNumSet = new set<Integer>();
            //dossNumSet.add(Integer.valueOf(dossierNum));
            dossList = BusinessDossierSelector.newInstance().selectByDossierNumber(new set<String>{dossierNum});
            //dossList =  [SELECT ID, Name, Account__r.name,  Account__r.Id FROM Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossierNum)];//TO DO: move to selector
            Account acc;
            List<Account> accList = new List<Account>();
            if(dossList.size() >0){
                set<Id> accIdSet=new set<Id>();
                for(Business_Dossier__c dbd: dossList){
                    accIdSet.add(dbd.Account__c);
                }
                accList = AccountSelector.newInstance().selectById(accIdSet);
                return accList.get(0);
            }
            //if(dossList.size()>1){
            //todo: log a warning  that one dossier per system allowed?
            //}
            return acc;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }


    private static Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork){
        try{
            List<String> existinAccountIds = new List<String>();
            Account acc = new Account();

            if(accountId == null || AccountId == ''){ // create an account
                existinAccountIds = checkForAccountDuplicates(acc);
                system.debug('existinAccountIds = '+ existinAccountIds);
                if(existinAccountIds.size()>0){ // dup found -> need to update
                    acc.Id = existinAccountIds.get(0);
                    unitOfWork.registerDirty(acc);
                }else{ // new account
                    acc.Name = dossier.trade_name_full;
                    unitOfWork.registerNew(acc);
                }
            }else{// update an account
                acc.Id = AccountId;
                unitOfWork.registerDirty(acc);
            }
            return acc;

        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    // checks for account duplicates. Return a List of IDs if duplicates exist.
    private static List<String> checkForAccountDuplicates(Account acc){
        List<String> result = new List<String>();
        List<Account> accounts = new List<Account>();
        accounts.add(acc);
        try{
            Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(accounts);
            for (Datacloud.FindDuplicatesResult dupeResult : results) {
                for (Datacloud.DuplicateResult dupeRes : dupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchRes : dupeRes.getMatchResults()) {
                        for (Datacloud.MatchRecord matchRec : matchRes.getMatchRecords()) {
                            result.add((string)matchRec.getRecord().get('id'));
                        }
                    }
                }
            }
        }catch(System.HandledException e){
            system.debug('exception = '+e);
            //return result;
            //expected, no dup rules for account are active
        }
        return result;
    }

    private static Business_Dossier__c saveBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork) {
        try{
            List<Business_Dossier__c> dbds = BusinessDossierSelector.newInstance().selectByDossierNumbers(new Set<DossierQueryDTO>{new DossierQueryDTO(dossier.dossier_number, dossier.establishment_number)}, false);
            String trade_names = '';
            if (dossier.trade_names != null && dossier.trade_names.size() > 0) {
                // Condense all trade names into single field, seperated by new lines.
                for (Integer i = 0; i < dossier.trade_names.size(); i++) {
                    trade_names += dossier.trade_names[i] + (i == dossier.trade_names.size()-1 ? '' : ', ');
                }

            }
            System.debug(dbds);
            Boolean dossierExists = dbds.size() == 1 ? true : false;
            Business_Dossier__c d = dossierExists ? (Business_Dossier__c)dbds[0] : new Business_Dossier__c();

            // if we will need legal name on name field
            if(dossier.legal_name != null && dossier.legal_name != ''){
                d.Name = dossier.legal_name;//dossier.legal_name;
            }else{
                d.Name = dossier.trade_name_full;//dossier.legal_name;
            }
            //d.Name = dossier.trade_name_full;
            d.Dossier_Number__c = dossier.dossier_number;
            d.Establishment_Number__c = dossier.establishment_number;
            d.Main_Establishment_Number__c = dossier.main_establishment_number;
            d.Indication_Main_Establishment__c = dossier.indication_main_establishment; //convertToBoolean(dossier.indication_main_establishment);
            d.Rsin_Number__c = String.valueOf(dossier.rsin_number);
            d.Chamber_Number__c = convertToInteger(dossier.chamber_number);
            d.Legal_Form_Code__c = convertToInteger(dossier.legal_form_code);
            d.Legal_Form_Text__c = dossier.legal_form_text;//;convertToString(dossier.legal_form_text);
            d.Indication_Organisation_Code__c = dossier.indication_organisation_code;//convertToString(dossier.indication_organisation_code);
            d.Trade_Name_45__c = dossier.trade_name_45;
            d.Trade_Name_Full__c = dossier.trade_name_full;
            d.Trade_Names__c = trade_names;
            d.Telephone_Number__c = dossier.telephone_number;
            d.Mobile_Number__c = dossier.mobile_number;
            d.Domain_Name__c = dossier.domain_name;

            d.Authorized_Share_Capital__c = dossier.authorized_share_capital;
            d.Authorized_Share_Capital_Currency__c = dossier.authorized_share_capital_currency;
            d.Class_Personnel__c = convertToString(dossier.class_personnel);
            d.Class_Personnel_Fulltime__c = convertToString(dossier.class_personnel_fulltime);
            d.Continuation_Date__c = validDate(dossier.continuation_date);
            d.Discontinuation_Date__c = validDate(dossier.discontinuation_date);
            d.Establishment_Date__c = validDate(dossier.establishment_date);
            d.Founding_Date__c = validDate(dossier.founding_date);
            d.Issued_Share_Capital__c = convertToInteger(dossier.issued_share_capital);
            d.Issued_Share_Capital_Currency__c = dossier.issued_share_capital_currency;
            d.Paid_Up_Share_Capital__c = convertToInteger(dossier.paid_up_share_capital);
            d.Paid_Up_Share_Capital_Currency__c = dossier.paid_up_share_capital_currency;
            d.Personnel__c = dossier.personnel;
            d.Personnel_Fulltime__c = dossier.personnel_fulltime;
            d.Personnel_Reference_Date__c = validDate(dossier.personnel_reference_date);
            d.Primary_Sbi_Code__c = dossier.primary_sbi_code;
            d.Primary_Sbi_Code_Text__c = dossier.primary_sbi_code_text;
            d.Secondary_Sbi_Code_1__c = dossier.secondary_sbi_code1;
            d.Secondary_Sbi_Code_1_Text__c = dossier.secondary_sbi_code1_text;
            d.Secondary_Sbi_Code_2__c = dossier.secondary_sbi_code2;
            d.Secondary_Sbi_Code_2_Text__c = dossier.secondary_sbi_code2_text;

            d.Chamber_Code__c = dossier.chamber_number;
            d.Status__c = determineStatus(dossier);

            d.Annual_Financial_Statement_Summary__c = dossier.annual_financial_statement_summary;
            d.Year__c = dossier.annual_financial_statement_summary_year;
            d.Profit__c = dossier.annual_financial_statement_summary_profit;
            d.Turnover__c = dossier.annual_financial_statement_summary_turnover;
            d.Assets__c = dossier.annual_financial_statement_summary_assets;

            d.Personnel_CI__c = dossier.personnel_ci;
            d.Class_Personnel_CI__c = convertToString(dossier.class_personnel_ci);
            d.Personnel_CI_Reference_Date__c = validDate(dossier.personnel_ci_reference_date);
            d.Contact_Initials__c = dossier.contact_initials;
            d.Contact_Prefix__c = dossier.contact_prefix;
            d.Contact_Surname__c = dossier.contact_surname;
            d.Contact_Title1__c = dossier.contact_title1;
            d.Contact_Title2__c = dossier.contact_title2;
            d.Contact_Gender__c = dossier.contact_gender;
            if (dossier.indication_bankruptcy != null) { d.Indication_Bankruptcy__c = dossier.indication_bankruptcy;}
            if (dossier.indication_dip != null) { d.Indication_Dip__c = dossier.indication_dip;}
            if (dossier.indication_economically_active != null) { d.Indication_Economically_Active__c = dossier.indication_economically_active;}
            if (dossier.indication_export != null) { d.Indication_Export__c = dossier.indication_export;}
            if (dossier.indication_import != null) { d.Indication_Import__c = dossier.indication_import;}
            if (dossier.indication_main_establishment != null) { d.Indication_Main_Establishment__c = dossier.indication_main_establishment;}
            if (dossier.indication_non_mailing != null) { d.Indication_Non_Mailing__c = dossier.indication_non_mailing;}
            d.Insolvencies__c = dossier.insolvencies;

            //d.Sbi_Collection__c = dossier.sbi_collection;

            d.Structure__c = dossier.structure;
            d.Number_Of_Subsidiaries__c = dossier.structure_number_of_subsidiaries;
            d.Parent_Chamber_Of_Commerce_Number__c = dossier.structure_parent;
            d.Ultimate_Parent_Chamber_Of_Commerce_Nr__c = dossier.structure_ultimate_parent;

            if(dossierExists){
                unitOfWork.registerDirty(d, Business_Dossier__c.Account__c, acc);
            }else{
                unitOfWork.registerNew(d, Business_Dossier__c.Account__c, acc);
            }

            // let's do the addresses
            List<Dossier_Address__c> adds = DossierAddressSelector.newInstance().selectByDossierId(new set<Id>{d.Id});

            Dossier_Address__c establishmentAddress = new Dossier_Address__c();
            Dossier_Address__c correspondenceAddress =  new Dossier_Address__c();
            for (Dossier_Address__c dossierAddress : adds) {
                if (dossierAddress.Type__c == 'Establishment') {
                    establishmentAddress = dossierAddress;
                } else
                        if (dossierAddress.Type__c == 'Correspondence') {
                            correspondenceAddress = dossierAddress;
                        }
            }

            establishmentAddress.Name = dossier.establishment_address_original_postcode + ' ' + dossier.establishment_address_original_street; //dossier.establishment_address_original_address;
            establishmentAddress.Postcode__c = dossier.establishment_address_original_postcode;
            establishmentAddress.Street__c = dossier.establishment_address_original_street;
            establishmentAddress.City__c = dossier.establishment_address_original_city;
            establishmentAddress.House_Number__c = String.valueOf(dossier.establishment_address_original_house_number);
            establishmentAddress.House_Number_Addition__c = dossier.establishment_address_original_house_number_addition;
            establishmentAddress.Country__c = dossier.establishment_address_original_country;
            establishmentAddress.Type__c = 'Establishment';

            correspondenceAddress.Name = dossier.correspondence_address_original_postcode + ' ' + dossier.correspondence_address_original_street; //dossier.correspondence_address_original_address;
            correspondenceAddress.Postcode__c = dossier.correspondence_address_original_postcode;
            correspondenceAddress.Street__c = dossier.correspondence_address_original_street;
            correspondenceAddress.City__c = dossier.correspondence_address_original_city;
            correspondenceAddress.House_Number__c = String.valueOf(dossier.correspondence_address_original_house_number);
            correspondenceAddress.House_Number_Addition__c = dossier.correspondence_address_original_house_number_addition;
            correspondenceAddress.Country__c = dossier.correspondence_address_original_country;
            correspondenceAddress.Type__c = 'Correspondence';

            if(correspondenceAddress.Id != null){
                unitOfWork.registerDirty(correspondenceAddress, Dossier_Address__c.Business_Data__c, d);
            }else{
                unitOfWork.registerNew(correspondenceAddress, Dossier_Address__c.Business_Data__c, d);
            }

            if(establishmentAddress.Id != null){
                unitOfWork.registerDirty(establishmentAddress, Dossier_Address__c.Business_Data__c, d);
            }else{
                unitOfWork.registerNew(establishmentAddress, Dossier_Address__c.Business_Data__c, d);
            }

            // now the sbi collections:
            List<Business_Data_SBI__c> sbiCodesDB = SbiCodeSelector.newInstance().selectByDossierId(new set<Id>{d.Id});

            // let's see if there are existing SBI collections
            // create a map for easy search
            if (sbiCodesDB.size() > 0 && dossier.sbi_collection != null) {
                // handle new SBI codes
                Map<String, Business_Data_SBI__c> sbiCodesByTypeAndCode = new Map<String, Business_Data_SBI__c>();
                for (Business_Data_SBI__c businessDataSBI : sbiCodesDB) {
                    sbiCodesByTypeAndCode.put(businessDataSBI.SBI_Code__c + businessDataSBI.SBI_Type__c, businessDataSBI);
                }
                List<Business_Data_SBI__c> newSbiCodes = new List<Business_Data_SBI__c>();
                for (Integer i = 0; i < dossier.sbi_collection.size(); i++) {
                    // if the code of the SBI collection is existing in the fetched info don't do anything with it
                    if (sbiCodesByTypeAndCode.get(dossier.sbi_collection[i].SBI_Code__c + dossier.sbi_collection[i].SBI_Type__c) == null) {
                        newSbiCodes.add(dossier.sbi_collection[i]);
                    }
                }
                for (Business_Data_SBI__c businessDataSBI : newSbiCodes) {
                    unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, d);
                }

                // handle deleted SBI codes
                Map<String, Business_Data_SBI__c> sbiCodesFromDataVendorByTypeAndCode = new Map<String, Business_Data_SBI__c>();
                for (Business_Data_SBI__c businessDataSBI : dossier.sbi_collection) {
                    sbiCodesFromDataVendorByTypeAndCode.put(businessDataSBI.SBI_Code__c + businessDataSBI.SBI_Type__c, businessDataSBI);
                }
                List<Business_Data_SBI__c> sbiCodesToBeDeleted = new List<Business_Data_SBI__c>();
                for (Integer i = 0; i < sbiCodesDB.size() ; i++) {
                    if (sbiCodesFromDataVendorByTypeAndCode.get(sbiCodesDB[i].SBI_Code__c + sbiCodesDB[i].SBI_Type__c) == null) { // the sbi code is not present in what we got from the vendor
                        sbiCodesToBeDeleted.add(sbiCodesDB[i]);
                    }
                }
                unitOfWork.registerDeleted(sbiCodesToBeDeleted);
            } else { // no existing SBI records
                // just add all SBI records we got from the database
                for (Business_Data_SBI__c businessDataSBI : dossier.sbi_collection) {
                    unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, d);
                }
            }

            return d;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            System.debug('Exception:' +  ex.getStackTraceString());
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    private static Date validDate(Date theDate) {
        if (theDate == null) return null;
        Date d = Date.valueOf(theDate);
        if (d.year() < 1000) return null;
        return d;
    }

    // method to skip doing if for every value
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
    // method to skip doing if for every value
    private static Boolean convertToBoolean(String value){
        try{
            return Boolean.valueOf(value);
        }catch(Exception e){
            return null;
        }
    }

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
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    public static DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber, String establishmentNumber) {
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
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    // TODO: rewrite properly, the method should notify if there were problems during update TODO: MOVE STUFF TO SELECTOR AND UOW
    // was void before. not tyoo logical to return dossier Id from this method. Cut the corner to both get dossierId for  controller and Not research how to handle void methods  with this framework
    public static String updateAccountDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier) {
        try{
            List<Business_Dossier__c> dossierList = BusinessDossierSelector.newInstance().selectByDossierNumbers(new Set<DossierQueryDTO>{new DossierQueryDTO(dossier.dossier_number, dossier.establishment_number)}, false);
            List<Account> accts = AccountSelector.newInstance().selectById(new set<Id>{dossierList.get(0).Account__c});
            if (accts.size() == 1) {
                accts[0].Business_Dossier__c = dossierList.get(0).Id;
                update accts; // TODO: move to UOW
            }
            return dossierList.get(0).Id;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
        //return null;
    }

    public static Boolean deleteDossier(Id accountId) {
        try{
            Account acct = AccountSelector.newInstance().selectById(accountId);
            List<Business_Dossier__c> dossierList = BusinessDossierSelector.newInstance().selectById(new set<Id>{acct.Business_Dossier__c});
            if (dossierList.size() == 1) {
                delete dossierList[0];
                return true;
            }
            return false;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
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

    public static DutchBusinessDto.DutchBusinessVatNumber requestVAT(String dossierNumber) {
        IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
        DutchBusinessDto.DutchBusinessGetVatNumberRequest requestParams = new DutchBusinessDto.DutchBusinessGetVatNumberRequest();// = new DutchBusinessDto.DutchBusinessGetDossierRequest(dossier_number = dossierNumber, establishment_number = null);
        requestParams.dossier_number = dossierNumber;
        return service.businessGetVatNumber(requestParams);
    }

    public static List<Object> upsertDossier(Business_Dossier__c dossier){

        try{
            List<Object> result = new List<Object>();
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance(new DMLWithCrud());
            unitOfWork.registerDirty(dossier);
            unitOfWork.commitWork();
            result.add(dossier);
            return result;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }
    // TODO: rewrite properly, the method should notify if there were problems during update
    /*public static boolean updateAccountDossier(Id accountId, Id dossierId) {
        try{
            List<Account> accts = [SELECT Id, Business_Dossier__c FROM Account WHERE Id = :accountId];
            if (accts.size() == 1 && dossierId != NULL) {
                accts[0].Business_Dossier__c = dossierId;
                update accts;
            }
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }


    private static Boolean checkAccess() {
        List<String> fields = new List<String>{'Name','Establishment_Number__c','Main_Establishment_Number__c',
        'Indication_Main_Establishment__c','Rsin_Number__c','Chamber_Number__c','Legal_Form_Code__c','Legal_Form_Text__c','Indication_Organisation_Code__c',
        'Trade_Name_45__c','Trade_Name_Full__c','Trade_Names__c','Telephone_Number__c','Mobile_Number__c','Domain_Name__c','Authorized_Share_Capital__c',
        'Authorized_Share_Capital_Currency__c','Class_Personnel__c','Class_Personnel_Fulltime__c','Continuation_Date__c','Discontinuation_Date__c','Establishment_Date__c',
        'Founding_Date__c','Issued_Share_Capital__c','Issued_Share_Capital_Currency__c','Paid_Up_Share_Capital__c','Paid_Up_Share_Capital_Currency__c',
        'Personnel__c','Personnel_Fulltime__c','Personnel_Reference_Date__c','Primary_Sbi_Code__c','Primary_Sbi_Code_Text__c','Secondary_Sbi_Code_1__c',
        'Secondary_Sbi_Code_1_Text__c','Secondary_Sbi_Code_2__c','Secondary_Sbi_Code_2_Text__c','Status__c'};

        Schema.sObjectType.Business_Dossier__c.fields.getMap();

        Schema.DescribeSObjectResult a_desc = Business_Dossier__c.sObjectType.getDescribe();
        //for the Account object, you can replace that with any object you have, standard or custom
        Map<String, Schema.SObjectField> a_fields = a_desc.fields.getMap();

        for(Schema.sObjectField fld: a_fields.values()){
            if (fld.getDescribe().isUpdateable() == false && fields.contains(fld.getDescribe().getName())) {
                return false;
            }
        }


        return true;
    }
*/
    /* public static Id saveDutchBusinessDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Id accountId) { // delete?

         try{
             if (Schema.sObjectType.Business_Dossier__c.fields.Id.isAccessible() == false ||
                 Schema.sObjectType.Business_Dossier__c.fields.Account__c.isAccessible() == false ||
                 checkAccess() == false) throw new NoAccessException();

             List<Business_Dossier__c> dbds = [SELECT Id, Account__c FROM Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossier.dossier_number)];
             Business_Dossier__c d;

             if(accountId == null){

             }

             String trade_names = '';
             if (dossier.trade_names != null && dossier.trade_names.size() > 0) {
                 // Condense all trade names into single field, seperated by new lines.
                 for (Integer i = 0; i < dossier.trade_names.size(); i++) {
                     trade_names += dossier.trade_names[i] + '/n';
                 }
             }

             if (dbds.size() < 1) {
                 d = new Business_Dossier__c();
                 d.Account__c = accountId;
             }
             else {
                 d = dbds[0];
                 if (d.Account__c !=  accountId) {
                     throw new AuraHandledException('Dossier is already allocated to another Account');
                 }
             }

             // @todo add addresses and contact.
             system.debug('VPROK tests dosier = '+ dossier);
             d.Name = dossier.trade_name_full;//dossier.legal_name;
             d.Dossier_Number__c = Integer.valueOf(dossier.dossier_number);
             d.Establishment_Number__c = Integer.valueOf(dossier.establishment_number);
             d.Main_Establishment_Number__c = Integer.valueOf(dossier.main_establishment_number);
             d.Indication_Main_Establishment__c = Boolean.valueOf(dossier.indication_main_establishment);
             if(dossier.rsin_number != null){d.Rsin_Number__c = Integer.valueOf(dossier.rsin_number);}
             if(dossier.chamber_number != null){d.Chamber_Number__c = Integer.valueOf(dossier.chamber_number);}
             if(dossier.legal_form_code != null){d.Legal_Form_Code__c = Integer.valueOf(dossier.legal_form_code);}
             if(dossier.legal_form_text != null){d.Legal_Form_Text__c = String.valueOf(dossier.legal_form_text);}
             if(dossier.indication_organisation_code != null){d.Indication_Organisation_Code__c = String.valueOf(dossier.indication_organisation_code);}
             d.Trade_Name_45__c = dossier.trade_name_45;
             d.Trade_Name_Full__c = dossier.trade_name_full;
             d.Trade_Names__c = trade_names;
             d.Telephone_Number__c = dossier.telephone_number;
             d.Mobile_Number__c = dossier.mobile_number;
             d.Domain_Name__c = dossier.domain_name;

             d.Authorized_Share_Capital__c = dossier.authorized_share_capital;
             d.Authorized_Share_Capital_Currency__c = dossier.authorized_share_capital_currency;
             if(dossier.class_personnel != null){d.Class_Personnel__c = String.valueOf(dossier.class_personnel);}
             if(dossier.class_personnel_fulltime != null){d.Class_Personnel_Fulltime__c = String.valueOf(dossier.class_personnel_fulltime);}
             if(dossier.continuation_date != null){d.Continuation_Date__c = dossier.continuation_date;}
             if(dossier.discontinuation_date != null){d.Discontinuation_Date__c = dossier.discontinuation_date;}
             if(dossier.establishment_date != null){d.Establishment_Date__c = dossier.establishment_date;}
             if(dossier.founding_date != null){d.Founding_Date__c = dossier.founding_date;}
             if(dossier.issued_share_capital != null){d.Issued_Share_Capital__c = Integer.valueOf(dossier.issued_share_capital);}
             d.Issued_Share_Capital_Currency__c = dossier.issued_share_capital_currency;
             if(dossier.paid_up_share_capital != null){d.Paid_Up_Share_Capital__c = Integer.valueOf(dossier.paid_up_share_capital);}
             d.Paid_Up_Share_Capital_Currency__c = dossier.paid_up_share_capital_currency;
             d.Personnel__c = dossier.personnel;
             d.Personnel_Fulltime__c = dossier.personnel_fulltime;
             if(dossier.personnel_reference_date != null){d.Personnel_Reference_Date__c = dossier.personnel_reference_date;}
             d.Primary_Sbi_Code__c = dossier.primary_sbi_code;
             d.Primary_Sbi_Code_Text__c = dossier.primary_sbi_code_text;
             d.Secondary_Sbi_Code_1__c = dossier.secondary_sbi_code1;
             d.Secondary_Sbi_Code_1_Text__c = dossier.secondary_sbi_code1_text;
             d.Secondary_Sbi_Code_2__c = dossier.secondary_sbi_code2;
             d.Secondary_Sbi_Code_2_Text__c = dossier.secondary_sbi_code2_text;

             if(dossier.chamber_number != null){d.Chamber_Code__c = String.valueOf(dossier.chamber_number);}
             d.Status__c = determineStatus(dossier);

             upsert d;
             return d.Id;
         }catch(CCException ex){
             throw ex; // we dont log bds exceptions, only throwing them further
         }catch(System.Exception ex){
             ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
             throw new CCException(System.Label.WSCall_Unknown_Exception+ex.getMessage(), ex);
         }Something happened while working at the DutchBusinessService levelInsert failed. First exception on row 0; first error: INVALID_TYPE_ON_FIELD_IN_RECORD, Indication Bankruptcy: value not of required type: : [cinfo_sales__Indication_Bankruptcy__c]
     }*/
    private static String determineStatus(DutchBusinessDto.DutchBusinessGetDossierResponse dossier) {
        try{
            List<String> status = new List<String>();
            if (dossier.indication_import != null && Boolean.valueOf(dossier.indication_import) == true) status.add('Import');
            if (dossier.indication_export != null && Boolean.valueOf(dossier.indication_export) == true) status.add('Export');
            if (dossier.indication_economically_active != null && Boolean.valueOf(dossier.indication_economically_active) == true) status.add('Economically Active');
            if (dossier.indication_non_mailing != null && Boolean.valueOf(dossier.indication_non_mailing) == true) status.add('Non Mailing');
            if (dossier.indication_bankruptcy != null && Boolean.valueOf(dossier.indication_bankruptcy) == true) status.add('Bankruptcy');
            if (dossier.indication_dip != null && Boolean.valueOf(dossier.indication_dip) == true) status.add('DIP');
            return String.join(status, ';');
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.WSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

}