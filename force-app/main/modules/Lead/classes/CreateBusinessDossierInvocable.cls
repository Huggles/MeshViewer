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
            for (CreateBusinessDossierArgument argument : arguments) {
                //This invocable can only be called with both arguments filled of type business dossier.
                if (argument.businessDossiers == null) {
                    throw new AuraHandledException(Label.Error_Input_Incorrect);
                } else{
                    businessDossiersToUpsert = argument.businessDossiers;
                }
            }
            //check duplicate duplicate rule created by subscriber org before inserting
            List<Business_Dossier__c> insertedBusinessDossiers = BusinessService.createDossiers(businessDossiersToUpsert, true);
                return insertedBusinessDossiers;
        }
        catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }

}