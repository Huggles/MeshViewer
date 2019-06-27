@isTest
public with sharing class AccountSelectorTest {

    @TestSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accounts.add(new Account(Name = '' + i));
        }
        insert accounts;
    }

    @isTest
    static void testSelectById() {
        Map<Id, Account> accountsByIds = new Map<Id, Account>([SELECT Id FROM Account]);
        Set<Id> idSet = accountsByIds.keySet();

        Test.startTest();
        List<Account> accountsReturned = AccountSelector.newInstance().selectById(idSet);
        Test.stopTest();
        System.assertEquals(10, accountsReturned.size());
    }



}