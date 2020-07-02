/**
 * Created by hugovankrimpen on 01/07/2020.
 */

public interface ISepaService {
    SEPA_Bank_Account__c getSepaMatchAccountHolder(String IBAN,String accountHolderName);
    void saveSEPABankAccounts(List<SEPA_Bank_Account__c> sepaBankAccounts);
}