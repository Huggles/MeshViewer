/**
 * Created by jaapbranderhorst on 03/03/2020.
 */

@IsTest
private class UpdateDutchDossierWithVATInvocableTest {
    @IsTest
    static void testHappyFlow() {
        // given
        // a dossier with a CoC number that returns a VAT number
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IDutchBusinessService dutchBusinessServiceMock = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);

        mocks.startStubbing();
        String dossierNumber = '1234';
        String VATNumber = '456';
        Business_Dossier__c dossier1 = new Business_Dossier__c(Name = 'test1', Dossier_Number__c = dossierNumber, Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType));
        Business_Dossier__c dossier2 = dossier1.clone();
        dossier2.VAT_Number__c = VATNumber;
        mocks.when(dutchBusinessServiceMock.updateBusinessDossierWithVATNumber(dossier1)).thenReturn(dossier2);
        mocks.stopStubbing();

        Application.Service.setMock(IDutchBusinessService.class, dutchBusinessServiceMock);

        // when
        // the imvocable UpdateDossierWithVATInvocable is called
        Test.startTest();
        List<Business_Dossier__c> dossiersToAssert = UpdateDutchDossierWithVATInvocable.updateDutchDossiersWithVAT(new List<Business_Dossier__c>{dossier1});
        Test.stopTest();

        //then
        System.assert(dossiersToAssert.size() == 1);
        System.assert(dossiersToAssert[0].VAT_Number__c == VATNumber);
    }

    @IsTest
    static void testNoVATNumber() {
        // given
        // a dossier with a CoC number that returns a VAT number
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IDutchBusinessService dutchBusinessServiceMock = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);

        mocks.startStubbing();
        String dossierNumber = '1234';
        String VATNumber = '456';
        Business_Dossier__c dossier1 = new Business_Dossier__c(Name = 'test1', Dossier_Number__c = dossierNumber, Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType));
        Business_Dossier__c dossier2 = dossier1.clone();
        mocks.when(dutchBusinessServiceMock.updateBusinessDossierWithVATNumber(dossier1)).thenReturn(dossier2);
        mocks.stopStubbing();

        Application.Service.setMock(IDutchBusinessService.class, dutchBusinessServiceMock);

        // when
        // the imvocable UpdateDossierWithVATInvocable is called
        Test.startTest();
        List<Business_Dossier__c> dossiersToAssert = UpdateDutchDossierWithVATInvocable.updateDutchDossiersWithVAT(new List<Business_Dossier__c>{dossier1});
        Test.stopTest();

        //then
        System.assert(dossiersToAssert.size() == 1);
        System.assert(dossiersToAssert[0].VAT_Number__c == null);
    }
}