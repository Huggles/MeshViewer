/**
 * Created by hugovankrimpen on 08/07/2020.
 */

public inherited sharing class UpsertBusinessDossierInvocable {

    public inherited sharing class UpsertBusinessDossierArgument {
        @InvocableVariable(
                label='Dossier'
                description='The Dutch dossier to be inserted. This will be inserted.'
                required=true)
        public SObject businessDossier;

        @InvocableVariable(
                label='Account'
                description='The account this business dossier should be related to. This will be upserted.'
                required=true)
        public SObject relatedAccount;

        public UpsertBusinessDossierArgument() {
        }
    }

    @InvocableMethod(
            label='Upsert Account With Business Dossiers'
            description='Fetches dossiers from the Dutch Chamber of Commerce, stores them in Salesforce, and links it to an account.'
            category='Company.info')
    public static List<Business_Dossier__c> upsertAccountWithBusinessDossier(List<UpsertBusinessDossierArgument> arguments) {
        try {
            List<Business_Dossier__c> businessDossiersToUpsert = new List<Business_Dossier__c>();
            List<Account> accountsToUpsert = new List<Account>();
            for (UpsertBusinessDossierArgument dutchDossierArgument : arguments) {
                //This invocable can only be called with both arguments filled of type business dossier / account.
                if(dutchDossierArgument.businessDossier == null || dutchDossierArgument.relatedAccount == null ||
                        !(dutchDossierArgument.businessDossier instanceof Business_Dossier__c) || !(dutchDossierArgument.relatedAccount instanceof Account)){
                    throw new AuraHandledException(Label.Error_Input_Incorrect);
                }
                Business_Dossier__c businessDossier;
                Account relatedAccount;
                if(dutchDossierArgument.businessDossier instanceof Business_Dossier__c){
                    businessDossier = (Business_Dossier__c)dutchDossierArgument.businessDossier;
                }
                if(dutchDossierArgument.relatedAccount instanceof Account){
                    relatedAccount = (Account)dutchDossierArgument.relatedAccount;
                }
                businessDossiersToUpsert.add(businessDossier);
                accountsToUpsert.add(relatedAccount);
            }
            List<Business_Dossier__c> businessDossiers = BusinessService.upsertDossiersAndAccounts(businessDossiersToUpsert, accountsToUpsert, true);
            return businessDossiers;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }
}