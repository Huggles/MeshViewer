/**
 * Created by jaapbranderhorst on 2019-06-20.
 */

@IsTest
private class SimpleDataMigrationBatchTest {

    private static Map<String, String> accountOldToNewFields = new Map<String, String>{
            'Name' => 'Site'
    };

    @TestSetup
    static void testSetup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Name' + i));
        }
        insert accounts;
    }


    @IsTest
    static void testNoFilter() {
        Test.startTest();
        Database.executeBatch(new SimpleDataMigrationBatch(accountOldToNewFields, 'Account', null));
        Test.stopTest();
        List<Account> accounts = [SELECT Id, Name, Site FROM Account];
        for (Account account : accounts) {
            System.assert(account.Name.startsWith('Name'));
            System.assert(account.Site.startsWith('Name'));
        }
        System.assert(accounts.size() == 5);
    }

    @IsTest
    static void testFilterDescription () {
        Test.startTest();
        Database.executeBatch(new SimpleDataMigrationBatch(accountOldToNewFields, 'Account', 'Name = \'Name1\''));
        Test.stopTest();
        List<Account> accounts = [SELECT Id, Name, Site FROM Account WHERE Site = 'Name1'];
        for (Account account : accounts) {
            System.assert(account.Name.equals('Name1'));
            System.assert(account.Site.equals('Name1'));
        }
        System.assert(accounts.size() == 1);
    }

}