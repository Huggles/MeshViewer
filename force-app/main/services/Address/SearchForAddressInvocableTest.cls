/**
 * Created by tejaswinidandi on 24/06/2020.
 */

@IsTest
private class SearchForAddressInvocableTest {

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

        //when
        Test.startTest();
        List<SearchForAddressInvocable.SearchAddressArgument> arguments = new List<SearchForAddressInvocable.SearchAddressArgument>();
        arguments.add(new SearchForAddressInvocable.SearchAddressArgument('organization',
                'province',
                'street',
                'nbcode',
                '1',
                'city',
                'district',
                'houseNoAddition',
                'lettercombination',
                'addresstype'));
        List<List<International_Address__c>> addresses = SearchForAddressInvocable.searchAddress(arguments);
        Test.stopTest();

        // then
        System.assert(addresses.size() == 1);
        List<International_Address__c> addressesToAssert = addresses.get(0);
        System.assert(addressesToAssert.size() == 2);

    }
}