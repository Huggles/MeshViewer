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
        public List<BusinessDossierWrapper> businessDossierWrappers;
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
    public class BusinessDossierWrapper{
        @AuraEnabled
        public Business_Dossier__c businessDossier;
        @AuraEnabled
        public Boolean existingDossier;
        @AuraEnabled
        public Id existingDossierId;

    }

    public static SearchedBusinessDossierResults convertToCorrectReturnType(DutchBusinessServiceImpl.SearchedBusinessDossierResults s){
        SearchedBusinessDossierResults searchedBusinessDossierResults = new SearchedBusinessDossierResults();
        searchedBusinessDossierResults.curpage = s.curpage;
        searchedBusinessDossierResults.perpage = s.perpage;
        searchedBusinessDossierResults.numpages = s.numpages;
        searchedBusinessDossierResults.numresults = s.numresults;
        searchedBusinessDossierResults.maxresults = s.maxresults;
        //check duplicate on dossier no. and establish no. before inserting
        searchedBusinessDossierResults.businessDossierWrappers = checkDuplicateDossiers(s.businessDossiers);
        return searchedBusinessDossierResults;
    }


    public static List<BusinessDossierWrapper> checkDuplicateDossiers(List<Business_Dossier__c> businessDossiers){
        try {
            List<String> dossierNumbers = new List<String>();
            List<String> establishmentNumbers = new List<String>();

            for (Business_Dossier__c businessDossier : businessDossiers) {
                dossierNumbers.add(businessDossier.Dossier_Number__c);
                establishmentNumbers.add(businessDossier.Establishment_Number__c);
            }
            List<BusinessDossierWrapper> businessDossierWrappers = new List<SearchBusinessDossiersController.BusinessDossierWrapper>();

            //Find duplicate based on dossier number and establish number
            List<Business_Dossier__c> duplicateBusinessDossiers = BusinessService.findDuplicateDossiersByDossierAndEstablishmentNumber(dossierNumbers, establishmentNumbers);

            //check subscriber duplicate rule
            List<Business_Dossier__c> checkDuplicateDossiers = checkSubscriberDuplicateRule(businessDossiers);
            //Query the Business Dossiers to get dossier number and establishment number.
            checkDuplicateDossiers = [SELECT Id,Dossier_Number__c, Establishment_Number__c FROM Business_Dossier__c WHERE Id in :new Map<String, SObject>(checkDuplicateDossiers).keySet()];

            //Merge the two lists and make a map
            if(checkDuplicateDossiers != null && checkDuplicateDossiers.size() > 0){
                duplicateBusinessDossiers.addAll(checkDuplicateDossiers);
            }

            //filter duplicate
            Map<String, Business_Dossier__c> duplicateDossierMap = new Map<String, Business_Dossier__c>();
            for (Business_Dossier__c businessDossier : duplicateBusinessDossiers) {
                if(!duplicateDossierMap.containsKey(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c)){
                    duplicateDossierMap.put(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c, businessDossier);
                }
            }

            //Create wrapper
            for (Business_Dossier__c businessDossier : businessDossiers) {
                BusinessDossierWrapper businessDossierWrapper = new BusinessDossierWrapper();
                businessDossierWrapper.businessDossier = businessDossier;

                Business_Dossier__c duplicateDossier = duplicateDossierMap.get(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c);
                businessDossierWrapper.existingDossier = false;
                if(duplicateDossier != null){
                    businessDossierWrapper.existingDossier = true;
                    businessDossierWrapper.existingDossierId = duplicateDossier.Id;
                }
                businessDossierWrappers.add(businessDossierWrapper);
            }
            return businessDossierWrappers;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }

    public static List<SObject> checkSubscriberDuplicateRule(List<SObject> sObjects){
        try {
            List<SObject> duplicateSObjects = DuplicateManagementService.findDuplicates(sObjects);
            return duplicateSObjects;
        }
        catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }
}