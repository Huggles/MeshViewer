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
    static void testSendSupportEmails() {
        List<Error_Events__e> events = new List<Error_Events__e>();
        for (Integer i = 0; i < 5; i++) {
            events.add(new Error_Events__e(Message__c = 'test'));
        }
        Test.startTest();
        ErrorLogUtil.sendSupportEmails(events);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, invocations);
    }



}