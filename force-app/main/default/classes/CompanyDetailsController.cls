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
    public static String getInfo(String dossierNumber){
        System.debug('getInfo');
        if(dossierNumber!=null){
            wwwWebservicesNlSoap.DutchBusinessDossierV3 response = CompanyDetailsControllerHelper.getInfo(dossierNumber);
            System.debug('getInfoResponse');
            System.debug(response);
            return JSON.serialize(response);
        }
        return null;
    } 
}