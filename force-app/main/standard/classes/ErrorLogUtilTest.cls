/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

@IsTest
private class ErrorLogUtilTest {

    private without sharing class TestException extends Exception {

    }

    @IsTest
    static void testLogMessageNoExceptionThrown() {
        Test.startTest();
        ErrorLogUtil.logMessage('test');
        Test.stopTest();
        Error_Log__c[] logs = [SELECT Id, Trace__c FROM Error_Log__c];
        System.assert(logs.size() == 1);
        System.assert(logs[0].Trace__c == 'test');
    }

    @IsTest
    static void testLogExceptionNoExceptionThrown() {
        Test.startTest();
        Exception ex = new TestException('test');
        ErrorLogUtil.logException(ex);
        Test.stopTest();
        Error_Log__c[] logs = [SELECT Trace__c FROM Error_Log__c];
        System.assert(logs.size() == 1);
        System.assert(logs[0].Trace__c.contains('test'));
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
        Error_Log__c[] logs = [SELECT Trace__c FROM Error_Log__c];
        System.assertEquals(1, logs.size());
        System.assert(logs[0].Trace__c.contains('test'));
    }

    @IsTest
    static void testLogExceptionWithEmail() {
        Test.startTest();
        Exception ex = new TestException('test');
        ErrorLogUtil.logExceptionWithEmail(new List<Exception>{ex});
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        Error_Log__c[] logs = [SELECT Trace__c FROM Error_Log__c];
        System.assert(logs.size() == 1);
        System.assert(logs[0].Trace__c.contains('test'));
        System.assertEquals(1, invocations);
    }

}