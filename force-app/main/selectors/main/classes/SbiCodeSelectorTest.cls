/**
 * Created by jaapbranderhorst on 2019-06-22.
 */

@IsTest
private class SbiCodeSelectorTest {

    @TestSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accounts.add(new Account(Name = '' + i));
        }
        insert accounts;
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (Integer i = 0; i < 10; i++) {
            dossiers.add(new Business_Dossier__c(Account__c = accounts.get(i).Id));
        }
        insert dossiers;
        List<Business_Data_SBI__c> sbiCodes = new List<Business_Data_SBI__c>();
        for (Business_Dossier__c businessDossier : dossiers) {
            for (Integer i = 0; i < 5; i++) {
                sbiCodes.add(new Business_Data_SBI__c(
                        Business_Dossier__c = businessDossier.Id,
                        SBI_Code__c = '' + i,
                        SBI_Description__c = '' + i,
                        SBI_Type__c = 'original')
                );
            }
        }
        insert sbiCodes;
    }

    @IsTest
    static void testSelectByDossierId() {
        Map<Id, Business_Dossier__c> dossiersByIds = new Map<Id, Business_Dossier__c>([SELECT Id FROM Business_Dossier__c]);
        Test.startTest();
        List<Business_Data_SBI__c> selectedDataSBIS = SbiCodeSelector.newInstance().selectByDossierId(dossiersByIds.keySet());
        System.assert(selectedDataSBIS.size() == 50);
        for (Business_Data_SBI__c businessDataSBI : selectedDataSBIS) {
            System.assert(!String.isEmpty(businessDataSBI.SBI_Code__c));
            System.assert(!String.isEmpty(businessDataSBI.SBI_Description__c));
            System.assert(!String.isEmpty(businessDataSBI.SBI_Type__c));
        }
    }
}