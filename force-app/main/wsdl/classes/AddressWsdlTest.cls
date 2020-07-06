/**
 * Created by tejaswinidandi on 16/06/2020.
 */

@IsTest
private class AddressWsdlTest {

    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {
            if (request instanceof AddressWsdl.addressDistrictListNeighborhoodsRequestType)
                response.put('response_x', new AddressWsdl.addressDistrictListNeighborhoodsResponseType());
            if (request instanceof AddressWsdl.addressPerceelParameterSearchRequestType)
                response.put('response_x', new AddressWsdl.addressPerceelParameterSearchResponseType());
            if (request instanceof AddressWsdl.loginRequestType)
                response.put('response_x', new AddressWsdl.loginResponseType());
            if (request instanceof AddressWsdl.addressReeksParameterSearchRequestType)
                response.put('response_x', new AddressWsdl.addressReeksParameterSearchResponseType());
            if (request instanceof AddressWsdl.addressCityListNeighborhoodsRequestType)
                response.put('response_x', new AddressWsdl.addressCityListNeighborhoodsResponseType());
            if (request instanceof AddressWsdl.addressNeighborhoodNameRequestType)
                response.put('response_x', new AddressWsdl.addressNeighborhoodNameResponseType());
            if (request instanceof AddressWsdl.addressPerceelPhraseSearchRequestType)
                response.put('response_x', new AddressWsdl.addressPerceelPhraseSearchResponseType());
            if (request instanceof AddressWsdl.addressReeksAddressSearchRequestType)
                response.put('response_x', new AddressWsdl.addressReeksAddressSearchResponseType());
            if (request instanceof AddressWsdl.addressProvinceListNeighborhoodsRequestType)
                response.put('response_x', new AddressWsdl.addressProvinceListNeighborhoodsResponseType());
            if (request instanceof AddressWsdl.addressPerceelFullParameterSearchV2RequestType)
                response.put('response_x', new AddressWsdl.addressPerceelFullParameterSearchV2ResponseType());
            if (request instanceof AddressWsdl.addressDistrictSearchRequestType)
                response.put('response_x', new AddressWsdl.addressDistrictSearchResponseType());
            if (request instanceof AddressWsdl.addressDistrictListCitiesRequestType)
                response.put('response_x', new AddressWsdl.addressDistrictListCitiesResponseType());
            if (request instanceof AddressWsdl.addressCitySearchV2RequestType)
                response.put('response_x', new AddressWsdl.addressCitySearchV2ResponseType());
            if (request instanceof AddressWsdl.addressProvinceSearchRequestType)
                response.put('response_x', new AddressWsdl.addressProvinceSearchResponseType());
            if (request instanceof AddressWsdl.addressReeksPhraseSearchRequestType)
                response.put('response_x', new AddressWsdl.addressReeksPhraseSearchResponseType());
            if (request instanceof AddressWsdl.addressReeksFullParameterSearchRequestType)
                response.put('response_x', new AddressWsdl.addressReeksFullParameterSearchResponseType());
            if (request instanceof AddressWsdl.addressPerceelFullParameterSearchRequestType)
                response.put('response_x', new AddressWsdl.addressPerceelFullParameterSearchResponseType());
            if (request instanceof AddressWsdl.addressProvinceListDistrictsRequestType)
                response.put('response_x', new AddressWsdl.addressProvinceListDistrictsResponseType());
            if (request instanceof AddressWsdl.addressProvinceListRequestType)
                response.put('response_x', new AddressWsdl.addressProvinceListResponseType());
            if (request instanceof AddressWsdl.logoutRequestType)
                response.put('response_x', new AddressWsdl.logoutResponseType());
            if (request instanceof AddressWsdl.addressNeighborhoodPhraseSearchRequestType)
                response.put('response_x', new AddressWsdl.addressNeighborhoodPhraseSearchResponseType());
            if (request instanceof AddressWsdl.addressReeksPostcodeSearchRequestType)
                response.put('response_x', new AddressWsdl.addressReeksPostcodeSearchResponseType());
        }
    }

    @IsTest
    private static void testCoverMethods() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new AddressWsdl.Webservices_nlPort().login(null,null);
        new AddressWsdl.Webservices_nlPort().logout();
        new AddressWsdl.Webservices_nlPort().addressDistrictListNeighborhoods(null, null, null);
        new AddressWsdl.Webservices_nlPort().addressPerceelParameterSearch(null, null, null,null, null, null,null);
        new AddressWsdl.Webservices_nlPort().addressReeksParameterSearch(null, null, null,null, null, null,null);
        new AddressWsdl.Webservices_nlPort().addressCityListNeighborhoods(null, null, null);
        new AddressWsdl.Webservices_nlPort().addressNeighborhoodName(null);
        new AddressWsdl.Webservices_nlPort().addressPerceelPhraseSearch(null, null);
        new AddressWsdl.Webservices_nlPort().addressReeksAddressSearch(null, null, null, null);
        new AddressWsdl.Webservices_nlPort().addressProvinceListNeighborhoods(null, null, null);
        new AddressWsdl.Webservices_nlPort().addressPerceelFullParameterSearchV2(null, null, null, null, null, null, null, null, null, null);
        new AddressWsdl.Webservices_nlPort().addressDistrictSearch(null, null);
        new AddressWsdl.Webservices_nlPort().addressDistrictListCities(null, null);
        new AddressWsdl.Webservices_nlPort().addressCitySearchV2(null, null);
        new AddressWsdl.Webservices_nlPort().addressProvinceSearch(null, null);
        new AddressWsdl.Webservices_nlPort().addressReeksPhraseSearch(null, null);
        new AddressWsdl.Webservices_nlPort().addressReeksFullParameterSearch(null, null, null, null, null, null, null, null, null, null);
        new AddressWsdl.Webservices_nlPort().addressPerceelFullParameterSearch(null, null, null, null, null, null, null, null, null, null);
        new AddressWsdl.Webservices_nlPort().addressProvinceListDistricts(null, null);
        new AddressWsdl.Webservices_nlPort().addressProvinceList(null);
        new AddressWsdl.Webservices_nlPort().addressNeighborhoodPhraseSearch(null, null);
        new AddressWsdl.Webservices_nlPort().addressReeksPostcodeSearch(null);
    }

    @IsTest
    static void testCoverTypes() {
        new AddressWsdl.addressProvinceSearchRequestType();
        new AddressWsdl.PCReeksSearchPartsPagedResult();
        new AddressWsdl.DistrictPagedResult();
        new AddressWsdl.addressProvinceListResponseType();
        new AddressWsdl.DistrictArray();
        new AddressWsdl.addressPerceelParameterSearchResponseType();
        new AddressWsdl.NeighborhoodPagedResult();
        new AddressWsdl.SearchParts();
        new AddressWsdl.logoutResponseType();
        new AddressWsdl.addressPerceelFullParameterSearchResponseType();
        new AddressWsdl.addressDistrictListNeighborhoodsResponseType();
        new AddressWsdl.addressDistrictListCitiesResponseType();
        new AddressWsdl.addressNeighborhoodNameResponseType();
        new AddressWsdl.addressPerceelParameterSearchRequestType();
        new AddressWsdl.NeighborhoodArray();
        new AddressWsdl.CityPagedResult();
        new AddressWsdl.addressPerceelFullParameterSearchV2ResponseType();
        new AddressWsdl.addressCitySearchV2ResponseType();
        new AddressWsdl.addressCityListNeighborhoodsRequestType();
        new AddressWsdl.City();
        new AddressWsdl.addressReeksAddressSearchRequestType();
        new AddressWsdl.loginResponseType();
        new AddressWsdl.addressPerceelPhraseSearchResponseType();
        new AddressWsdl.PCReeksArray();
        new AddressWsdl.Province();
        new AddressWsdl.Neighborhood();
        new AddressWsdl.ProvincePagedResult();
        new AddressWsdl.HeaderLoginType();
        new AddressWsdl.addressProvinceSearchResponseType();
        new AddressWsdl.RangeAddressPagedResult();
        new AddressWsdl.loginRequestType();
        new AddressWsdl.addressReeksAddressSearchResponseType();
        new AddressWsdl.addressPerceelFullParameterSearchV2RequestType();
        new AddressWsdl.CityV2();
        new AddressWsdl.addressProvinceListDistrictsRequestType();
        new AddressWsdl.NeighborhoodNameArray();
        new AddressWsdl.ResultInfo();
        new AddressWsdl.HeaderAuthenticateType();
        new AddressWsdl.PCReeks();
        new AddressWsdl.District();
        new AddressWsdl.addressProvinceListRequestType();
        new AddressWsdl.addressReeksFullParameterSearchRequestType();
        new AddressWsdl.NeighborhoodName();
        new AddressWsdl.addressCityListNeighborhoodsResponseType();
        new AddressWsdl.Perceel();
        new AddressWsdl.addressReeksPostcodeSearchResponseType();
        new AddressWsdl.CityV2PagedResult();
        new AddressWsdl.addressNeighborhoodPhraseSearchResponseType();
        new AddressWsdl.addressNeighborhoodPhraseSearchRequestType();
        new AddressWsdl.RangeAddressArray();
        new AddressWsdl.addressReeksPhraseSearchResponseType();
        new AddressWsdl.addressDistrictSearchResponseType();
        new AddressWsdl.logoutRequestType();
        new AddressWsdl.addressProvinceListDistrictsResponseType();
        new AddressWsdl.addressReeksFullParameterSearchResponseType();
        new AddressWsdl.PerceelSearchPartsPagedResult();
        new AddressWsdl.CityArray();
        new AddressWsdl.addressProvinceListNeighborhoodsResponseType();
        new AddressWsdl.PerceelArray();
        new AddressWsdl.RangeAddress();
        new AddressWsdl.NeighborhoodNamePagedResult();
        new AddressWsdl.addressDistrictListNeighborhoodsRequestType();
        new AddressWsdl.addressCitySearchV2RequestType();
        new AddressWsdl.addressReeksPostcodeSearchRequestType();
        new AddressWsdl.CityV2Array();
        new AddressWsdl.addressProvinceListNeighborhoodsRequestType();
        new AddressWsdl.addressNeighborhoodNameRequestType();
        new AddressWsdl.addressPerceelPhraseSearchRequestType();
        new AddressWsdl.addressReeksPhraseSearchRequestType();
        new AddressWsdl.addressReeksParameterSearchResponseType();
        new AddressWsdl.addressDistrictSearchRequestType();
        new AddressWsdl.ProvinceArray();
        new AddressWsdl.addressReeksParameterSearchRequestType();
        new AddressWsdl.addressDistrictListCitiesRequestType();
    }

}