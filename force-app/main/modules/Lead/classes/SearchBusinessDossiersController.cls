/**
 * Created by vishalshete on 11/08/2020.
 */

public with sharing class SearchBusinessDossiersController {

    @AuraEnabled
    public static SearchedBusinessDossierResults searchDutchBusinessDossiers(List<String> cities,
            List<String> postcodes,
            List<String> sbiList,
            Boolean primary_sbi_only,
            List<Integer> legal_forms,
            Integer employees_min,
            Integer employees_max,
            String economically_active,
            String financial_status,
            String changed_since,
            String new_since,
            Integer page_x,
            List<String> provinces,
            String sbi_match_type){

        try {
            DutchBusinessServiceImpl.SearchedBusinessDossierResults searchedResults
                    = DutchBusinessService.dutchBusinessSearchSelectionResults(cities, postcodes, sbiList, primary_sbi_only, legal_forms, employees_min
                            , employees_max, economically_active, financial_status, changed_since, new_since, page_x, provinces, sbi_match_type);

            SearchedBusinessDossierResults SearchedBusinessDossierToReturn = convertToCorrectReturnType(searchedResults);
            return SearchedBusinessDossierToReturn;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }

    }
    public class SearchedBusinessDossierResults{
        @AuraEnabled
        public List<Business_Dossier__c> businessDossiers;
        @AuraEnabled
        public Integer curpage ;
        @AuraEnabled
        public Integer perpage;
        @AuraEnabled
        public Integer numpages;
        @AuraEnabled
        public Integer numresults;
        @AuraEnabled
        public Integer maxresults;
    }

    public static SearchedBusinessDossierResults convertToCorrectReturnType(DutchBusinessServiceImpl.SearchedBusinessDossierResults s){
        SearchedBusinessDossierResults searchedBusinessDossierResults = new SearchedBusinessDossierResults();
        searchedBusinessDossierResults.businessDossiers = s.businessDossiers;
        searchedBusinessDossierResults.curpage = s.curpage;
        searchedBusinessDossierResults.perpage = s.perpage;
        searchedBusinessDossierResults.numpages = s.numpages;
        searchedBusinessDossierResults.numresults = s.numresults;
        searchedBusinessDossierResults.maxresults = s.maxresults;
        return searchedBusinessDossierResults;
    }

}