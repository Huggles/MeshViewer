/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/
public with sharing class DutchBusinessServiceImpl implements IDutchBusinessService {

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
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_DBSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }
    }

    public static Account getDossierAccount(String dossierNum){
        try{
        //TODO: enhance with duplicate logic. mb account is there but has no dossier
            list<Dutch_Business_Dossier__c> dossList = new list<Dutch_Business_Dossier__c>();

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
        }catch(System.Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_DBSCall_AccountSearch_Exception);
            return null; // never happens hence logging throws exceptions
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

        }catch(System.Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_DBSCall_AccountSave_Exception);
            return null; // never happens hence logging throws exceptions
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
            //expected, no dup rules for account are active
        }catch(System.Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_DBSCall_AccountDupCheck_Exception);
            return null; // never happens hence logging throws exceptions
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

            //upsert d;
            if(dossierExists){
                unitOfWork.registerDirty(d, Dutch_Business_Dossier__c.Account__c, acc);
            }else{
                unitOfWork.registerNew(d, Dutch_Business_Dossier__c.Account__c, acc);
            }
            return d;
        }
        catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_DBSCall_DossierSave_Exception);
            return null; // never happens hence logging throws exceptions
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
        try{
            if (dossierNumber == null){ return null;}                                                          
            IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
            DutchBusinessDto.DutchBusinessGetDossierRequest requestParams = new DutchBusinessDto.DutchBusinessGetDossierRequest();// = new DutchBusinessDto.DutchBusinessGetDossierRequest(dossier_number = dossierNumber, establishment_number = null);
            requestParams.dossier_number = dossierNumber;
            requestParams.establishment_number = null;
            return service.dutchBusinessGetDossier(requestParams);
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_DBSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
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
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_DBSCall_DossierSave_Exception);
            return null; // never happens hence logging throws exceptions
        }
    }

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
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_DBSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }  
    }
    
}
