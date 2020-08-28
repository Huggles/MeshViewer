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

        @InvocableVariable(
                label='Search Criteria'
                description='The Search Criteria used to find the dossiers.'
                required=true)
        global FindBusinessCriteriaModel searchCriteria;

        global CreateBusinessDossierArgument() {
        }
    }
    @InvocableMethod(
            label='Upsert Found Business Dossiers'
            description='Upsert Business Dossiers found with Find Businesses'
            category='Company.info')
    global static List<List<Business_Dossier__c>> createBusinessDossier(List<CreateBusinessDossierArgument> arguments) {
        try {
            List<List<Business_Dossier__c>> businessDossiersToReturn = new List<List<Business_Dossier__c>>();
            for (CreateBusinessDossierArgument argument : arguments){
                //This invocable can only be called with both arguments filled of type business dossier.
                if (argument.businessDossiers == null || argument.searchCriteria == null) {
                    throw new AuraHandledException(Label.Error_Input_Incorrect);
                }

                List<Business_Dossier__c> insertedBusinessDossiers = BusinessService.upsertDossiersWithCriteria(argument.businessDossiers, argument.searchCriteria, true);
                businessDossiersToReturn.add(insertedBusinessDossiers);
            }
            return businessDossiersToReturn;
        }
        catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }

}