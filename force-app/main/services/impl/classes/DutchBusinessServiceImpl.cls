/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/
public with sharing class DutchBusinessServiceImpl implements IDutchBusinessService {
    
   //private static WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2PagedResult returnedResults;
   //private static list<WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2> searchResults; 
    //public static final Integer paramInt=null;
    //public static final Boolean Strict_Search = False;

    public static Account getDossierAccount(String dossierNum){
        try{    // todo move everything to selector
        //TODO: enhance with duplicate logic. mb account is there but has no dossier
            list<Dutch_Business_Dossier__c> dossList = new list<Dutch_Business_Dossier__c>();
            dossList =  [SELECT ID, Name, Account__r.name,  Account__r.Id FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossierNum)];//TO DO: move to selector
            Account acc;
            if(dossList.size() >0){
                acc = [SELECT Id, Name From Account WHERE Id = :dossList.get(0).Account__r.Id];
            }
            if(dossList.size()>1){
                //todo: log a warning  that one dossier per system allowed?
            }
            return acc;
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }
    }

    private static Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork){
        try{
            list<String> existinAccountIds = new list<String>();
            Account acc = new Account();
            acc.Name = dossier.trade_name_full;
            if(accountId == null || AccountId == ''){ // create an account
                existinAccountIds = checkForAccountDuplicates(acc);
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
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }
    }

    // checks for account duplicates. Return a list of IDs if duplicates exist.
    private static list<String> checkForAccountDuplicates(Account acc){
        list<String> result = new list<String>();
        list<Account> accounts = new list<Account>();
        accounts.add(acc);
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

        return result;
    }

    //DutchBusinessDto.DutchBusinessGetDossierResponse dossier
    public static boolean createUpdateAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){
        try{
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
            list<String> existinAccountIds;
            Account acc = createAccountForDossier(accountId, dossier, unitOfWork);
            Dutch_Business_Dossier__c d = saveDutchBusinessDossierUow(dossier, acc, unitOfWork);
            //unitOfWork.registerRelationship(acc, Account.Dutch_Business_Dossier__c, d);
            unitOfWork.commitWork();
            //unitOfWork.registerDirty(acc, Account.Dutch_Business_Dossier__c, d); // to update a field on account level once dossier is inserted
            //unitOfWork.commitWork(); // need to wait until circullar references are releassed ion fflib. so far using another method link: https://github.com/financialforcedev/fflib-apex-common/pull/195
            return true;
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }
    }
    
    public static Dutch_Business_Dossier__c saveDutchBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork) {
            boolean dossierExists = false;
            // TODO: move to selector
            List<Dutch_Business_Dossier__c> dbds = [SELECT Id, Account__c FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossier.dossier_number)];
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

            //upsert d;
            if(dossierExists){
                unitOfWork.registerDirty(d, Dutch_Business_Dossier__c.Account__c, acc);
            }else{
                unitOfWork.registerNew(d, Dutch_Business_Dossier__c.Account__c, acc);
            }
            
            return d;
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
                system.debug('returnedResults = ' + returnedResults);
                system.debug('returnedResults.items = ' + returnedResults.items.size());

            }
            else{
                System.debug('no items');
                // searchResults=returnedResults;
            }
            //return parsed result
            return searchResults;
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
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
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }


    }
    // TODO: rewrite properly, the method should notify if there were problems during update TODO: MOVE STUFF TO SELECTOR AND UOW
    // was void before. not tyoo logical to return dossier Id from this method. Cut the corner to both get dossierId for  controller and Not research how to handle void methods  with this framework
    public static String updateAccountDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier) {
        try{
            list<Dutch_Business_Dossier__c> dossierList = [SELECT Id, Account__c FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossier.dossier_number)];
            List<Account> accts = [SELECT Id, Dutch_Business_Dossier__c FROM Account WHERE Id = :dossierList.get(0).Account__c];
            if (accts.size() == 1) {
                accts[0].Dutch_Business_Dossier__c = dossierList.get(0).Id;
                update accts;
            }
            return dossierList.get(0).Id;
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
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
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }
    }*/
    
    
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
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }
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
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }
    }
    
}
