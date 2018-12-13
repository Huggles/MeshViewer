/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/
public class CompanyDetailsController {
    private static list<wwwWebservicesNlSoap.DutchBusinessReferenceV2> searchResults;
    @AuraEnabled
    public static wwwWebservicesNlSoap.DutchBusinessReferenceV2[] search(String searchText){
        if(searchText!=null){
            return searchResults=CompanyDetailsControllerHelper.search(searchText);
        }
        else{
            return searchResults;
        }

        //TBD
    }
}