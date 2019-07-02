/****************************************************************************************
Author          : ValerijsProkudins
******************************************************************************************/
@isTest
public with sharing class BusinessDossierSelectorTest {

    @TestSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 20; i++) {
            accounts.add(new Account(Name = '' + i));
        }
        insert accounts;
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (Integer i = 0; i < 20; i++) {
            dossiers.add(new Business_Dossier__c(Account__c = accounts.get(i).Id, Dossier_Number__c = '' + i, Establishment_Number__c = '1', VAT_Number__c = 'vat' + i));
            dossiers.add(new Business_Dossier__c(Account__c = accounts.get(i).Id, Dossier_Number__c = '' + i, Establishment_Number__c = '2', VAT_Number__c = 'vat' + i));
        }
        insert dossiers;
    }

    @isTest
    static void testSelectByDossierNumber() {
        Set<String> dossierNumbers = new Set<String>();
        for (Integer i = 0; i < 20; i++) {
            dossierNumbers.add('' + i);
        }
        Test.startTest();
        List<Business_Dossier__c> dossiers = BusinessDossierSelector.newInstance().selectByDossierNumber(dossierNumbers, false);
        Test.stopTest();
        System.assert(dossiers.size() == 40);
        for (Business_Dossier__c businessDossier : dossiers) {
            System.assert(!String.isEmpty(businessDossier.Dossier_Number__c));
            System.assert(!String.isEmpty(businessDossier.Establishment_Number__c));
            System.assert(!String.isEmpty(businessDossier.VAT_Number__c));
        }
    }

    @isTest
    static void testSelectByDossierNumberAndEstablishmentNumber() {
        Set<DossierQueryDTO> dossierNumbers = new Set<DossierQueryDTO>();
        Test.startTest();
        for (Integer i = 0; i < 20; i++) {
            dossierNumbers.add(new DossierQueryDTO('' + i, '1'));
        }
        List<Business_Dossier__c> dossiers = BusinessDossierSelector.newInstance().selectByDossierNumbers(dossierNumbers, false);
        Test.stopTest();
        System.assert(dossiers.size() == 20);
        for (Business_Dossier__c businessDossier : dossiers) {
            System.assert(!String.isEmpty(businessDossier.Dossier_Number__c));
            System.assert(!String.isEmpty(businessDossier.Establishment_Number__c));
            System.assert(businessDossier.Establishment_Number__c == '1');
            System.assert(!String.isEmpty(businessDossier.VAT_Number__c));
        }
    }

    @IsTest
    static void testSelectById() {
        Map<Id, Business_Dossier__c> dossiersByIds = new Map<Id, Business_Dossier__c>([SELECT Id FROM Business_Dossier__c]);
        Test.startTest();
        List<Business_Dossier__c> dossiers = BusinessDossierSelector.newInstance().selectById(dossiersByIds.keySet());
        System.assert(dossiers.size() == 40);
    }

    @IsTest
    static void testSelectByVatNumber() {

        List<Business_Dossier__c> dossiers = null;
        Test.startTest();
        {
            dossiers = BusinessDossierSelector.newInstance().selectByVatNumber('vat' + 1, false);
        }
        Test.stopTest();
        System.assert(dossiers.size() == 2);

    }


}
