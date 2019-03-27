/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/
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
    public static Id getDossierRecordId(Integer dossierNumber){
        if (Schema.sObjectType.Dutch_Business_Dossier__c.fields.Id.isAccessible() == false) throw new NoAccessException();
        
        List<Dutch_Business_Dossier__c> results = [SELECT Id FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :dossierNumber];
        if (results.size() > 0) {
            return results[0].Id;
        }
        return null;
    }
}