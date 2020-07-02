/**
 * Created by hugovankrimpen on 01/07/2020.
 */

public with sharing class SepaServiceImpl implements ISepaService{


    public static SEPA_Bank_Account__c getSepaMatchAccountHolder(String IBAN,String accountHolderName){
        //do something
        SepaWsdl.SepaMatchAccountHolderResult sepaMatchAccountHolderResult;
        try {
            sepaMatchAccountHolderResult = WsSepa.sepaMatchAccountHolder(IBAN, accountHolderName);
        }
        catch (CalloutException calloutException){
            //This exception is thrown when the IBAN or AccountHolderName are incorrect.
            throw calloutException;
        }
        catch (Exception e){
            //This should hopefully never happen.
            throw e;
        }

        if(sepaMatchAccountHolderResult != null){
            //If its a match, create it! -OR-
            //If its mistype, create it only if its an ORGANIZATION
            if(sepaMatchAccountHolderResult.name_matching_result.type_x == 'MATCHING' ||
                    (   sepaMatchAccountHolderResult.name_matching_result != null &&
                            sepaMatchAccountHolderResult.name_matching_result.type_x == 'MISTYPE' &&
                            sepaMatchAccountHolderResult.bank_account_holder != null &&
                            sepaMatchAccountHolderResult.bank_account_holder.type_x == 'ORG')){
                return createSEPABankAccount(sepaMatchAccountHolderResult);
            }
        }
        return null;
    }
    public void saveSEPABankAccounts(List<SEPA_Bank_Account__c> sepaBankAccounts){
        //Insert Existing SEPA Bank Account Ids
        insertExistingSEPABankAccountsIds(sepaBankAccounts);
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        unitOfWork.registerUpsert(sepaBankAccounts);
        unitOfWork.commitWork();
    }


    /****************************/
    /** IMPLEMENTATION METHODS **/
    /****************************/

    private static SEPA_Bank_Account__c createSEPABankAccount(SepaWsdl.SepaMatchAccountHolderResult sepaMatchAccountHolderResults){
        SEPA_Bank_Account__c sepaBankAccount = new SEPA_Bank_Account__c();
        sepaBankAccount.Name = sepaMatchAccountHolderResults.iban;
        sepaBankAccount.Active__c = (sepaMatchAccountHolderResults.bank_account_details.status == 'ACTIVE');
        sepaBankAccount.Country_Code__c = sepaMatchAccountHolderResults.bank_account_details.country_code;
        sepaBankAccount.Foreign__c = sepaMatchAccountHolderResults.bank_account_details.foreign;
        sepaBankAccount.Account_Holder_Type__c = sepaMatchAccountHolderResults.bank_account_holder.type_x;
        return sepaBankAccount;
    }

    private static void insertExistingSEPABankAccountsIds(List<SEPA_Bank_Account__c> sepaBankAccounts){
        System.debug(sepaBankAccounts);
        Set<String> IBANs = new Set<String>();
        for(SEPA_Bank_Account__c sepaBankAccount : sepaBankAccounts){
            IBANs.add(sepaBankAccount.Name);
        }
        List<SEPA_Bank_Account__c> existingSEPABankAccounts = [SELECT Id, Name FROM SEPA_Bank_Account__c WHERE Name IN :IBANs];
        Map<String, SEPA_Bank_Account__c> existingSEPABankAccountsMap = new Map<String, SEPA_Bank_Account__c>();
        for(SEPA_Bank_Account__c existingSEPABankAccount : existingSEPABankAccounts){
            existingSEPABankAccountsMap.put(existingSEPABankAccount.Name, existingSEPABankAccount);
        }
        for(SEPA_Bank_Account__c sepaBankAccount : sepaBankAccounts){
            if(existingSEPABankAccountsMap.containsKey(sepaBankAccount.Name)){
                sepaBankAccount.Id = existingSEPABankAccountsMap.get(sepaBankAccount.Name).Id;
            }
        }
    }

}