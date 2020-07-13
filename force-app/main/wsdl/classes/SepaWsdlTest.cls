/**
 * Created by Hugo on 02/07/2020.
 */

@IsTest
public with sharing class SepaWsdlTest {

    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {
            if (request instanceof SepaWsdl.loginRequestType)
                response.put('response_x', new SepaWsdl.loginResponseType());
            if (request instanceof SepaWsdl.logoutRequestType)
                response.put('response_x', new SepaWsdl.logoutResponseType());
            if (request instanceof SepaWsdl.sepaConvertBasicBankAccountNumberRequestType)
                response.put('response_x', new SepaWsdl.sepaConvertBasicBankAccountNumberResponseType());
            if (request instanceof SepaWsdl.sepaMatchAccountHolderRequestType)
                response.put('response_x', new SepaWsdl.sepaMatchAccountHolderResponseType());
            if (request instanceof SepaWsdl.sepaIbanDetailsRequestType)
                response.put('response_x', new SepaWsdl.sepaIbanDetailsResponseType());
            if (request instanceof SepaWsdl.sepaConvertBankAccountNumberRequestType)
                response.put('response_x', new SepaWsdl.sepaConvertBankAccountNumberResponseType());
            if (request instanceof SepaWsdl.sepaValidateInternationalBankAccountNumberFormatRequestType)
                response.put('response_x', new SepaWsdl.sepaValidateInternationalBankAccountNumberFormatResponseType());
        }
    }

    @IsTest
    private static void testCoverMethods1() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new SepaWsdl.Webservices_nlPort().login(null,null);
        new SepaWsdl.Webservices_nlPort().logout();
        new SepaWsdl.Webservices_nlPort().sepaConvertBasicBankAccountNumber(null,null);
        new SepaWsdl.Webservices_nlPort().sepaMatchAccountHolder(null,null);
        new SepaWsdl.Webservices_nlPort().sepaIbanDetails(null);
        new SepaWsdl.Webservices_nlPort().sepaConvertBankAccountNumber(null,null,null);
        new SepaWsdl.Webservices_nlPort().sepaValidateInternationalBankAccountNumberFormat(null);
    }

    @IsTest
    static void testCoverTypes() {
        new SepaWsdl.sepaConvertBankAccountNumberRequestType();
        new SepaWsdl.sepaConvertBankAccountNumberResponseType();
        new SepaWsdl.SepaMatchBankAccountDetails();
        new SepaWsdl.SepaBankAccountIbanData();
        new SepaWsdl.SepaMatchNameMatchingResult();
        new SepaWsdl.sepaIbanDetailsResponseType();
        new SepaWsdl.sepaMatchAccountHolderResponseType();
        new SepaWsdl.SepaMatchBankAccountHolder();
        new SepaWsdl.SepaIbanDetails();
        new SepaWsdl.SepaInternationalBankAccountNumberFormatValidationReport();
        new SepaWsdl.sepaMatchAccountHolderRequestType();
        new SepaWsdl.sepaValidateInternationalBankAccountNumberFormatRequestType();
        new SepaWsdl.SepaMatchAccountHolderResult();
        new SepaWsdl.sepaValidateInternationalBankAccountNumberFormatResponseType();

        new SepaWsdl.HeaderLoginType();
        new SepaWsdl.HeaderAuthenticateType();
        new SepaWsdl.loginRequestType();
        new SepaWsdl.loginResponseType();
        new SepaWsdl.logoutRequestType();
        new SepaWsdl.logoutResponseType();

    }


}