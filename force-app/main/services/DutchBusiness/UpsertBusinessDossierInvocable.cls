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

        @TestVisible
        private UpsertBusinessDossierArgument(Business_Dossier__c businessDossier, Account relatedAccount) {
            this.businessDossier = businessDossier;
            this.relatedAccount = relatedAccount;
        }

        public UpsertBusinessDossierArgument() {

        }
    }

    @InvocableMethod(
            label='Upsert Account & Insert Business Dossiers'
            description='Fetches dossiers from the Dutch Chamber of Commerce, stores them in Salesforce, and links it to an account.'
            category='Company.info')
    public static List<Business_Dossier__c> upsertAccountWithBusinessDossier(List<UpsertBusinessDossierArgument> arguments) {
        try {
            System.debug('>><<');



            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
            List<Business_Dossier__c> businessDossiers = new List<Business_Dossier__c>();
            for (UpsertBusinessDossierArgument dutchDossierArgument : arguments) {
                Business_Dossier__c businessDossier;
                Account relatedAccount;
                if(dutchDossierArgument.businessDossier instanceof Business_Dossier__c){
                    businessDossier = (Business_Dossier__c)dutchDossierArgument.businessDossier;
                }
                if(dutchDossierArgument.relatedAccount instanceof Account){
                    relatedAccount = (Account)dutchDossierArgument.relatedAccount;
                }
                System.debug(JSON.serialize(dutchDossierArgument));
                //Add account to response
                unitOfWork.registerUpsert(relatedAccount);

                //Loop through all records to register them for insert.
                unitOfWork.registerNew(businessDossier);
                for(Business_Data_SBI__c sbi : businessDossier.SBIs__r){
                    unitOfWork.registerNew(sbi);
                }
                unitOfWork.registerRelationship(relatedAccount, Account.Business_Dossier__c, businessDossier);

                businessDossiers.add(businessDossier);
            }
            unitOfWork.commitWork();

            System.debug(businessDossiers);

            return businessDossiers;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }

    }


}