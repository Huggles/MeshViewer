/**
 * Created by jaapbranderhorst on 2019-07-17.
 */

@IsTest
private class PostInstallScriptTest {
    
    @TestSetup
    static void testSetup() {
        Integer nrOfAccountsWithoutRecordTypeId = 20;
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < nrOfAccountsWithoutRecordTypeId; i++) {
            accounts.add(new Account(Name = '' + i));
        }
        insert accounts;

    }
    
    @IsTest
    static void testV20Upgrade() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (Account account : accounts) {
            dossiers.add(new Business_Dossier__c(Name = account.Name, Account__c = account.Id));
        }
        insert dossiers;
        // Test.testInstall(new PostInstallScript(), new Version(1,0)); // simulate an installed version since this is an upgrade test.
        Test.startTest();
        {
            Test.testInstall(new PostInstallScript(), new Version(2, 0));
        }
        Test.stopTest();
        dossiers = [SELECT Id FROM Business_Dossier__c WHERE RecordTypeId = :Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByName().get('Dutch Business').getRecordTypeId()];
        System.assert(dossiers.size() == 20);
    }

    @IsTest
    static void testInstall() {
        Test.startTest();
        {
            try {
                Test.testInstall(new PostInstallScript(), null);
            } catch (Exception ex) {
                System.assert(false);
            }
            System.assert(true);
        }
        Test.stopTest();
    }
}