@isTest
public with sharing class CompanyDetailsControllerTest {

    @IsTest
    public static void testUpdateDossierWithVATHappyFlow() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IDutchBusinessService dutchBusinessService = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);

        mocks.startStubbing();
        // a dossier in the DB without a VAT number
        Business_Dossier__c dossier = new Business_Dossier__c(Name = 'test', Id = fflib_IDGenerator.generate(Business_Dossier__c.sObjectType));
        mocks.when(dutchBusinessService.getDossiersById((Set<Id>)fflib_Match.anyObject())).thenReturn(new List<Business_Dossier__c>{dossier});
        Business_Dossier__c dossierWithVAT = dossier.clone(true);
        dossierWithVAT.VAT_Number__c = '1234';
        // a nice method that returns an updated dossier with the vat number
        mocks.when(dutchBusinessService.updateBusinessDossierWithVATNumber((Business_Dossier__c)fflib_Match.anySObject())).thenReturn(dossierWithVAT);
        // we don't need to do anything for storeDossiers since it is already mocked
        mocks.stopStubbing();

        Application.Service.setMock(IDutchBusinessService.class, dutchBusinessService);

        // when
        Test.startTest();
        Object o = CompanyDetailsController.updateDossierWithVAT(dossier.Id);
        Test.stopTest();

        // then
        System.assert(o instanceof AuraResponseWrapper);
        System.assert(((AuraResponseWrapper)o).response instanceof Business_Dossier__c);
    }








}
    
