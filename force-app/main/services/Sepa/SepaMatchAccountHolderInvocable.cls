/**
 * Created by hugovankrimpen on 01/07/2020.
 */

global with sharing class SepaMatchAccountHolderInvocable {

    global inherited sharing class SepaMatchAccountHolderArgument {
        @InvocableVariable(label='Account Holder Name' description='The name of the account holder ' required=true)
        global String accountName;
        @InvocableVariable(label='Account Number' description='The IBAN number of the account' required=true)
        global String accountNumber;

        @TestVisible
        private SepaMatchAccountHolderArgument(String accountName, String accountNumber) {
            this.accountName = accountName;
            this.accountNumber = accountNumber;
        }
        global SepaMatchAccountHolderArgument(){

        }

    }
    @InvocableMethod(
            label='Validate Account Holder with IBAN Number'
            description='Checks whether the IBAN numbers and Account Holder Names match and stores them in Salesforce'
            category='Company.info')
    global static List<SEPA_Bank_Account__c> validateAccountHolderWithIBANNumber(List<SepaMatchAccountHolderArgument> arguments) {
        try {
            if(!FeatureAccessControlController.checkAccess(Feature.SEPA)){
                throw new FeatureAccessException('The user does not have access to the feature: ' + Feature.SEPA.name());
            }
            List<SEPA_Bank_Account__c> sepaBankAccounts = new List<SEPA_Bank_Account__c>();
            for (SepaMatchAccountHolderArgument sepaMatchAccountHolderArgument : arguments) {
                SEPA_Bank_Account__c sepaBankAccount = SepaService.getSepaMatchAccountHolder(
                        sepaMatchAccountHolderArgument.accountNumber,
                        sepaMatchAccountHolderArgument.accountName);
                if(sepaBankAccount != null){
                    sepaBankAccounts.add(sepaBankAccount);
                }
            }
            SepaService.saveSEPABankAccounts(sepaBankAccounts);
            return sepaBankAccounts;
        } catch (Exception ex) {
            throw ex;
        }
    }
}