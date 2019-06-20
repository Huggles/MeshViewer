/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

@IsTest
private class BusinessDuplicateServiceImplTest {
    @IsTest
    public static void testCheckDossierDossierDoesNotExist() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessDossierSelector mockDossierSelector = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);

        mocks.startStubbing();
        mocks.when(mockDossierSelector.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(mockDossierSelector.selectByDossierNumbers(new Set<DossierQueryDTO>{new DossierQueryDTO('1234', '1234')}, false)).thenReturn(new List<Business_Dossier__c>());
        mocks.stopStubbing();
        Application.Selector.setMock(mockDossierSelector);

        Boolean result = true;
        Test.startTest();
        result = BusinessDuplicateService.checkDossier('1234', '1234');
        Test.stopTest();
        System.assert(!result);
    }

    @IsTest
    public static void testCheckDossierDossierDoesExist() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessDossierSelector mockDossierSelector = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);

        mocks.startStubbing();
        mocks.when(mockDossierSelector.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        Business_Dossier__c dossier = new Business_Dossier__c(Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType));
        mocks.when(mockDossierSelector.selectByDossierNumbers(new Set<DossierQueryDTO>{new DossierQueryDTO('1234', '1234')}, false)).thenReturn(new List<Business_Dossier__c>{dossier});
        mocks.stopStubbing();
        Application.Selector.setMock(mockDossierSelector);

        Boolean result = false;
        Test.startTest();
        result = BusinessDuplicateService.checkDossier('1234', '1234');
        Test.stopTest();
        System.assert(result);
    }

}