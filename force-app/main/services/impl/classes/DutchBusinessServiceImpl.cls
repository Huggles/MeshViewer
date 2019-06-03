/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/
public with sharing class DutchBusinessServiceImpl implements IDutchBusinessService {

    //DutchBusinessDto.DutchBusinessGetDossierResponse dossier
    public static list<Object> upsertAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){

        try{
            list<Object> result = new list<Object>();
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance(new DMLWithCrud());
            list<String> existinAccountIds;
            Account acc = createAccountForDossier(accountId, dossier, unitOfWork);
            Dutch_Business_Dossier__c d = saveDutchBusinessDossierUow(dossier, acc, unitOfWork);
            //unitOfWork.registerRelationship(acc, Account.Dutch_Business_Dossier__c, d);
            unitOfWork.commitWork();
            //unitOfWork.registerDirty(acc, Account.Dutch_Business_Dossier__c, d); // to update a field on account level once dossier is inserted
            //unitOfWork.commitWork(); // need to wait until circullar references are releassed ion fflib. so far using another method link: https://github.com/financialforcedev/fflib-apex-common/pull/195
            result.add(d);
            result.add(acc);
            return result;
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    public static Account getDossierAccount(String dossierNum){
        try{
            //TODO: enhance with duplicate logic. mb account is there but has no dossier
            list<Dutch_Business_Dossier__c> dossList = new list<Dutch_Business_Dossier__c>();

            //set<Integer> dossNumSet = new set<Integer>();
            //dossNumSet.add(Integer.valueOf(dossierNum));
            dossList = DutchBusinessDossierSelector.newInstance().selectByDossierNumber(new set<String>{dossierNum});
            //dossList =  [SELECT ID, Name, Account__r.name,  Account__r.Id FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossierNum)];//TO DO: move to selector
            Account acc;
            list<Account> accList = new list<Account>();
            if(dossList.size() >0){
                set<Id> accIdSet=new set<Id>();
                for(Dutch_Business_Dossier__c dbd: dossList){
                    accIdSet.add(dbd.Account__c);
                }
                accList = AccountSelector.newInstance().selectById(accIdSet);
                return accList.get(0);
            }
            //if(dossList.size()>1){
            //todo: log a warning  that one dossier per system allowed?
            //}
            return acc;
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }


    private static Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork){
        try{
            list<String> existinAccountIds = new list<String>();
            Account acc = new Account();
            acc.Name = dossier.trade_name_full;
            if(accountId == null || AccountId == ''){ // create an account
                existinAccountIds = checkForAccountDuplicates(acc);
                system.debug('existinAccountIds = '+ existinAccountIds);
                if(existinAccountIds.size()>0){ // dup found -> need to update
                    acc.Id = existinAccountIds.get(0);
                    unitOfWork.registerDirty(acc);
                }else{ // new account
                    unitOfWork.registerNew(acc);
                }
            }else{// update an account
                acc.Id = AccountId;
                unitOfWork.registerDirty(acc);
            }
            return acc;

        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    // checks for account duplicates. Return a list of IDs if duplicates exist.
    private static list<String> checkForAccountDuplicates(Account acc){
        list<String> result = new list<String>();
        list<Account> accounts = new list<Account>();
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



    private static Dutch_Business_Dossier__c saveDutchBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork) {
        try{
            boolean dossierExists = false;
            // TODO: move to selector
            //List<Dutch_Business_Dossier__c> dbds = [SELECT Id, Account__c FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossier.dossier_number)];

            list<Dutch_Business_Dossier__c> dbds = DutchBusinessDossierSelector.newInstance().selectByDossierNumber(new set<String>{dossier.dossier_number});



            Dutch_Business_Dossier__c d;

            String trade_names = '';
            if (dossier.trade_names != null && dossier.trade_names.size() > 0) {
                // Condense all trade names into single field, seperated by new lines.
                for (Integer i = 0; i < dossier.trade_names.size(); i++) {
                    trade_names += dossier.trade_names[i] + '/n';
                }

            }

            if (dbds.size() < 1) { // no dossiers found
                d = new Dutch_Business_Dossier__c();
                //d.Account__c = accountId; done inside uow
            }
            else { //Dossier found
                d = dbds[0];
                dossierExists = true;
                /*if (d.Account__c !=  accountId) { // TODO: handle this somehow
                    throw new AuraHandledException('Dossier is already allocated to another Account');
                }*/
            }
            // @todo add addresses and contact.
            system.debug('VPROK tests dosier = '+ dossier);
            // if we will need legal name on name field
            if(dossier.legal_name != null && dossier.legal_name != ''){
                d.Name = dossier.legal_name;//dossier.legal_name;
            }else{
                d.Name = dossier.trade_name_full;//dossier.legal_name;
            }
            //d.Name = dossier.trade_name_full;
            d.Dossier_Number__c = dossier.dossier_number;
            d.Establishment_Number__c = convertToInteger(dossier.establishment_number);
            d.Main_Establishment_Number__c = convertToInteger(dossier.main_establishment_number);
            d.Indication_Main_Establishment__c = dossier.indication_main_establishment; //convertToBoolean(dossier.indication_main_establishment);
            d.Rsin_Number__c = convertToInteger(dossier.rsin_number);
            d.Chamber_Number__c = dossier.chamber_number;
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
            d.Continuation_Date__c = dossier.continuation_date;
            d.Discontinuation_Date__c = dossier.discontinuation_date;
            d.Establishment_Date__c = dossier.establishment_date;
            d.Founding_Date__c = dossier.founding_date;
            d.Issued_Share_Capital__c = convertToInteger(dossier.issued_share_capital);
            d.Issued_Share_Capital_Currency__c = dossier.issued_share_capital_currency;
            d.Paid_Up_Share_Capital__c = convertToInteger(dossier.paid_up_share_capital);
            d.Paid_Up_Share_Capital_Currency__c = dossier.paid_up_share_capital_currency;
            d.Personnel__c = dossier.personnel;
            d.Personnel_Fulltime__c = dossier.personnel_fulltime;
            d.Personnel_Reference_Date__c = dossier.personnel_reference_date;
            d.Primary_Sbi_Code__c = dossier.primary_sbi_code;
            d.Primary_Sbi_Code_Text__c = dossier.primary_sbi_code_text;
            d.Secondary_Sbi_Code_1__c = dossier.secondary_sbi_code1;
            d.Secondary_Sbi_Code_1_Text__c = dossier.secondary_sbi_code1_text;
            d.Secondary_Sbi_Code_2__c = dossier.secondary_sbi_code2;
            d.Secondary_Sbi_Code_2_Text__c = dossier.secondary_sbi_code2_text;

            d.Chamber_Code__c = dossier.chamber_number;//convertToString(dossier.chamber_number);
            d.Status__c = determineStatus(dossier);

            d.Annual_Financial_Statement_Summary__c = dossier.annual_financial_statement_summary;
            d.Personnel_CI__c = dossier.personnel_ci;
            d.Class_Personnel_CI__c = convertToString(dossier.class_personnel_ci);
            d.Personnel_CI_Reference_Date__c = dossier.personnel_ci_reference_date;
            d.Contact_Initials__c = dossier.contact_initials;
            d.Contact_Prefix__c = dossier.contact_prefix;
            d.Contact_Surname__c = dossier.contact_surname;
            d.Contact_Title1__c = dossier.contact_title1;
            d.Contact_Title2__c = dossier.contact_title2;
            d.Contact_Gender__c = dossier.contact_gender;
            d.Correspondence_Address__c = dossier.correspondence_address_official_address; //I think this should be combination of all correspondence_address_xxx
            d.Establishment_Address__c = dossier.establishment_address_official_address; //combination of all establishment_address_xxx
            if (dossier.indication_bankruptcy != null) { d.Indication_Bankruptcy__c = dossier.indication_bankruptcy;}
            if (dossier.indication_dip != null) { d.Indication_Dip__c = dossier.indication_dip;}
            if (dossier.indication_economically_active != null) { d.Indication_Economically_Active__c = dossier.indication_economically_active;}
            if (dossier.indication_export != null) { d.Indication_Export__c = dossier.indication_export;}
            if (dossier.indication_import != null) { d.Indication_Import__c = dossier.indication_import;}
            if (dossier.indication_main_establishment != null) { d.Indication_Main_Establishment__c = dossier.indication_main_establishment;}
            if (dossier.indication_non_mailing != null) { d.Indication_Non_Mailing__c = dossier.indication_non_mailing;}
            d.Insolvencies__c = dossier.insolvencies;
            d.Sbi_Collection__c = dossier.sbi_collection;
            d.Structure__c = dossier.structure;

            //upsert d;
            if(dossierExists){
                unitOfWork.registerDirty(d, Dutch_Business_Dossier__c.Account__c, acc);
            }else{
                unitOfWork.registerNew(d, Dutch_Business_Dossier__c.Account__c, acc);
            }

            return d;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
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
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    public static DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber) {
        if (dossierNumber == null){ return null;}
        try{
            IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
            DutchBusinessDto.DutchBusinessGetDossierRequest requestParams = new DutchBusinessDto.DutchBusinessGetDossierRequest();// = new DutchBusinessDto.DutchBusinessGetDossierRequest(dossier_number = dossierNumber, establishment_number = null);
            requestParams.dossier_number = dossierNumber;
            requestParams.establishment_number = null;
            return service.dutchBusinessGetDossier(requestParams);
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }


    }
    // TODO: rewrite properly, the method should notify if there were problems during update TODO: MOVE STUFF TO SELECTOR AND UOW
    // was void before. not tyoo logical to return dossier Id from this method. Cut the corner to both get dossierId for  controller and Not research how to handle void methods  with this framework
    public static String updateAccountDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier) {
        try{
            list<Dutch_Business_Dossier__c> dossierList = DutchBusinessDossierSelector.newInstance().selectByDossierNumber(new set<String>{dossier.dossier_number});//[SELECT Id, Account__c FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossier.dossier_number)];
            List<Account> accts = AccountSelector.newInstance().selectById(new set<Id>{dossierList.get(0).Account__c});//[SELECT Id, Dutch_Business_Dossier__c FROM Account WHERE Id = :dossierList.get(0).Account__c];
            if (accts.size() == 1) {
                accts[0].Dutch_Business_Dossier__c = dossierList.get(0).Id;
                update accts;
            }
            return dossierList.get(0).Id;
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
        //return null;
    }
    // TODO: rewrite properly, the method should notify if there were problems during update
    /*public static boolean updateAccountDossier(Id accountId, Id dossierId) {
        try{
            List<Account> accts = [SELECT Id, Dutch_Business_Dossier__c FROM Account WHERE Id = :accountId];
            if (accts.size() == 1 && dossierId != NULL) {
                accts[0].Dutch_Business_Dossier__c = dossierId;
                update accts;
            }
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
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

        Schema.sObjectType.Dutch_Business_Dossier__c.fields.getMap();

        Schema.DescribeSObjectResult a_desc = Dutch_Business_Dossier__c.sObjectType.getDescribe();
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
             if (Schema.sObjectType.Dutch_Business_Dossier__c.fields.Id.isAccessible() == false ||
                 Schema.sObjectType.Dutch_Business_Dossier__c.fields.Account__c.isAccessible() == false ||
                 checkAccess() == false) throw new NoAccessException();

             List<Dutch_Business_Dossier__c> dbds = [SELECT Id, Account__c FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossier.dossier_number)];
             Dutch_Business_Dossier__c d;

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
                 d = new Dutch_Business_Dossier__c();
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
         }catch(BdsException ex){
             throw ex; // we dont log bds exceptions, only throwing them further
         }catch(System.Exception ex){
             ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
             throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage(), ex);
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
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

}