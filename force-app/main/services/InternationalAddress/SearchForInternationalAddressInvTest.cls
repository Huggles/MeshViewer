/**
 * Created by jaapbranderhorst on 14/03/2020.
 */

@IsTest
private class SearchForInternationalAddressInvTest {
    @IsTest
    static void testHappyFlow() {
        // given a webservice returning two InternationalV2 objects
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IWsInternationalAddress wsInternationalAddress = (IWsInternationalAddress)mocks.mock(IWsInternationalAddress.class);

        mocks.startStubbing();
        InternationalAddressWsdl.InternationalAddressSearchV2Result searchV2Result = new InternationalAddressWsdl.InternationalAddressSearchV2Result();
        InternationalAddressWsdl.InternationalV2 internationalV2_1 = new InternationalAddressWsdl.InternationalV2();
        InternationalAddressWsdl.InternationalFormattedAddress address1 = new InternationalAddressWsdl.InternationalFormattedAddress();
        address1.matchrate = 100.0;
        address1.province = 'province1';
        address1.department = 'department1';
        address1.postcode = 'postcode1';
        address1.pobox = 'pobox1';
        address1.organization = 'org1';
        address1.locality = 'locality1';
        address1.housenr = 'housenr1';
        address1.formatted_address = 'formatted_address1';
        address1.delivery_address = 'delivery_address1';
        address1.countryspecific_locality = 'countryspecific_locality1';
        address1.contact = 'contact1';
        address1.building = 'building1';
        internationalV2_1.address = address1;
        internationalV2_1.element_match_status = '01230123';
        internationalV2_1.element_result_status = '01234567';
        InternationalAddressWsdl.InternationalV2 internationalV2_2 = new InternationalAddressWsdl.InternationalV2();
        InternationalAddressWsdl.InternationalFormattedAddress address2 = new InternationalAddressWsdl.InternationalFormattedAddress();
        address2.matchrate = 100.0;
        address2.province = 'province2';
        address2.department = 'department2';
        address2.postcode = 'postcode2';
        address2.pobox = 'pobox2';
        address2.organization = 'org2';
        address2.locality = 'locality2';
        address2.housenr = 'housenr2';
        address2.formatted_address = 'formatted_address2';
        address2.delivery_address = 'delivery_address2';
        address2.countryspecific_locality = 'countryspecific_locality2';
        address2.contact = 'contact2';
        address2.building = 'building2';
        internationalV2_2.address = address2;
        internationalV2_2.element_match_status = '01230123';
        internationalV2_2.element_result_status = '01234567';
        searchV2Result.result = new InternationalAddressWsdl.InternationalV2Array();
        searchV2Result.result.item = new List<InternationalAddressWsdl.InternationalV2>{internationalV2_1, internationalV2_2};
        mocks.when(wsInternationalAddress.internationalAddressSearchV2('organization',
                'building',
                'street',
                'housenr',
                'pobox',
                'locality',
                'postal_code',
                'province',
                'country',
                'language',
                'countryFormat')).thenReturn(searchV2Result);
        mocks.stopStubbing();

        Application.Service.setMock(IWsInternationalAddress.class, wsInternationalAddress);

        //when
        Test.startTest();
        List<SearchForInternationalAddressInvocable.SearchInternationalAddressArgument> arguments = new List<SearchForInternationalAddressInvocable.SearchInternationalAddressArgument>();
        arguments.add(new SearchForInternationalAddressInvocable.SearchInternationalAddressArgument('organization',
                'building',
                'pobox',
                'province',
                'street',
                'postal_code',
                'housenr',
                'locality',
                'country',
                'language',
                'countryFormat'));
        List<List<International_Address__c>> addresses = SearchForInternationalAddressInvocable.searchInternationalAddress(arguments);
        Test.stopTest();

        //then
        System.assert(addresses.size() == 1);
        List<International_Address__c> addressesToAssert = addresses.get(0);
        System.assert(addressesToAssert.size() == 2);
        International_Address__c addressToAssert = addressesToAssert.get(0);
    }
}