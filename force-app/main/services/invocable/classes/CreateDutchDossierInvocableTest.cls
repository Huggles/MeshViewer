/**
 * Created by jaapbranderhorst on 23/02/2020.
 */

@IsTest
private class CreateDutchDossierInvocableTest {
    @IsTest
    static void testCreateDutchDossierInvocableHappyFlow() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IDutchBusinessService dutchBusinessServiceMock = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);

        mocks.startStubbing();
        String dossierNumber1 = '1234';
        String establishmentNUmber2 = '3234';
        String dossierNumber2 = null;
        String establishmentNUmber1 = '1234';
        Business_Dossier__c dossier1 = new Business_Dossier__c(Name = 'test1', Dossier_Number__c = dossierNumber1, Establishment_Number__c = establishmentNUmber1, Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType));
        Business_Dossier__c dossier2 = new Business_Dossier__c(Name = 'test2', Dossier_Number__c = dossierNumber2, Establishment_Number__c = establishmentNUmber2, Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType));
        mocks.when(dutchBusinessServiceMock.createDutchDossier(dossierNumber1, establishmentNUmber1)).thenReturn(dossier1);
        mocks.when(dutchBusinessServiceMock.createDutchDossier(dossierNumber2, establishmentNUmber2)).thenReturn(dossier2);
        mocks.stopStubbing();

        Application.Service.setMock(IDutchBusinessService.class, dutchBusinessServiceMock);

        // when
        List<CreateDutchDossierInvocable.CreateDutchDossierArgument> arguments = new List<CreateDutchDossierInvocable.CreateDutchDossierArgument>();
        arguments.add(new CreateDutchDossierInvocable.CreateDutchDossierArgument(dossierNumber1, establishmentNUmber1));
        arguments.add(new CreateDutchDossierInvocable.CreateDutchDossierArgument(dossierNumber2, establishmentNUmber2));
        Test.startTest();
        List<Business_Dossier__c> dossiers = CreateDutchDossierInvocable.createDutchDossier(arguments);
        Test.stopTest();

        // then
        System.assert(dossiers.size() == 2);
    }
}