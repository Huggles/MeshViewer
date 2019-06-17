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
    public static Object createDossier(String dossierNumber, String establishmentNumber, Id accountId){
        System.debug('getInfo' + accountId);
        if(dossierNumber!=null){
            try{
                DutchBusinessDto.DutchBusinessGetDossierResponse dossier = BusinessService.getDossier(dossierNumber, establishmentNumber);
                AuraResponseWrapper output = new AuraResponseWrapper(createUpdateAccount(dossier, accountId));
                return output;
            }catch(Exception e){
                return ErrorLogUtil.logAndCommitUI(e, System.Label.WSCall_Generic_UI_Exception);
            }
        }
        return null;
    }
    @AuraEnabled
    public static Object createDossier(String dossierNumber, String establishmentNumber){
        try{
            DutchBusinessDto.DutchBusinessGetDossierResponse dossier = BusinessService.getDossier(dossierNumber, establishmentNumber);
            Account acc;// = BusinessService.getDossierAccount(dossier.dossier_number); // checking if there already is an account for this dossier number
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

    @AuraEnabled
    public static Object checkDossier(String dossierNumber, String establishmentNumber, Id accountId){
        try{
            Business_Dossier__c result = BusinessService.checkDossier(dossierNumber,establishmentNumber);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch(Exception e){
            return ErrorLogUtil.logAndCommitUI(e, System.Label.WSCall_Generic_UI_Exception);
        }
    }

    @AuraEnabled
    public static Object getVATDetails(String dossierId){
        try{
            // 1. Get existing dossier from ID
            Business_Dossier__c result = BusinessService.selectDossier(dossierId);        
            // 2. WebService call to get VAT
            DutchBusinessDto.DutchBusinessVatNumber vatResponse = BusinessService.requestVAT(result.Dossier_Number__c);
            // 3. Add VAT number to dossier
            result.VAT_Number__c = vatResponse.vat_number;
            // 4. Save
            BusinessService.upsertDossier(result);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch(Exception e){
            System.debug(e.getMessage());
            return ErrorLogUtil.logAndCommitUI(e, e.getMessage());
        }
    }

}