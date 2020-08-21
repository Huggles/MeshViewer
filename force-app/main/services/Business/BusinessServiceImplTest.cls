@isTest
public with sharing class BusinessServiceImplTest {

    @IsTest
    public static void testDeleteDossierHappyFlow() {
        // given
        // a business dossier, a SBI code and an address in the DB
        Business_Dossier__c dossier = new Business_Dossier__c(Name = 'test');
        insert dossier;
        Business_Data_SBI__c sb = new Business_Data_SBI__c(Business_Dossier__c = dossier.Id);
        insert sb;

        // when
        Test.startTest();
        BusinessService.deleteDossier(dossier.Id, false);
        Test.stopTest();

        // then
        // no objects any more
        System.assert([SELECT Id FROM Business_Dossier__c].size() == 0);
        System.assert([SELECT Id FROM Business_Data_SBI__c].size() == 0);
    }

    @IsTest
    public static void testUpsertDossierHappyFlow() {
        //given
        string dossierNumber = '123';
        string establishmentNumber = '567';
        initiateMock(dossierNumber, establishmentNumber);


        InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument instantiateBusinessDossierArgument = new InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument();
        instantiateBusinessDossierArgument.dossierNumber = dossierNumber;
        instantiateBusinessDossierArgument.establishmentNumber = establishmentNumber;
        List<Business_Dossier__c> businessDossier = InstantiateBusinessDossierInvocable.instantiateBusinessDossier(
                new List<InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument>{instantiateBusinessDossierArgument}
        );
        System.assertEquals(1, businessDossier.size());


        Account relatedAccount = new Account();
        relatedAccount.Name = businessDossier[0].Name;

        UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument argument = new UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument();
        argument.businessDossier = businessDossier[0];
        argument.relatedAccount = relatedAccount;


        // when
        Test.startTest();
        UpsertBusinessDossierInvocable.upsertAccountWithBusinessDossier(
                new List<UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument>{argument}
        );
        Test.stopTest();


        // then
        //One Business Dossier
        List<Business_Dossier__c> businessDossiersInserted = [SELECT Id FROM Business_Dossier__c];
        System.assertEquals(1, businessDossiersInserted.size());

        //10 SBIs connected to that business dossier
        List<Business_Data_SBI__c> sbis = [SELECT Id FROM Business_Data_SBI__c WHERE Business_Dossier__c IN :businessDossiersInserted];
        System.assertEquals(10, sbis.size());
    }
    @IsTest
    public static void testUpsertDossierSBISize() {
        //given
        string dossierNumber = '123';
        string establishmentNumber = '567';
        initiateMock(dossierNumber, establishmentNumber);
        List<Business_Dossier__c> instantiatedBusinessDossiers = instantiateBusinessDossier(dossierNumber, establishmentNumber);

        System.assertEquals(1, instantiatedBusinessDossiers.size());
        Account relatedAccount = new Account();
        relatedAccount.Name = instantiatedBusinessDossiers[0].Name;

        upsertBusinessDossierAndAccount(instantiatedBusinessDossiers[0], relatedAccount);

        //Remove the account so we can do another upsert.
        Account upsertedAccount = [SELECT Id, Business_Dossier__c FROM Account WHERE Name = :relatedAccount.Name];
        delete upsertedAccount;

        // when
        Test.startTest();
        List<Business_Dossier__c> instantiatedBusinessDossiers2 = instantiateBusinessDossier(dossierNumber, establishmentNumber);
        System.assertEquals(1, instantiatedBusinessDossiers2.size());
        //This normally happens in the flow, now do it in Apex so we are sure it will upsert.
        instantiatedBusinessDossiers2[0].Id = instantiatedBusinessDossiers[0].Id;
        System.assertNotEquals(null,instantiatedBusinessDossiers2[0].Id);

        //Do the upsert again, but with a business dossier already fully in Salesforce
        Account relatedAccount2 = new Account();
        relatedAccount2.Name = instantiatedBusinessDossiers2[0].Name;
        upsertBusinessDossierAndAccount(instantiatedBusinessDossiers2[0], relatedAccount2);
        Test.stopTest();


        // then
        //One Business Dossier
        List<Business_Dossier__c> businessDossiersInserted = [SELECT Id FROM Business_Dossier__c];
        System.assertEquals(1, businessDossiersInserted.size());

        //10 SBIs connected to that business dossier
        List<Business_Data_SBI__c> sbis = [SELECT Id FROM Business_Data_SBI__c WHERE Business_Dossier__c IN :businessDossiersInserted];
        System.assertEquals(10, sbis.size());
    }

    private static void initiateMock(string dossierNumber, string establishmentNumber){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        mocks.startStubbing();
        DutchBusinessWsdl.DutchBusinessDossierV3 output = DutchBusinessServiceImplTest.getDataVendorMockDossier();
        mocks.when(mockWS.dutchBusinessGetDossierV3(dossierNumber, establishmentNumber)).thenReturn(output);
        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, mockWS);
    }

    private static List<Business_Dossier__c> instantiateBusinessDossier(string dossierNumber, string establishmentNumber){
        //Instantiate business dossier
        InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument instantiateBusinessDossierArgument = new InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument();
        instantiateBusinessDossierArgument.dossierNumber = dossierNumber;
        instantiateBusinessDossierArgument.establishmentNumber = establishmentNumber;
        List<Business_Dossier__c> businessDossier = InstantiateBusinessDossierInvocable.instantiateBusinessDossier(
                new List<InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument>{instantiateBusinessDossierArgument}
        );
        return businessDossier;
    }
    private static void upsertBusinessDossierAndAccount(Business_Dossier__c businessDossier, Account relatedAccount){
        //Upsert business dossier and account
        UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument argument = new UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument();
        argument.businessDossier = businessDossier;
        argument.relatedAccount = relatedAccount;
        UpsertBusinessDossierInvocable.upsertAccountWithBusinessDossier(
                new List<UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument>{argument}
        );
    }


    @IsTest
    public static void testGetCountryOptionsForBusinessSearchDutchBusiness() {
        Test.startTest();
        Map<String, String> countryOptions = null;
        System.runAs(TestUtils.getDutchBusinessUser()) {
            countryOptions = BusinessService.getCountryOptionsForBusinessSearch();
        }
        Test.stopTest();
        System.assertEquals(1, countryOptions.size());
        System.assertEquals('NL', countryOptions.values().get(0));
        System.assertEquals(true, countryOptions.containsKey(Label.Country_Netherlands));
    }

}