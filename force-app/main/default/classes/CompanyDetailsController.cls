/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/ 

public with sharing class CompanyDetailsController {
    @AuraEnabled
    public static Object search(String searchParams){
        system.debug('searchParams = '+searchParams);
        if(searchParams!=null){
            try{
                DutchBusinessDto.dutchBusinessSearchParametersRequest params = (DutchBusinessDto.dutchBusinessSearchParametersRequest)JSON.deserialize(searchParams, DutchBusinessDto.dutchBusinessSearchParametersRequest.class);
                
                Object result = (Object)DutchBusinessService.searchForDossiers(params);
                AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
                return output;
            }catch(Exception e){
                return ErrorLogUtil.logAndCommitUI(e, System.Label.BDS_WSCall_Generic_UI_Exception);
            }
        }
        return null; 
    }
    @AuraEnabled
    public static Object createDossier(String dossierNumber, Id accountId){
        System.debug('getInfo');
        if(dossierNumber!=null){
            try{
                DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessService.getDossier(dossierNumber);
                AuraResponseWrapper output = new AuraResponseWrapper(createUpdateAccount(dossier, accountId));
                return output;
            }catch(Exception e){
                return ErrorLogUtil.logAndCommitUI(e, System.Label.BDS_WSCall_Generic_UI_Exception);
            }
        }
        return null;
    } 
    @AuraEnabled
    public static Object createDossier(String dossierNumber){
        System.debug('getInfoNoSaving');
        try{
            DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessService.getDossier(dossierNumber);
            Account acc = DutchBusinessService.getDossierAccount(dossier.dossier_number); // checking if there already is an account for this dossier number
            String AccountId = '';
            if(acc != null){
                AccountId = acc.Id;
            }
            list<Object> result = new list<Object>();
            result = createUpdateAccount(dossier, accountId);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch(Exception e){
            return ErrorLogUtil.logAndCommitUI(e, System.Label.BDS_WSCall_Generic_UI_Exception);
        }
    }
    public static list<Object> createUpdateAccount(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){    
            list<Object> result = new list<object>();
            result = DutchBusinessService.upsertAccountAndDossier(dossier, accountId);    
            DutchBusinessService.updateAccountDossier(dossier); // will be gone later once fflib is updated
            //AuraResponseWrapper output = new AuraResponseWrapper(result);
            return result;
    }

}