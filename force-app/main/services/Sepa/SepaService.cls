/**
 * Created by hugovankrimpen on 01/07/2020.
 */

public with sharing class SepaService {
    public static SEPA_Bank_Account__c getSepaMatchAccountHolder(String IBAN,String accountHolderName){
        return newInstance().getSepaMatchAccountHolder(IBAN, accountHolderName);
    }

    public static void saveSEPABankAccounts(List<SEPA_Bank_Account__c> sepaBankAccounts){
        newInstance().saveSEPABankAccounts(sepaBankAccounts);
    }

    public static ISepaService newInstance() {
        return (ISepaService) Application.Service.newInstance(ISepaService.class);
    }
}