/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/
public with sharing class CompanyDetailsController {
    private static list<WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2> searchResults;
    @AuraEnabled
    public static WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2[] search(String searchParams){
        System.debug('search');
        if(searchParams!=null){
            DutchBusinessService.CompanySearchDto params = (DutchBusinessService.CompanySearchDto)JSON.deserialize(searchParams, DutchBusinessService.CompanySearchDto.class);
            return DutchBusinessService.searchForDossiers(params);
        }
        return null; 
    }
    @AuraEnabled
    public static String getInfo(String dossierNumber, Id accountId){
        System.debug('getInfo');
        if(dossierNumber!=null){

            DutchBusinessDto dto = DutchBusinessService.getInfo(dossierNumber);
            WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessDossierV3 dossier = dto.DutchBusinessDossierV3;
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