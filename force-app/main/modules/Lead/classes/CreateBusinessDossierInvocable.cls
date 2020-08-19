/**
 * Created by vishalshete on 14/08/2020.
 */

global with sharing class CreateBusinessDossierInvocable {
    global inherited sharing class CreateBusinessDossierArgument {
        @InvocableVariable(
                label='Dossier'
                description='The Dutch dossier to be inserted. This will be inserted.'
                required=true)
        global List<SObject> businessDossiers;

        global CreateBusinessDossierArgument() {
        }
    }
    @InvocableMethod(
            label='Create Business Dossiers'
            description='Create Business Dossiers'
            category='Company.info')
    global static List<Business_Dossier__c> createBusinessDossier(List<CreateBusinessDossierArgument> arguments) {
        try {
            List<Business_Dossier__c> businessDossiersToUpsert = new List<Business_Dossier__c>();
            List<Business_Dossier__c> businessDossiers= new List<Business_Dossier__c>();
            for (CreateBusinessDossierArgument argument : arguments) {
                //This invocable can only be called with both arguments filled of type business dossier.
                if (argument.businessDossiers == null) {
                    throw new AuraHandledException(Label.Error_Input_Incorrect);
                } else{
                    businessDossiers = argument.businessDossiers;
                }
            }
            //check duplicate duplicate rule created by subscriber org before inserting
            businessDossiersToUpsert = checkDuplicateRule(businessDossiers);
            List<Business_Dossier__c> insertedBusinessDossiers = BusinessService.createDossiers(businessDossiersToUpsert, true);
                return insertedBusinessDossiers;
        }
        catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }
    public static List<Business_Dossier__c> checkDuplicateRule(List<SObject> sObjects){
        try {
            List<SObject> duplicateSObjects = DuplicateManagementService.findDuplicates(sObjects);
            if(duplicateSObjects!= null) {
                Map<String, SObject> duplicateMap = new Map<String, SObject>(duplicateSObjects);
                List<Business_Dossier__c> duplicateDossiers = [SELECT Id,Dossier_Number__c, Establishment_Number__c FROM Business_Dossier__c WHERE Id in :duplicateMap.keySet()];

                //below code query dossiers again because duplicate rule doesn't provide required fields
                List<Business_Dossier__c> businessDossiers = new List<Business_Dossier__c>();
                Map<String, Business_Dossier__c> duplicateDossierMap = new Map<String, Business_Dossier__c>();

                for (Business_Dossier__c businessDossier : duplicateDossiers) {
                    duplicateDossierMap.put(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c, businessDossier);
                }

                for (sObject obj : sObjects) {
                    Business_Dossier__c businessDossier = (Business_Dossier__c) obj;
                    if (!duplicateDossierMap.containsKey(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c)) {
                        businessDossiers.add(businessDossier);
                    }
                }
                return businessDossiers;
            } return null;
        }
        catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }
}