/**
 * Created by jaapbranderhorst on 2019-07-02.
 */

@IsTest
private class CallOutHelperTest {

    @IsTest
    static void testHandleCallOutExceptionClientInvalidAuthorization() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: Invalid authentication (You are not logged in) faultcode=SOAP-ENV:Client faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientAuthenticationException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
    }

    @IsTest
    static void testHandleCallOutExceptionClientAuthentication() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Authentication faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientAuthenticationException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
    }

    @IsTest
    static void testHandleCallOutExceptionClientAuthenticationHostPassword() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Authentication.Password faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientAuthPasswordException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
    }

    @IsTest
    static void testHandleCallOutExceptionClientAuthenticationHostUserName() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Authentication.Username faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientAuthUserNameException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
    }

    @IsTest
    static void testHandleCallOutExceptionClientAuthorization() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Authorization faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientAuthorizationException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionClientInput() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Input faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientInputException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionClientInputInvalid() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Input.Invalid faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientInputInvalidException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionClientInputPayment() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Input.Payment faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientPaymentException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
    }

    @IsTest
    static void testHandleCallOutExceptionClientInputFormatIncorrect() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Input.FormatIncorrect faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientInputFormatIncorrectException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionClientInputIncomplete() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Input.Incomplete faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientInputIncompleteException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionClientAuthenticationHostRestriction() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xxx faultcode=SOAP-ENV:Client.Authentication.HostRestriction faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientAuthHostRestrictionException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionClient() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Client faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsClientException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionServer() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsServerException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionServerVatNotFound() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: Vat number for business not found faultcode=SOAP-ENV:Server faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsServerDataNotFoundVatException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
    }

    @IsTest
    static void testHandleCallOutExceptionServerData() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server.Data faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsServerDataException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionServerDataNotFound() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server.Data.NotFound faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsServerDataNotFoundException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
    }

    @IsTest
    static void testHandleCallOutExceptionServerDataNotFoundNbwo() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server.Data.NotFound.Nbwo.EstimateUnavailable faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsServerDataNotFoundNbwoException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
    }

    @IsTest
    static void testHandleCallOutExceptionServerDataNotFoundKadaster() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server.Data.NotFound.Kadaster.NotDeliverable faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsServerDataNotFoundKadasterException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
    }

    @IsTest
    static void testHandleCallOutExceptionServerDataPageNotFound() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server.Data.PageNotFound faultactor=)'));
            } catch(Exception ex) {
                System.assert(ex instanceof CCWsServerDataPageNotFoundException);
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionThrown);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
    }

    @IsTest
    static void testHandleCallOutExceptionServerUnavailable() {
        Test.startTest();
        {

            System.assert(CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server.Unavailable faultactor=)')));

        }
        Test.stopTest();
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionServerUnavailableInternalError() {
        Test.startTest();
        {

            System.assert(CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server.Unavailable.InternalError faultactor=)')));

        }
        Test.stopTest();
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    static void testHandleCallOutExceptionServerUnavailableTemporary() {
        Test.startTest();
        {

            System.assert(CallOutHelper.handleCallOutException(new CalloutException('SOAP Fault: xx faultcode=SOAP-ENV:Server.Unavailable.Temporary faultactor=)')));

        }
        Test.stopTest();
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }



}