/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/
public class CompanyDetailsController {
    private static list<wwwWebservicesNlSoap.DutchBusinessReferenceV2> searchResults;
    @AuraEnabled
    public static wwwWebservicesNlSoap.DutchBusinessReferenceV2[] search(String searchParams){
        System.debug('search');
        if(searchParams!=null){
            CompanyDetailsControllerHelper.CompanySearchDto params = (CompanyDetailsControllerHelper.CompanySearchDto)JSON.deserialize(searchParams, CompanyDetailsControllerHelper.CompanySearchDto.class);
            return CompanyDetailsControllerHelper.search(params);
        }
        return null;
    }
    @AuraEnabled
    public static String getInfo(String dossierNumber, Id accountId){
        System.debug('getInfo');
        if(dossierNumber!=null){
            wwwWebservicesNlSoap.DutchBusinessDossierV3 dossier = CompanyDetailsControllerHelper.getInfo(dossierNumber);
            System.debug('getInfoResponse');
            System.debug(dossier);
            Id savedRecord = CompanyDetailsControllerHelper.saveDutchBusinessDossier(dossier, accountId); 
            CompanyDetailsControllerHelper.updateAccountDossier(accountId, Integer.valueOf(dossier.dossier_number));
            return savedRecord;
        }
        return null;
    } 
    @AuraEnabled
    public static Id getDossierRecordId(Integer dossierNumber){
        // @todo security
        List<Dutch_Business_Dossier__c> results = [SELECT Id FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :dossierNumber];
        if (results.size() > 0) {
            return results[0].Id;
        }
        return null;
    }
}