/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

@IsTest
private class VatWsdlTest {

    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {
            if (request instanceof VatWsdl.vatValidateRequestType)
                response.put('response_x', new VatWsdl.vatValidateResponseType());
            if (request instanceof VatWsdl.loginRequestType)
                response.put('response_x', new VatWsdl.loginResponseType());
            if (request instanceof VatWsdl.vatViesProxyCheckVatRequestType)
                response.put('response_x', new VatWsdl.vatViesProxyCheckVatResponseType());
            if (request instanceof VatWsdl.logoutRequestType)
                response.put('response_x', new VatWsdl.logoutResponseType());
        }
    }

    @IsTest
    private static void testCoverMethods1() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new VatWsdl.Webservices_nlPort().login(null,null);
        new VatWsdl.Webservices_nlPort().logout();
        new VatWsdl.Webservices_nlPort().vatViesProxyCheckVat(null);
        new VatWsdl.Webservices_nlPort().vatValidate(null);
    }

    @IsTest
    static void testCoverTypes() {
        new VatWsdl.vatValidateRequestType();
        new VatWsdl.vatViesProxyCheckVatResponseType();
        new VatWsdl.HeaderLoginType();
        new VatWsdl.loginRequestType();
        new VatWsdl.logoutResponseType();
        new VatWsdl.vatViesProxyCheckVatRequestType();
        new VatWsdl.vatValidateResponseType();
        new VatWsdl.VatProxyViesCheckVatResponse();
        new VatWsdl.loginResponseType();
        new VatWsdl.logoutRequestType();
        new VatWsdl.VatValidation();
        new VatWsdl.HeaderAuthenticateType();

    }


}