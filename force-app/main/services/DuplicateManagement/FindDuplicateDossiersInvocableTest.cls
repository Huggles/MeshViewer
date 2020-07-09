/**
 * Created by hugovankrimpen on 08/07/2020.
 */

@IsTest
public with sharing class FindDuplicateDossiersInvocableTest {
    @TestSetup
    static void setup() {
        Business_Dossier__c businessDossier = new Business_Dossier__c();
        businessDossier.Dossier_Number__c = '123';
        businessDossier.Establishment_Number__c = '456';
        insert businessDossier;
    }

    @IsTest
    static void findDuplicatesHappyFlowTest() {
        Business_Dossier__c businessDossier = new Business_Dossier__c();
        businessDossier.Dossier_Number__c = '123';
        businessDossier.Establishment_Number__c = '456';

        Test.startTest();
        List<Business_Dossier__c>  duplicateDossiers = FindDuplicateDossiersInvocable.findDuplicates(new List<Business_Dossier__c>{businessDossier});
        Test.stopTest();

        System.assertNotEquals(duplicateDossiers, null);
        System.assertNotEquals(duplicateDossiers.size(), 0);
    }
    @IsTest
    static void findDuplicatesErrorTest() {

        Test.startTest();
        try {
            List<Business_Dossier__c>  duplicateDossiers = FindDuplicateDossiersInvocable.findDuplicates(new List<Business_Dossier__c>());
            System.assert(false);
        }catch (Exception e){
            System.assert(true);
        }
        Test.stopTest();
    }
}



