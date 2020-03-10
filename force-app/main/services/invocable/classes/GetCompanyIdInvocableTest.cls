/**
 * Created by tejaswinidandi on 10/03/2020.
 */

@IsTest
public with sharing class GetCompanyIdInvocableTest {

    @IsTest
    static void testGetCompanyIdHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 1; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'NL';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.address = new CreditsafeWsdl.CreditsafeAddressV2();
            company.address.city = 'Utrecht';
            company.address.street = 'Braillelaan';
            company.address.telephone = '' + i;
            company.address.postal_code = '123' + i;
            company.status = 'status';
            company.trade_names = new CreditsafeWsdl.stringArray();
            company.trade_names.item = new List<String>();
            for (Integer i2 = 0; i2 < 3; i2++) {
                company.trade_names.item.add('' + i + '_' + i2);
            }
            company.id = '' + i;
            company.date_last_account = Datetime.now();
            company.date_last_change = Datetime.now();
            company.office_type = 'Headoffice';
            company.creditsafe_number = '' + i;
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
            List<String> companyId = GetCompanyIdInvocable.searchForCompanyId(arguments);
            System.assert(companyId.size() == 1);
            System.assert(companyId[0] == '0');
        }
        Test.stopTest();
    }
}