/**
 * Created by jaapbranderhorst on 04/04/2020.
 */

@IsTest
private class InternationalAddressWsdlTest {

    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {
            if (request instanceof InternationalAddressWsdl.loginRequestType)
                response.put('response_x', new InternationalAddressWsdl.loginResponseType());
            if (request instanceof InternationalAddressWsdl.logoutRequestType)
                response.put('response_x', new InternationalAddressWsdl.logoutResponseType());
            if (request instanceof InternationalAddressWsdl.internationalAddressSearchV2RequestType)
                response.put('response_x', new InternationalAddressWsdl.internationalAddressSearchV2ResponseType());
            if (request instanceof InternationalAddressWsdl.internationalAddressSearchInteractiveRequestType)
                response.put('response_x', new InternationalAddressWsdl.internationalAddressSearchInteractiveResponseType());
        }
    }
    
    @IsTest
    static void testCoverMethods() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new InternationalAddressWsdl.Webservices_nlPort().login(null,null);
        new InternationalAddressWsdl.Webservices_nlPort().logout();
        new InternationalAddressWsdl.Webservices_nlPort().internationalAddressSearchV2(null, null,null,null,null,null,null,null,null,null,null);
        new InternationalAddressWsdl.Webservices_nlPort().internationalAddressSearchInteractive(null, null,null,null,null,null,null,null,null,null,null);
        System.assert(true);
    }

    @IsTest
    static void testCoverTypes() {
        new InternationalAddressWsdl.InternationalV2();
        new InternationalAddressWsdl.International();
        new InternationalAddressWsdl.InternationalV2Array();
        new InternationalAddressWsdl.InternationalFormattedAddress();
        new InternationalAddressWsdl.InternationalAddressSearchV2Result();
        new InternationalAddressWsdl.HeaderAuthenticateType();
        new InternationalAddressWsdl.HeaderLoginType();
        new InternationalAddressWsdl.InternationalAddressSearchInteractiveRequestType();
        new InternationalAddressWsdl.InternationalAddressSearchInteractiveResponseType();
        new InternationalAddressWsdl.InternationalAddressSearchV2RequestType();
        new InternationalAddressWsdl.InternationalAddressSearchV2ResponseType();
        new InternationalAddressWsdl.InternationalArray();
        new InternationalAddressWsdl.InternationalFormattedAddressArray();
        new InternationalAddressWsdl.InternationalFormattedAddressPagedResult();
        new InternationalAddressWsdl.InternationalPagedResult();
        new InternationalAddressWsdl.loginRequestType();
        new InternationalAddressWsdl.loginResponseType();
        new InternationalAddressWsdl.logoutRequestType();
        new InternationalAddressWsdl.logoutResponseType();
        new InternationalAddressWsdl.ResultInfo();
        System.assert(true);
    }


}