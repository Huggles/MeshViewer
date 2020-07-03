/**
 * Created by hugovankrimpen on 01/07/2020.
 */

public interface ISepaService {

    /**
      * Checks an IBAN with / Account Holder Name combination. It can either be a match, mistype (in the name) or not a match.
      *
      * @param IBAN The International Bank Account Number to check
      * @param accountHolderName The first + lastname of the acocunt holder.
      *
      * @return SEPA Bank Account sObject.
      */
    SEPA_Bank_Account__c getSepaMatchAccountHolder(String IBAN,String accountHolderName);

    /**
      * Saves a list of SEPA Bank Account sObjects to Salesforce. Checks if the sObject already exist (based on IBAN) and updates it accordingly.
      *
      * @param sepaBankAccounts The List of sObjects
      *
      * return
      */
    void saveSEPABankAccounts(List<SEPA_Bank_Account__c> sepaBankAccounts);
}