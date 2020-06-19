/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

@IsTest
private class ErrorLogUtilTest {

    private without sharing class TestException extends Exception {

    }

    @IsTest
    static void testLogException() {
        Test.startTest();
        ErrorLogUtil.logException(new TestException('message'));
        Test.stopTest();
        List<Error_Log__c> logs = [
                SELECT
                        Cause__c,
                        Line_Number__c,
                        Message__c,
                        Stacktrace__c,
                        Type__c
                FROM Error_Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals('message', logs[0].Message__c);
    }

    @IsTest
    static void testLogExceptionInCatch() {
        Test.startTest();
        try {
            Exception ex = new TestException('test');
            throw ex;
        } catch(Exception ex) {
            ErrorLogUtil.logException(ex);
        }
        Test.stopTest();
        List<Error_Log__c> logs = [
                SELECT
                        Cause__c,
                        Line_Number__c,
                        Message__c,
                        Stacktrace__c,
                        Type__c
                FROM Error_Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals('test', logs[0].Message__c);
    }

    @IsTest
    static void testLogExceptionWithSystemEmail() {
        Test.startTest();
        ErrorLogUtil.logException(new TestException('test'), true);
        Test.stopTest();
        // System.assertEquals(1, invocations); // doesn't work since sending the email is done in a different thread
        List<Error_Log__c> logs = [
                SELECT
                        Cause__c,
                        Line_Number__c,
                        Message__c,
                        Stacktrace__c,
                        Type__c
                FROM Error_Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals('test', logs[0].Message__c);
    }

    @IsTest
    static void testLogExceptionReThrown() {
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            try {
                throw new TestException();
            } catch (Exception ex) {
                ErrorLogUtil.logException(ex);
                throw ex;
            }
        } catch (Exception ex) {
            Test.stopTest();
            exceptionThrown = true;
        }
        System.assertEquals(true, ErrorLogUtil.hasErrorsLogged());
        System.assert(exceptionThrown);
    }

    @IsTest
    static void testSendSupportEmails() {
        List<Error_Log__c> logs = new List<Error_Log__c>();
        for (Integer i = 0; i < 5; i++) {
            logs.add(new Error_Log__c(Message__c = 'test', Send_Email__c = true));
        }
        Test.startTest();
        insert logs;
        System.debug('logs: ' + JSON.serializePretty(logs));
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, invocations);
    }

    @IsTest
    static void testHasErrorsLogged() {
        Test.startTest();
        ErrorLogUtil.logException(new TestException());
        Test.stopTest();
        Integer numbersOfErrorsLogged = ErrorLogUtil.getNumberOfErrorsLogged();
        Boolean errorsLogged = ErrorLogUtil.hasErrorsLogged();
        System.assertEquals(true, errorsLogged);
        System.assertEquals(1, numbersOfErrorsLogged);
    }

    @IsTest
    static void testHasNoErrorsLogged() {
        Test.startTest();
        Boolean errorsLogged = ErrorLogUtil.hasErrorsLogged();
        Integer numbersOfErrorsLogged = ErrorLogUtil.getNumberOfErrorsLogged();
        Test.stopTest();
        System.assertEquals(false, errorsLogged);
        System.assertEquals(0, numbersOfErrorsLogged);
    }



}