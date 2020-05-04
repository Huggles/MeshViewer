/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

@IsTest
private class DutchAddressWsdlTest {

    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {
            if (request instanceof DutchAddressWsdl.dutchAddressRangePostcodeSearchRequestType)
                response.put('response_x', new DutchAddressWsdl.dutchAddressRangePostcodeSearchResponseType());
            if (request instanceof DutchAddressWsdl.loginRequestType)
                response.put('response_x', new DutchAddressWsdl.loginResponseType());
            if (request instanceof DutchAddressWsdl.logoutRequestType)
                response.put('response_x', new DutchAddressWsdl.logoutResponseType());
        }
    }

    @IsTest
    private static void testCoverMethods1() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new DutchAddressWsdl.Webservices_nlPort().login(null,null);
        new DutchAddressWsdl.Webservices_nlPort().logout();
        new DutchAddressWsdl.Webservices_nlPort().dutchAddressRangePostcodeSearch(null);
    }

    @IsTest
    static void testCoverTypes() {
        new DutchAddressWsdl.DutchAddressPostcodeRange();
        new DutchAddressWsdl.HeaderLoginType();
        new DutchAddressWsdl.loginRequestType();
        new DutchAddressWsdl.dutchAddressRangePostcodeSearchRequestType();
        new DutchAddressWsdl.dutchAddressRangePostcodeSearchResponseType();
        new DutchAddressWsdl.logoutResponseType();
        new DutchAddressWsdl.HeaderAuthenticateType();
        new DutchAddressWsdl.loginResponseType();
        new DutchAddressWsdl.logoutRequestType();
    }


}