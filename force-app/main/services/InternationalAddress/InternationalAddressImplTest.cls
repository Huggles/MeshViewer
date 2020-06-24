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

        InternationalAddressWsdl.InternationalV2 internationalV2_1 = createInternationalV2(1);
        InternationalAddressWsdl.InternationalV2 internationalV2_2 = createInternationalV2(2);

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

    @IsTest
    public static void testDuplicateAddressFlow() {

        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IWsInternationalAddress wsInternationalAddress = (IWsInternationalAddress)mocks.mock(IWsInternationalAddress.class);

        mocks.startStubbing();
        InternationalAddressWsdl.InternationalAddressSearchV2Result searchV2Result = new InternationalAddressWsdl.InternationalAddressSearchV2Result();

        InternationalAddressWsdl.InternationalV2 internationalV2_1 = createInternationalV2(1);
        InternationalAddressWsdl.InternationalV2 internationalV2_2 = createInternationalV2(1);

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

        //Make sure the mocked response is size = 2
        System.assertEquals(2, searchV2Result.result.item.size());


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
        // Mocked response size = 2, but filtered to only show 1
        System.assertEquals(1, internationalAddresses.size());
    }
    private static InternationalAddressWsdl.InternationalV2 createInternationalV2(Integer i){
        InternationalAddressWsdl.InternationalV2 internationalV2_2 = new InternationalAddressWsdl.InternationalV2();
        InternationalAddressWsdl.InternationalFormattedAddress address2 = createInternationalAddress(i);
        internationalV2_2.address = address2;
        internationalV2_2.element_match_status = '01230123';
        internationalV2_2.element_result_status = '01234567';
        return internationalV2_2;
    }
    private static InternationalAddressWsdl.InternationalFormattedAddress createInternationalAddress(Integer i){
        InternationalAddressWsdl.InternationalFormattedAddress address1 = new InternationalAddressWsdl.InternationalFormattedAddress();
        address1.matchrate = 100.0;
        address1.province = 'province' + String.valueOf(i);
        address1.department = 'department' + String.valueOf(i);
        address1.postcode = 'postcode1' + String.valueOf(i);
        address1.pobox = 'pobox' + String.valueOf(i);
        address1.street = 'street' + String.valueOf(i);
        address1.organization = 'org' + String.valueOf(i);
        address1.locality = 'locality' + String.valueOf(i);
        address1.housenr = 'housenr' + String.valueOf(i);
        address1.formatted_address = 'formatted_address' + String.valueOf(i);
        address1.delivery_address = 'delivery_address' + String.valueOf(i);
        address1.countryspecific_locality = 'countryspecific_locality' + String.valueOf(i);
        address1.contact = 'contact' + String.valueOf(i);
        address1.building = 'building' + String.valueOf(i);
        address1.country = 'country' + String.valueOf(i);
        return address1;
    }
}