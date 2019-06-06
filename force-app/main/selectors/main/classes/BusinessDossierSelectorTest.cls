/****************************************************************************************
Author          : ValerijsProkudins
******************************************************************************************/
@isTest
public with sharing class BusinessDossierSelectorTest {

    
    @isTest
    static void testGetInstance() {
        Object o = BusinessDossierSelector.newInstance();
        System.assert(o instanceof BusinessDossierSelector);
    }
    @isTest
    static void testGetSObjectFields() {
        BusinessDossierSelector selector = (BusinessDossierSelector) BusinessDossierSelector.newInstance();
        Test.startTest();
        System.runAs(TestUtils.getCompanyConnectUser()) { //didnt work. need to check with jaap how testutils work
            List<Schema.SObjectField> fields = selector.getSObjectFieldList();
            Set<Schema.SObjectField> fieldsAsSet = new Set<Schema.SObjectField>(fields);
            System.assert(fieldsAsSet.containsAll(new List<Schema.SObjectField>{
                Business_Dossier__c.Id,
                Business_Dossier__c.Name,
                Business_Dossier__c.Account__c,
                Business_Dossier__c.Account__r.Id,
                Business_Dossier__c.Account__r.name
            }));
        }
        Test.stopTest();
        

    }

    @isTest
    static void testGetSObjectType() {
        BusinessDossierSelector selector = (BusinessDossierSelector) BusinessDossierSelector.newInstance();
        Test.startTest();
        System.runAs(TestUtils.getCompanyConnectUser()) {//didnt work. need to check with jaap how testutils work
            Schema.SObjectType tpe = selector.getSObjectType();
            System.assertEquals(Business_Dossier__c.sObjectType, tpe);
        }
        Test.stopTest();

    }
   

    @isTest
    static void testSelectByDossierNumber() {
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        Set<String> dossierNumSet = new set<String>();
        for (Integer i2 = 0; i2 < 10 ; i2++) {
            dossiers.add(new Business_Dossier__c(Name = 'test'+i2, Dossier_Number__c=string.valueOf(i2)));
            dossierNumSet.add(string.valueOf(i2));
        }
        insert dossiers;
        

        

        Test.startTest();
        System.runAs(TestUtils.getCompanyConnectUser()) {//didnt work. need to check with jaap how testutils work
            IBusinessDossierSelector selector = BusinessDossierSelector.newInstance();
            List<Business_Dossier__c> dossiersReturned = selector.selectByDossierNumber(dossierNumSet);
            System.assertEquals(10, dossiersReturned.size());
        }
        Test.stopTest();


    }






}
