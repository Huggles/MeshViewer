/**
 * Created by hugovankrimpen on 08/07/2020.
 */

@IsTest
public with sharing class UpsertBusinessDossierInvocableTest {

    @IsTest
    static void testCreateDutchDossierInvocableHappyFlow() {


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

        //Instantiate Account
        Account a = new Account();
        a.Name = 'abc';

        //Build the argument for the invocable.
        UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument upsertArgument = new UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument();
        upsertArgument.businessDossier = businessDossier;
        upsertArgument.relatedAccount = a;
        List<UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument> arguments = new List<UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument>{upsertArgument};



        Test.startTest();
        List<Business_Dossier__c> dossiers = UpsertBusinessDossierInvocable.upsertAccountWithBusinessDossier(arguments);
        Test.stopTest();


        List<Business_Dossier__c> insertedDossiers = [SELECT id, (SELECT Id FROM SBIs__r) FROM Business_Dossier__c];
        System.assertNotEquals(null,insertedDossiers);
        System.assertEquals(1, insertedDossiers.size());
        System.assertEquals(10, insertedDossiers[0].SBIs__r.size());
    }
    @IsTest
    static void testCreateDutchDossierInvocableErrorFlow() {
        //Build the argument for the invocable.
        UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument upsertArgument = new UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument();
        upsertArgument.businessDossier = null;
        upsertArgument.relatedAccount = null;
        List<UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument> arguments = new List<UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument>{upsertArgument};

        Test.startTest();
        try {
            List<Business_Dossier__c> dossiers = UpsertBusinessDossierInvocable.upsertAccountWithBusinessDossier(arguments);
            System.assert(false);
        }catch (Exception e){
            System.assert(true);
        }
        Test.stopTest();
    }
}