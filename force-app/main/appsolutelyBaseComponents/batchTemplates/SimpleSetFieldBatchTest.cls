/**
 * Created by jaapbranderhorst on 2019-07-16.
 */

@IsTest
private class SimpleSetFieldBatchTest {

    @TestSetup
    static void setup() {
        Integer nrOfAccounts = 10;
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < nrOfAccounts; i++) {
            accounts.add(new Account(Name = '' + i));
        }
        insert accounts;
    }

    @IsTest
    static void testBehavior() {
        Test.startTest();
        Database.executeBatch(new SimpleSetFieldBatch(new Map<String, Object>{'Name' => 'test'}, 'Account', 'Name != \'\''));
        Test.stopTest();
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'test'];
        System.assert(accounts.size() == 10);
    }
}