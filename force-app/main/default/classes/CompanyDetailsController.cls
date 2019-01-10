/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/
public with sharing class CompanyDetailsController {
    private static list<wwwWebservicesNlSoap.DutchBusinessReferenceV2> searchResults;
    @AuraEnabled
    public static wwwWebservicesNlSoap.DutchBusinessReferenceV2[] search(String searchParams){
        System.debug('search');
        if(searchParams!=null){
            CompanyInfoService.CompanySearchDto params = (CompanyInfoService.CompanySearchDto)JSON.deserialize(searchParams, CompanyInfoService.CompanySearchDto.class);
            return CompanyInfoService.search(params);
        }
        return null; 
    }
    @AuraEnabled
    public static String getInfo(String dossierNumber, Id accountId){
        System.debug('getInfo');
        if(dossierNumber!=null){
            wwwWebservicesNlSoap.DutchBusinessDossierV3 dossier = CompanyInfoService.getInfo(dossierNumber);
            System.debug('getInfoResponse');
            System.debug(dossier);
            Id savedRecord = CompanyInfoService.saveDutchBusinessDossier(dossier, accountId); 
            CompanyInfoService.updateAccountDossier(accountId, savedRecord);
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