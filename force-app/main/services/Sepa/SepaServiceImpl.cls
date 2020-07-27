/**
 * Created by hugovankrimpen on 01/07/2020.
 *
 * This class runs without sharing rules enabled.
 * It should always be able to access all records, for example to find duplicates.
 */

public without sharing class SepaServiceImpl implements ISepaService{


    public static SEPA_Bank_Account__c getSepaMatchAccountHolder(String IBAN,String accountHolderName){
        //do something
        SepaWsdl.SepaMatchAccountHolderResult sepaMatchAccountHolderResult;
        try {
            sepaMatchAccountHolderResult = WsSepa.sepaMatchAccountHolder(IBAN, accountHolderName);
        }
        catch (CCWsClientInputInvalidException clientInputInvalidException){
            //This exception is thrown when the IBAN or AccountHolderName are incorrect.
            throw clientInputInvalidException;
        }
        catch (Exception e){
            //This should hopefully never happen.
            ErrorLogUtil.logException(e, true);
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
        sepaBankAccount.Number_of_Account_Holders__c = sepaMatchAccountHolderResults.bank_account_holder.number_of_account_holders;
        sepaBankAccount.Joint_Account__c = sepaMatchAccountHolderResults.bank_account_holder.joint_account;
        return sepaBankAccount;
    }

    private static void insertExistingSEPABankAccountsIds(List<SEPA_Bank_Account__c> sepaBankAccounts){
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