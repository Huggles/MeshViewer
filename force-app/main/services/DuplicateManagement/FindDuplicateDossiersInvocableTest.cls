/**
 * Created by hugovankrimpen on 08/07/2020.
 */

@IsTest
public with sharing class FindDuplicateDossiersInvocableTest {
    @TestSetup
    static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE UserLicense.Name = 'Salesforce' LIMIT 1];

        User u = new User(Alias = 'stdUser', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', Username='CompanyInfor.CommonTestUser@testorg.com');
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Company_info_for_Sales'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
        System.runas(u){
            Business_Dossier__c businessDossier = new Business_Dossier__c();
            businessDossier.Dossier_Number__c = '123';
            businessDossier.Establishment_Number__c = '456';
            insert businessDossier;
        }
    }

    @IsTest
    static void findDuplicatesHappyFlowTest() {
        Business_Dossier__c businessDossier = new Business_Dossier__c();
        businessDossier.Dossier_Number__c = '123';
        businessDossier.Establishment_Number__c = '456';

        FindDuplicateDossiersInvocable.FindDuplicateDossiersArgument argument = new FindDuplicateDossiersInvocable.FindDuplicateDossiersArgument();
        argument.dossier = businessDossier;
        List<List<Business_Dossier__c>> duplicateDossiers = new List<List<Business_Dossier__c>>();
        User user = [SELECT Id FROM User WHERE Username = 'CompanyInfor.CommonTestUser@testorg.com'];
        System.runAs(user) {
            Test.startTest();

            duplicateDossiers =   FindDuplicateDossiersInvocable.findDuplicates(new List<FindDuplicateDossiersInvocable.FindDuplicateDossiersArgument>{
                            argument
                    });
            Test.stopTest();
        }
        System.assertNotEquals(duplicateDossiers, null);
        System.assertNotEquals(duplicateDossiers.size(), 0);
    }
    @IsTest
    static void findDuplicatesNoInputTest() {

        List<List<Business_Dossier__c>> duplicateDossiers = new List<List<Business_Dossier__c>>();
        User user = [SELECT Id FROM User WHERE Username = 'CompanyInfor.CommonTestUser@testorg.com'];
        System.runAs(user) {
            Test.startTest();
            duplicateDossiers = FindDuplicateDossiersInvocable.findDuplicates(new List<FindDuplicateDossiersInvocable.FindDuplicateDossiersArgument>{
            });
            Test.stopTest();
        }
        System.assertNotEquals(null, duplicateDossiers);
        System.assertEquals(1, duplicateDossiers.size());
        System.assertEquals(0, duplicateDossiers[0].size());
    }
}



