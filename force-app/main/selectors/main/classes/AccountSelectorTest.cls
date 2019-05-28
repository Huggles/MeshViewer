@isTest
public with sharing class AccountSelectorTest {
    
    @isTest
    static void testGetInstance() {
        Object o = AccountSelector.newInstance();
        System.assert(o instanceof AccountSelector);
    }
    @isTest
    static void testGetSObjectFields() {
        AccountSelector selector = (AccountSelector) AccountSelector.newInstance();
        Test.startTest();
        System.runAs(TestUtils.getBDSUser()) {
            List<Schema.SObjectField> fields = selector.getSObjectFieldList();
            Set<Schema.SObjectField> fieldsAsSet = new Set<Schema.SObjectField>(fields);
            System.assert(fieldsAsSet.containsAll(new List<Schema.SObjectField>{
                Account.Id,
                Account.Name,
                account.Dutch_Business_Dossier__c
            }));
        }
        Test.stopTest();

    }

    @isTest
    static void testGetSObjectType() {
        AccountSelector selector = (AccountSelector) AccountSelector.newInstance();
        Test.startTest();
        System.runAs(TestUtils.getBDSUser()) {
            Schema.SObjectType tpe = selector.getSObjectType();
            System.assertEquals(Account.sObjectType, tpe);
        }
        Test.stopTest();

    }


    @isTest
    static void testSelectById() {
        List<Account> accounts = new List<Account>();
        for (Integer i2 = 0; i2 < 10 ; i2++) {
            accounts.add(new Account(Name = 'test'+i2));
        }
        insert accounts;

        Set<Id> idSet = (new Map<Id, Account>(accounts)).keySet();

        Test.startTest();
        System.runAs(TestUtils.getBDSUser()) {
            IAccountSelector selector = AccountSelector.newInstance();
            List<Account> accountsReturned = selector.selectById(idSet);
            System.assertEquals(10, accountsReturned.size());
        }
        Test.stopTest();


    }



}