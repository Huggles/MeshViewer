/**
 * Created by Hugo on 14/08/2020.
 */


public with sharing class FindBusinessCriteriaModel {
    @AuraEnabled public List<String> cities {get; set;}
    @AuraEnabled public List<String> postcodes {get; set;}
    @AuraEnabled public List<String> sbiList {get; set;}
    @AuraEnabled public List<Integer> legal_forms {get; set;}
    @AuraEnabled public List<String> provinces {get; set;}

    @AuraEnabled public Integer employees_min {get; set;}
    @AuraEnabled public Integer employees_max {get; set;}

    @AuraEnabled public String primary_sbi_only {get; set;}
    @AuraEnabled public String economically_active {get; set;}
    @AuraEnabled public String financial_status {get; set;}
    @AuraEnabled public String changed_since {get; set;}
    @AuraEnabled public String new_since {get; set;}
    @AuraEnabled public String sbi_match_type {get; set;}

    @AuraEnabled public Integer max_number_of_results {get; set;}

    public FindBusinessCriteriaModel(){}


}