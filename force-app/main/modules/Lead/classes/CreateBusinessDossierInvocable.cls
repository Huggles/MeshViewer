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
            businessDossiersToUpsert = checkDuplicate(businessDossiers);
            List<Business_Dossier__c> insertedBusinessDossiers = BusinessService.createDossiers(businessDossiersToUpsert, true);
                return insertedBusinessDossiers;
        }
        catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }

    public static List<Business_Dossier__c> checkDuplicate(List<Business_Dossier__c> dossiers){
        List<String> dossierNumbers = new List<String>();
        List<String> establishmentNumbers = new List<String>();
        for(Business_Dossier__c businessDossier : dossiers){
                dossierNumbers.add(businessDossier.Dossier_Number__c);
                establishmentNumbers.add(businessDossier.Establishment_Number__c);
        }
        List<Business_Dossier__c> duplicateBusinessDossiers = BusinessService.findDuplicateDossiersByDossierAndEstablishmentNumber(dossierNumbers, establishmentNumbers);

        Map<String,Business_Dossier__c> duplicateDossierMap = new Map<String, Business_Dossier__c>();
        for(Business_Dossier__c businessDossier : duplicateBusinessDossiers){
            duplicateDossierMap.put(businessDossier.Dossier_Number__c+businessDossier.Establishment_Number__c,businessDossier);
        }
        List<Business_Dossier__c> businessDossiersToReturn = new List<Business_Dossier__c>();
        for(Business_Dossier__c dossier : dossiers){
            if(!duplicateDossierMap.containsKey(dossier.Dossier_Number__c+dossier.Establishment_Number__c)){
                businessDossiersToReturn.add(dossier);
            }
        }
        return businessDossiersToReturn;
    }
}