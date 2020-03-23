/**
 * Created by tejaswinidandi on 10/03/2020.
 */

@IsTest
public class SearchForCreditSafeDossiersInvocableTest {

    @IsTest
    static void testGetDossiersHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 1; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'NL';
            company.name = '' + i;
            searchResultV2.companies.item.add(company);
        }

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeSearchV2(
                (CreditsafeWsdl.stringArray)fflib_Match.anyObject(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString()
                ,fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(searchResultV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);
        List<SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument> arguments = new List<SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument>();
        SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument argument = new SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument();
        argument.countries = new List<String>{'NL'};
        argument.id = 'id';
        argument.status = 'status';
        argument.registration_number = 'regnr';
        argument.registration_type = 'type';
        argument.vat_number = 'vat';
        argument.province = 'province';
        argument.city = 'city';
        argument.street = 'street';
        argument.postal_code = 'postal_code';
        argument.Name = 'name';
        arguments.add(argument);

        Test.startTest();
        {
            List<List<Business_Dossier__c>> dossiers= SearchForCreditSafeDossiersInvocable.searchForCreditSafeDossier(arguments);
            System.assert(dossiers.size() == 1);
            System.assert(dossiers.get(0).size() == 1);
        }
        Test.stopTest();
    }
}