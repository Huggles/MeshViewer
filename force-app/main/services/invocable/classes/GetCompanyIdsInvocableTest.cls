/**
 * Created by tejaswinidandi on 12/03/2020.
 */

@IsTest
public with sharing class GetCompanyIdsInvocableTest {

    @IsTest
    static void testGetCompanyIdsHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'NL';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.id = '' + i;
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

        Test.startTest();
        {
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

            List<String> companyIds= GetCompanyIdsInvocable.getForCompanyId(arguments);
            System.assert(companyIds.size() == 2);
            System.assert(companyIds.get(0) == '0');
        }
        Test.stopTest();
    }
}