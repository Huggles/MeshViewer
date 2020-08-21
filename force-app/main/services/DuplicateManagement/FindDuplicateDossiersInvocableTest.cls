/**
 * Created by hugovankrimpen on 08/07/2020.
 */

@IsTest
public with sharing class FindDuplicateDossiersInvocableTest {
    @TestSetup
    static void setup() {
        System.runAs(CompanyInfoTestUserFactory.getDutchBusinessUser()) {
            Business_Dossier__c businessDossier = new Business_Dossier__c();
            businessDossier.Dossier_Number__c = '123';
            businessDossier.Establishment_Number__c = '456';
            insert businessDossier;
        }

    }

    @IsTest
    static void findDuplicatesHappyFlowTest() {
        System.runAs(CompanyInfoTestUserFactory.getDutchBusinessUser()) {
            Business_Dossier__c businessDossier = new Business_Dossier__c();
            businessDossier.Dossier_Number__c = '123';
            businessDossier.Establishment_Number__c = '456';

            FindDuplicateDossiersInvocable.FindDuplicateDossiersArgument argument = new FindDuplicateDossiersInvocable.FindDuplicateDossiersArgument();
            argument.dossier = businessDossier;
            Test.startTest();
            List<List<Business_Dossier__c>> duplicateDossiers =
                    FindDuplicateDossiersInvocable.findDuplicates(new List<FindDuplicateDossiersInvocable.FindDuplicateDossiersArgument>{
                            argument
                    });
            Test.stopTest();

            System.assertNotEquals(duplicateDossiers, null);
            System.assertNotEquals(duplicateDossiers.size(), 0);
        }

    }
    @IsTest
    static void findDuplicatesNoInputTest() {
        System.runAs(CompanyInfoTestUserFactory.getDutchBusinessUser()) {
            Test.startTest();
            List<List<Business_Dossier__c>> duplicateDossiers = FindDuplicateDossiersInvocable.findDuplicates(new List<FindDuplicateDossiersInvocable.FindDuplicateDossiersArgument>{

            });
            Test.stopTest();
            System.assertNotEquals(null, duplicateDossiers);
            System.assertEquals(1, duplicateDossiers.size());
            System.assertEquals(0, duplicateDossiers[0].size());
        }
    }
}



