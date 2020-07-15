/****************************************************************************************
Author          : Jaap Branderhorst
Description     : Error log util class to log error messages to the ErrorLog SObject so even in batches you can review.

CAREFULL: doesn't work when you rollback the transaction.
******************************************************************************************/

public inherited sharing class ErrorLogUtil {

    private class AsyncLogger implements Queueable {
        private Exception ex;
        private Boolean sendEmail;

        public AsyncLogger(Exception ex, Boolean sendEmail) {
            this.ex = ex;
            this.sendEmail = sendEmail;
        }

        public void execute(QueueableContext param1) {
            ErrorLogUtil.logException(ex, sendEmail);
        }
    }

    @TestVisible
    private final static String ERROR_LOG_SETTING_EMAIL = 'Error_Email_Address';

    private static String supportEmailAddress {
        get {
            if (String.isEmpty(supportEmailAddress)) {
                supportEmailAddress = SettingUtils.getSetting(ERROR_LOG_SETTING_EMAIL);
            }
            return supportEmailAddress;
        }
        set;
    }

    /**
     * Logs an exception. This is the main method to be called whenever an exception happens
     *
     * @param e
     */
    public static void logException(Exception e) {
       logException(e, false);
    }

    /**
    *
    *
    * @param e the exception to log
    * @param sendEmail true if an email needs to be send to the in Error_Log_Setting__mdt configured email address
    */
    public static void logException(Exception e, Boolean sendEmail) {
        Error_Events__e error = new Error_Events__e();
        error.Type__c = e.getTypeName();
        error.Cause__c = String.valueOf(e.getCause());
        error.Message__c = e.getMessage();
        error.Line_Number__c = '' + e.getLineNumber();
        error.Stacktrace__c = e.getStackTraceString();
        error.Send_Email__c = sendEmail;
        EventBus.publish(error);
    }

    /**
     * Logs an exception without writing any DML. To be used in AuraEnabled(Cachaeable=true) methods.
     * THE TRANSACTION CANNOT END WITH AN EXCEPTION. NO LOGGING WILL TAKE PLACE. WRAP ANY EXCEPTIONS AND HANDLE THEM IN THE TRANSCATION
     *
     * @param e the exception to log
     * @param sendEmail true if an email needs to be send to the in Error_Log_Setting__mdt configured email address
     */
    public static void logExceptionNoDML(Exception e, Boolean sendEmail) {
        AsyncLogger asyncLogger = new AsyncLogger(e, sendEmail);
        System.enqueueJob(asyncLogger);
    }

    /**
    * Handles the after insert trigger event of the Error_Event__e platform event. Inserts the logged exception into the Error_Log__c custom object.
    *
    * @param events the events to log
    */
    public static void handleAfterEventInsert(List<Error_Events__e> events){
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        List<Error_Events__e> emailEvents = new List<Error_Events__e>();
        for(Error_Events__e event : events){
            errorLogs.add(new Error_Log__c(Send_Email__c = event.Send_Email__c, Cause__c = event.Cause__c, Message__c = event.Message__c, Line_Number__c = event.Line_Number__c, Stacktrace__c = event.Stacktrace__c, Type__c = event.Type__c));
        }
        // in system context since this needs to happen always
        insert errorLogs;
    }

    /**
    * Utility method to check if there are errors logged. Handy in test methods.
    *
    * @return true if there are any errors logged. Otherwise false.
    */
    public static Boolean hasErrorsLogged() {
        List<Error_Log__c> errorLogs = [SELECT Id FROM Error_Log__c LIMIT 1];
        return (errorLogs.size() == 1);
    }

    /**
    * Utility method that returns the number of errors logged. Handy in test methods.
    *
    * @return the number of errors logged in the database
    */
    public static Integer getNumberOfErrorsLogged() {
        return ([SELECT Id FROM Error_Log__c]).size();
    }

    /**
    * Sends an exception email to the Appsolutely support
    *
    * @param emailEvents the platform events for which to send emails
    */
    @InvocableMethod
    global static void sendSupportEmails(List<Error_Log__c> logs) {
        List<String> messages = new List<String>();
        for (Error_Log__c log : logs) {
            String message = '\n' + 'Type: ' + log.Type__c + '\n' + 'Cause: ' + log.Cause__c + '\n' + 'Message: '
                    + log.Message__c + '\n' + 'Line #: ' + log.Line_Number__c + '\n' + log.Stacktrace__c + '\n';
            messages.add(message);
        }
        //send email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {supportEmailAddress});
        mail.setSubject('Exception(s) from Company.info for Salesforce. Org Id ' + UserInfo.getOrganizationId() + ' and Org Name ' + UserInfo.getOrganizationName());
        mail.setPlainTextBody(messages.toString());

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }


}