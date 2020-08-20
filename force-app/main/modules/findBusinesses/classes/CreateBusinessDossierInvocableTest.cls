/**
 * Created by vishalshete on 14/08/2020.
 */
@IsTest
public with sharing class CreateBusinessDossierInvocableTest {
    @TestSetup
    public static void createTestUser(){
        Profile p = [SELECT Id FROM Profile WHERE UserLicense.Name = 'Salesforce' LIMIT 1];

        User u = new User(Alias = 'stdUser', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', Username='CompanyInfor.CommonTestUser@testorg.com');
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Company_info_for_Sales'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
    }
    @IsTest
    public static void createBusinessDossierHappyFlow(){

        //Instantiate sObject
        string dossierNumber = '1234';
        string establishmentNumber = '5678';
        InstantiateBusinessDossierInvocableTest.initiateMockResponse(dossierNumber, establishmentNumber);

        InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument argument = new InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument();
        argument.dossierNumber = dossierNumber;
        argument.establishmentNumber = establishmentNumber;

        //This function is tested in "InstantiateBusinessDossierInvocableTest
        Business_Dossier__c businessDossier =
                InstantiateBusinessDossierInvocable.instantiateBusinessDossier(
                        new List<InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument>{argument}
                )[0];

        List<Business_Dossier__c> businessDossiers = new List<Business_Dossier__c>();
        businessDossiers.add(businessDossier);

        //Build the argument for the invocable.
        CreateBusinessDossierInvocable.CreateBusinessDossierArgument createBusinessDossierArgument = new CreateBusinessDossierInvocable.CreateBusinessDossierArgument();
        createBusinessDossierArgument.businessDossiers = businessDossiers;
        List<CreateBusinessDossierInvocable.CreateBusinessDossierArgument> arguments = new List<CreateBusinessDossierInvocable.CreateBusinessDossierArgument>{createBusinessDossierArgument};
        User user = [SELECT Id FROM User WHERE Username = 'CompanyInfor.CommonTestUser@testorg.com'];
        System.runAs(user) {
            Test.startTest();
            CreateBusinessDossierInvocable.createBusinessDossier(arguments);
            Test.stopTest();
        }
        List<Business_Dossier__c> insertedDossiers = [SELECT id FROM Business_Dossier__c];
        System.assertNotEquals(null,insertedDossiers);
        System.assertEquals(1, insertedDossiers.size());
    }

    @IsTest
    static void testCreateBusinessDossierErrorFlow() {
        //Build the argument for the invocable.
        CreateBusinessDossierInvocable.CreateBusinessDossierArgument createBusinessDossierArgument = new CreateBusinessDossierInvocable.CreateBusinessDossierArgument();

        createBusinessDossierArgument.businessDossiers = null;

        List<CreateBusinessDossierInvocable.CreateBusinessDossierArgument> arguments = new List<CreateBusinessDossierInvocable.CreateBusinessDossierArgument>{createBusinessDossierArgument};

        User user = [SELECT Id FROM User WHERE Username = 'CompanyInfor.CommonTestUser@testorg.com'];
        System.runAs(user) {
            Test.startTest();
            try {
                CreateBusinessDossierInvocable.createBusinessDossier(arguments);
                System.assert(false);
            } catch (Exception e) {
                System.assert(true);
            }
            Test.stopTest();
        }
    }
}