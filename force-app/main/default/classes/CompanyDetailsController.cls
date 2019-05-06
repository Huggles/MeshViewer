/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/ 

// TODO handle empty search

public with sharing class CompanyDetailsController {
    //private static list<WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2> searchResults;
    @AuraEnabled
    public static List<DutchBusinessDto.DutchBusinessReference> search(String searchParams){
        if(searchParams!=null){
            DutchBusinessDto.dutchBusinessSearchParametersRequest params = (DutchBusinessDto.dutchBusinessSearchParametersRequest)JSON.deserialize(searchParams, DutchBusinessDto.dutchBusinessSearchParametersRequest.class);
            return DutchBusinessService.searchForDossiers(params);
        }
        return null; 
    }
    @AuraEnabled
    public static String getInfo(String dossierNumber, Id accountId){
        System.debug('getInfo');
        if(dossierNumber!=null){

            DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessService.getDossier(dossierNumber);
            System.debug('getInfoResponse');
            System.debug(dossier);
            Id savedRecord = DutchBusinessService.saveDutchBusinessDossier(dossier, accountId); 
            DutchBusinessService.updateAccountDossier(accountId, savedRecord);
            return savedRecord;
        }
        return null;
    } 
    @AuraEnabled
    public static Object getInfoNoSaving(String dossierNumber){
        System.debug('getInfoNoSaving');
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessService.getDossier(dossierNumber);
        Account acc = DutchBusinessService.getDossierAccount(dossier.dossier_number);
        String AccountId = '';
        if(acc != null){
            AccountId = acc.Id;
        }
        System.debug('getInfoNoSavingResponse');
        System.debug(dossier);
        list<Object> result = new list<Object>();
        result.add(dossier);
        result.add(AccountId);
        result.add(acc);
        //result.add();
        return result;

    }


    @AuraEnabled
    public static Object createUpdateAccount(String dossierObj, String accountId){
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier  = castToDossierDto(dossierObj);
        //DutchBusinessDto.DutchBusinessGetDossierResponse dossierDto = (DutchBusinessDto.DutchBusinessGetDossierResponse)dossier;
        system.debug('dossierDto = '+dossier);

        system.debug('accountId = ' + accountId);
        try{
            Id savedRecord = DutchBusinessService.saveDutchBusinessDossier(dossier, accountId); 
            DutchBusinessService.updateAccountDossier(accountId, savedRecord);       
        }catch(Exception e){
            // todo logging and notificztion
        }


        return null;
    }
    private static DutchBusinessDto.DutchBusinessGetDossierResponse castToDossierDto(String str){
        DutchBusinessDto.DutchBusinessGetDossierResponse response = (DutchBusinessDto.DutchBusinessGetDossierResponse)JSON.deserialize(str, DutchBusinessDto.DutchBusinessGetDossierResponse.class); //= new DutchBusinessDto.DutchBusinessGetDossierResponse();
        return response;
    }

    @AuraEnabled
    public static Id getDossierRecordId(Integer dossierNumber){
        if (Schema.sObjectType.Dutch_Business_Dossier__c.fields.Id.isAccessible() == false) throw new NoAccessException();
        
        List<Dutch_Business_Dossier__c> results = [SELECT Id FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :dossierNumber];
        if (results.size() > 0) {
            return results[0].Id;
        }
        return null;
    }
}