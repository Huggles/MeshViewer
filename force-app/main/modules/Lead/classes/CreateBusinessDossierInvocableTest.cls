/**
 * Created by vishalshete on 14/08/2020.
 */
@IsTest
public with sharing class CreateBusinessDossierInvocableTest {
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

        System.runAs(TestUtils.getDutchBusinessUser()) {
            Test.startTest();

            List<Business_Dossier__c> dossiers = CreateBusinessDossierInvocable.createBusinessDossier(arguments);
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
        System.runAs(TestUtils.getDutchBusinessUser()) {
            Test.startTest();
            try {
                List<Business_Dossier__c> dossiers = CreateBusinessDossierInvocable.createBusinessDossier(arguments);
                System.assert(false);
            } catch (Exception e) {
                System.assert(true);
            }
            Test.stopTest();
        }
    }
}