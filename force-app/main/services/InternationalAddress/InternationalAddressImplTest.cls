/**
 * Created by jaapbranderhorst on 14/03/2020.
 */

@IsTest
private class InternationalAddressImplTest {
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
        address1.street = 'street1';
        address1.organization = 'org1';
        address1.locality = 'locality1';
        address1.housenr = 'housenr1';
        address1.formatted_address = 'formatted_address1';
        address1.delivery_address = 'delivery_address1';
        address1.countryspecific_locality = 'countryspecific_locality1';
        address1.contact = 'contact1';
        address1.building = 'building1';
        address1.country = 'country1';
        internationalV2_1.address = address1;
        internationalV2_1.element_match_status = '01230123';
        internationalV2_1.element_result_status = '01234567';
        InternationalAddressWsdl.InternationalV2 internationalV2_2 = new InternationalAddressWsdl.InternationalV2();
        InternationalAddressWsdl.InternationalFormattedAddress address2 = new InternationalAddressWsdl.InternationalFormattedAddress();
        address2.matchrate = 90.0;
        address2.province = 'province2';
        address2.department = 'department2';
        address2.postcode = 'postcode2';
        address2.pobox = 'pobox2';
        address2.street = 'street2';
        address2.organization = 'org2';
        address2.locality = 'locality2';
        address2.housenr = 'housenr2';
        address2.formatted_address = 'formatted_address2';
        address2.delivery_address = 'delivery_address2';
        address2.countryspecific_locality = 'countryspecific_locality2';
        address2.contact = 'contact2';
        address2.building = 'building2';
        address2.country = 'country2';
        internationalV2_2.address = address2;
        internationalV2_2.element_match_status = '01230123';
        internationalV2_2.element_result_status = '01234567';
        searchV2Result.result = new InternationalAddressWsdl.InternationalV2Array();
        searchV2Result.result.item = new List<InternationalAddressWsdl.InternationalV2>{internationalV2_1, internationalV2_2};
        mocks.when(wsInternationalAddress.internationalAddressSearchV2('org2',
                'building',
                'street',
                'housenr',
                'pobox',
                'locality',
                'postal_code',
                'province',
                'NLD',
                'database',
                'en')).thenReturn(searchV2Result);
        mocks.stopStubbing();

        Application.Service.setMock(IWsInternationalAddress.class, wsInternationalAddress);

        // when
        Test.startTest();
        List<International_Address__c> internationalAddresses = InternationalAddressService.internationalAddressSearchV2('org2',
                'building',
                'street',
                'housenr',
                'pobox',
                'locality',
                'postal_code',
                'province',
                'NLD',
                null,
                null);
        Test.stopTest();

        // then
        System.assertEquals(2, internationalAddresses.size());
        for (Integer i = internationalAddresses.size(); i == 1; i--) {
            International_Address__c addressToTest = internationalAddresses.get(i-1);
            System.assertEquals('province' + i, addressToTest.Province__c);
            System.assertEquals('street' + i, addressToTest.Street__c);
            System.assertEquals('housenr' + i, addressToTest.House_Number__c);
            System.assertEquals('pobox' + i, addressToTest.POBox__c);
            System.assertEquals('postcode' + i, addressToTest.Postcode__c);
            System.assertEquals('locality' + i, addressToTest.Locality__c);
            System.assertEquals('country' + i, addressToTest.Country__c);
            System.assertEquals('countryspecific_locality' + i, addressToTest.Country_Specific_Locality__c);
            System.assertEquals('org' + i, addressToTest.Organization__c);
            System.assertEquals('department' + i, addressToTest.Department__c);
            System.assertEquals('formatted_address' + i, addressToTest.Formatted_Address__c);
            System.assertEquals('delivery_address' + i, addressToTest.Delivery_Address__c);
            System.assertEquals('building' + i, addressToTest.Building__c);
            System.assertEquals('contact' + i, addressToTest.Contact__c);
            System.assertEquals(100.0, addressToTest.Matchrate__c);
            System.debug(i);
        }


    }

    @IsTest
    public static void testDeleteInternationalAddressHappyFlow() {
        International_Address__c internationalAddress = new International_Address__c(Country__c = 'test');
        insert internationalAddress;

        Test.startTest();
        InternationalAddressService.deleteInternationalAddress(internationalAddress.Id, false);
        Test.stopTest();

        System.assert([SELECT Id FROM International_Address__c].size() == 0);

    }

    @IsTest
    public static void testDeleteInternationalAddressErrorFlow() {
        Exception ex;
        Test.startTest();
        try {
            InternationalAddressService.deleteInternationalAddress(null, false);
        }catch (Exception e) {
            ex = e;
        }
        Test.stopTest();

        System.assert([SELECT Id FROM International_Address__c].size() == 0);
        System.assert(ex != null);
        System.assert(ex.getMessage() == 'Incorrect input. Please correct your input and try again.');

    }
}