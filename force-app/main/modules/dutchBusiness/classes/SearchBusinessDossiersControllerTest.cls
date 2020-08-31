/**
 * Created by vishalshete on 12/08/2020.
 */

@IsTest
public with sharing class SearchBusinessDossiersControllerTest {
    @IsTest
    private static void testSearchDutchDossierHappyFlow() {
        //instantiateDutchDossier
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        DutchBusinessWsdl.DutchBusinessReferencePagedResult dutchBusinessReferencePagedResult = DutchBusinessServiceImplTest.getMockDutchBusinessReferencePagedResult();
        mocks.startStubbing();

        mocks.when(webserviceMock.dutchBusinessSearchSelection((DutchBusinessWsdl.stringArray)fflib_Match.anyObject(),(DutchBusinessWsdl.stringArray)fflib_Match.anyObject(),(DutchBusinessWsdl.stringArray)fflib_Match.anyObject(),fflib_Match.anyBoolean(),(DutchBusinessWsdl.intArray)fflib_Match.anyObject(),fflib_Match.anyInteger(),fflib_Match.anyInteger(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyInteger(),(DutchBusinessWsdl.stringArray)fflib_Match.anyObject(),fflib_Match.anyString())).thenReturn(dutchBusinessReferencePagedResult);
        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        SearchBusinessDossiersController.SearchedBusinessDossierResults searchedBusinessDossierResults = new SearchBusinessDossiersController.SearchedBusinessDossierResults();
        System.runAs(TestUtils.getDutchBusinessUser()) {
        Test.startTest();
            searchedBusinessDossierResults = SearchBusinessDossiersController.searchDutchBusinessDossiers(new List<String>{'test'}, new List<String>{'test'}, new List<String>{'test'}, false, new List<Integer>{1}, 0, 0, 'true', 'test', 'test', 'test', 1, new List<String>{'test'}, 'test');
        Test.stopTest();
        }

        System.assert(searchedBusinessDossierResults.businessDossierWrappers != null);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
    }

}