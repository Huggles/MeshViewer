/**
 * Created by tejaswinidandi on 12/06/2020.
 */

@IsTest
private class AddressServiceImplTest {

    @IsTest
    static void dutchAddressSearchTest() {

        // given a webservice returning two Address objects
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IWsAddress wsAddress = (IWsAddress)mocks.mock(IWsAddress.class);

        mocks.startStubbing();
        AddressWsdl.ResultInfo resultInfo = new AddressWsdl.ResultInfo();
        AddressWsdl.PerceelArray perceelArray = new AddressWsdl.PerceelArray();
        perceelArray.item = new List<AddressWsdl.Perceel>();
        AddressWsdl.PerceelSearchPartsPagedResult returnedResults = new AddressWsdl.PerceelSearchPartsPagedResult();
        resultInfo.curpage = 1;
        resultInfo.maxresults = 500;
        resultInfo.numpages = 1;
        resultInfo.numresults = 2;
        resultInfo.perpage = 10;

        for (Integer i = 0; i < 2; i++) {
            AddressWsdl.Perceel perceelAddress = new AddressWsdl.Perceel();
            perceelAddress.provinciecode = '' + i;
            perceelAddress.cebucocode = i;
            perceelAddress.plaatsnaam_extract = 'plaatsnaam_extract' + i;
            perceelAddress.plaatsnaam = 'plaatsnaam' + i;
            perceelAddress.plaatsnaam_ptt = 'plaatsnaam_ptt' + i;
            perceelAddress.plaatsid = i;
            perceelAddress.straatnaam_extract = 'straatnaam_extract' + i;
            perceelAddress.straatnaam = 'straatnaam' + i;
            perceelAddress.straatnaam_ptt = 'straatnaam_ptt' + i;
            perceelAddress.straatnaam_nen = 'straatnaam_nen' + i;
            perceelAddress.straatid = i;
            perceelAddress.reeksindicatie = 'reeksindicatie' + i;
            perceelAddress.wijkcode = 'wijkcode' + i;
            perceelAddress.reeksid = i;
            perceelAddress.perceelnummer = i;
            perceelAddress.huisnr_toevoeging = 'a' + i;
            perceelAddress.provincienaam = 'provincienaam' + i;
            perceelAddress.gemeenteid = i;
            perceelAddress.gemeentecode = i;
            perceelAddress.gemeentenaam = 'gemeentenaam' + i;
            perceelAddress.lettercombinatie = 'lettercombinatie' + i;
            perceelAddress.huisnr_tm = i;
            perceelAddress.huisnr_van = i * 10;
            perceelAddress.perceelid = i;
            perceelArray.item.add(perceelAddress);
        }
        returnedResults.paging = resultInfo;
        returnedResults.results = perceelArray;
        mocks.when(wsAddress.addressPerceelFullParameterSearchV2( 'province', 'district', 'city', 'street', 1,
                'houseNoAddition', 'nbcode', 'lettercombination', 'addresstype', 1)).thenReturn(returnedResults);
        mocks.stopStubbing();

        Application.Service.setMock(IWsAddress.class, wsAddress);

        // when
        Test.startTest();
        List<International_Address__c> internationalAddresses = AddressService.dutchAddressSearch('org', 'province', 'district', 'city', 'street', 1, 'houseNoAddition', 'nbcode', 'lettercombination', 'addresstype');
        Test.stopTest();

        // then
        System.assertEquals(2, internationalAddresses.size());
        for (Integer i = internationalAddresses.size(); i == 1; i--) {
            International_Address__c addressToTest = internationalAddresses.get(i-1);
            System.assertEquals( '' + i, addressToTest.Province_Code__c);
            System.assertEquals( i, addressToTest.CeBuco_Code__c);
            System.assertEquals('plaatsnaam_extract' + i, addressToTest.City_Extract__c);
            System.assertEquals('plaatsnaam' + i, addressToTest.Locality__c);
            System.assertEquals('plaatsnaam_ptt' + i, addressToTest.City_Ptt__c);
            System.assertEquals( i, addressToTest.City_Id__c);
            System.assertEquals('straatnaam_extract' + i, addressToTest.Street_Name_Extract__c);
            System.assertEquals('straatnaam' + i, addressToTest.Street__c);
            System.assertEquals('straatnaam_ptt' + i, addressToTest.Street_Name_Ptt__c);
            System.assertEquals('straatnaam_nen' + i, addressToTest.Street_Name_Nen__c);
            System.assertEquals( i, addressToTest.Street_Id__c);
            System.assertEquals('reeksindicatie' + i, addressToTest.Reeks_Indication__c);
            System.assertEquals( i, addressToTest.Reeks_Id__c);
            System.assertEquals('wijkcode' + i, addressToTest.Postcode__c);
            System.assertEquals( i, addressToTest.Perceel_Number__c);
            System.assertEquals( 'a' + i, addressToTest.House_Number_Addition__c);
            System.assertEquals( 'provincienaam' + i, addressToTest.Province__c);
            System.assertEquals( i, addressToTest.House_Number_From__c);
            System.assertEquals( i * 10, addressToTest.House_Number_To__c);
            System.assertEquals( i , addressToTest.Perceel_Id__c);
            System.assertEquals( i, addressToTest.Municipality_Id__c);
            System.assertEquals( i, addressToTest.Municipality_Code__c);
            System.assertEquals( 'gemeentenaam' + i, addressToTest.Municipality__c);
            System.assertEquals( 'lettercombinatie' + i, addressToTest.Letter_Combination__c);
        }

    }
}