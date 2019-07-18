/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

@IsTest
private class CreditSafeServiceImplTest {

    @IsTest
    static void testSearchForCreditSafeDossiersNoCountries() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CreditSafeService.searchForCreditSafeDossiers(null, null, null, null, null, null, null, null, null, null, null);
            } catch (Exception ex) {
                System.assert(ex instanceof CCInputException);
                exceptionThrown = true;
            }

        }
        Test.stopTest();
        System.assert(exceptionThrown);
    }

    @IsTest
    static void testSearchForCreditSafeDossiersHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
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
            List<SearchForDossiersResultDto> searchForDossiersResultDtos = CreditSafeService.searchForCreditSafeDossiers(new List<CreditSafe.Country>{CreditSafe.Country.SE}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(searchForDossiersResultDtos.size() == 5);
            for (SearchForDossiersResultDto searchForDossiersResultDto : searchForDossiersResultDtos) {
                System.debug(searchForDossiersResultDto);
                System.assert(searchForDossiersResultDto.name.isNumeric());
                System.assert(searchForDossiersResultDto.dossier_number.startsWith('123'));
                System.assert(searchForDossiersResultDto.creditSafeCountry == CreditSafe.Country.NL.name());
                System.assert(searchForDossiersResultDto.establishment_street == 'Braillelaan');
                System.assert(searchForDossiersResultDto.establishment_city == 'Utrecht');
                System.assert(searchForDossiersResultDto.creditSafeId.isNumeric());
                System.assert(searchForDossiersResultDto.date_last_account != null && searchForDossiersResultDto.date_last_account < Datetime.now());
                System.assert(searchForDossiersResultDto.date_last_change != null && searchForDossiersResultDto.date_last_change < Datetime.now());
                System.assert(searchForDossiersResultDto.office_type == 'Headoffice');
                System.assert(searchForDossiersResultDto.trade_names != null && searchForDossiersResultDto.trade_names.size() == 3);
                System.assert(searchForDossiersResultDto.phone.isNumeric());
            }
        }
        Test.stopTest();
    }


}