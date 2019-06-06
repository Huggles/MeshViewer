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

                Object result = (Object) BusinessService.searchForDossiers(params);
                AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
                return output;
            }catch(Exception e){
                return ErrorLogUtil.logAndCommitUI(e, System.Label.WSCall_Generic_UI_Exception);
            }
        }
        return null;
    }
    @AuraEnabled
    public static Object createDossier(String dossierNumber, Id accountId){
        System.debug('getInfo');
        if(dossierNumber!=null){
            try{
                DutchBusinessDto.DutchBusinessGetDossierResponse dossier = BusinessService.getDossier(dossierNumber);
                AuraResponseWrapper output = new AuraResponseWrapper(createUpdateAccount(dossier, accountId));
                return output;
            }catch(Exception e){
                return ErrorLogUtil.logAndCommitUI(e, System.Label.WSCall_Generic_UI_Exception);
            }
        }
        return null;
    }
    @AuraEnabled
    public static Object createDossier(String dossierNumber){
        try{
            DutchBusinessDto.DutchBusinessGetDossierResponse dossier = BusinessService.getDossier(dossierNumber);
            Account acc = BusinessService.getDossierAccount(dossier.dossier_number); // checking if there already is an account for this dossier number
            String AccountId = '';
            if(acc != null){
                AccountId = acc.Id;
            }
            list<Object> result = new list<Object>();
            result = createUpdateAccount(dossier, accountId);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch(Exception e){
            return ErrorLogUtil.logAndCommitUI(e, System.Label.WSCall_Generic_UI_Exception);
        }
    }
    public static list<Object> createUpdateAccount(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){
        list<Object> result = new list<object>();
        result = BusinessService.upsertAccountAndDossier(dossier, accountId);
        BusinessService.updateAccountDossier(dossier); // will be gone later once fflib is updated
        //AuraResponseWrapper output = new AuraResponseWrapper(result);
        return result;
    }

    @AuraEnabled
    public static Object deleteDossier(Id recordId){
        try{
            Boolean result = BusinessService.deleteDossier(recordId);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch(Exception e){
            return ErrorLogUtil.logAndCommitUI(e, System.Label.WSCall_Generic_UI_Exception);
        }
    }

}