/****************************************************************************************
Author          : ValerijsProkudins
******************************************************************************************/
@isTest
public with sharing class DutchBusinessDossierSelectorTest {

    
    @isTest
    static void testGetInstance() {
        Object o = DutchBusinessDossierSelector.newInstance();
        System.assert(o instanceof DutchBusinessDossierSelector);
    }
    @isTest
    static void testGetSObjectFields() {
        DutchBusinessDossierSelector selector = (DutchBusinessDossierSelector) DutchBusinessDossierSelector.newInstance();
        Test.startTest();
        System.runAs(TestUtils.getBDSUser()) { //didnt work. need to check with jaap how testutils work
            List<Schema.SObjectField> fields = selector.getSObjectFieldList();
            Set<Schema.SObjectField> fieldsAsSet = new Set<Schema.SObjectField>(fields);
            System.assert(fieldsAsSet.containsAll(new List<Schema.SObjectField>{
                Dutch_Business_Dossier__c.Id,
                Dutch_Business_Dossier__c.Name,
                Dutch_Business_Dossier__c.Account__c,
                Dutch_Business_Dossier__c.Account__r.Id,
                Dutch_Business_Dossier__c.Account__r.name
            }));
        }
        Test.stopTest();
        

    }

    @isTest
    static void testGetSObjectType() {
        DutchBusinessDossierSelector selector = (DutchBusinessDossierSelector) DutchBusinessDossierSelector.newInstance();
        Test.startTest();
        System.runAs(TestUtils.getBDSUser()) {//didnt work. need to check with jaap how testutils work
            Schema.SObjectType tpe = selector.getSObjectType();
            System.assertEquals(Dutch_Business_Dossier__c.sObjectType, tpe);
        }
        Test.stopTest();

    }
   

    @isTest
    static void testSelectByDossierNumber() {
        List<Account> accounts = new List<Account>();
        for (Integer i2 = 0; i2 < 10 ; i2++) {
            accounts.add(new Account(Name = 'test'+i2));
        }
        insert accounts;
        List<Dutch_Business_Dossier__c> dossiers = new List<Dutch_Business_Dossier__c>();
        Set<String> dossierNumSet = new set<String>();
        for (Integer i2 = 0; i2 < 10 ; i2++) {
            dossiers.add(new Dutch_Business_Dossier__c(Account__c = accounts[0].Id, Name = 'test'+i2, Dossier_Number__c=string.valueOf(i2)));
            dossierNumSet.add(string.valueOf(i2));
        }
        insert dossiers;
        

        

        Test.startTest();
        System.runAs(TestUtils.getBDSUser()) {//didnt work. need to check with jaap how testutils work
            IDutchBusinessDossierSelector selector = DutchBusinessDossierSelector.newInstance();
            List<Dutch_Business_Dossier__c> dossiersReturned = selector.selectByDossierNumber(dossierNumSet);
            System.assertEquals(10, dossiersReturned.size());
        }
        Test.stopTest();


    }






}
