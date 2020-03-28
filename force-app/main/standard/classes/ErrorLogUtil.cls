/****************************************************************************************
Author          : Jaap Branderhorst
Description     : Error log util class to log error messages to the ErrorLog SObject so even in batches you can review.

CAREFULL: doesn't work when you rollback the transaction.
******************************************************************************************/

public inherited sharing class ErrorLogUtil {

    private final static String ERROR_LOG_SETTING_EMAIL = 'Error_Email_Address';

    private static String supportEmailAddress {
        get {
            if (String.isEmpty(supportEmailAddress)) {
                List<Setting__mdt> emailSettings = [SELECT Value__c FROM Setting__mdt WHERE DeveloperName =: ERROR_LOG_SETTING_EMAIL LIMIT 1];
                if (emailSettings != null && emailSettings.size() == 1) {
                    supportEmailAddress = emailSettings.get(0).Value__c;
                } else {
                    Exception ex = new CIConfigurationException('No admin email address configured');
                    logException(ex);
                    throw ex;
                }
            }
            return supportEmailAddress;
        }
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
    * Handles the after insert trigger event of the Error_Event__e platform event. Inserts the logged exception into the Error_Log__c custom object.
    *
    * @param events the events to log
    */
    public static void handleAfterInsert(List<Error_Events__e> events){
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        List<Error_Events__e> emailEvents = new List<Error_Events__e>();
        for(Error_Events__e event : events){
            errorLogs.add(new Error_Log__c(Cause__c = event.Cause__c, Message__c = event.Message__c, Line_Number__c = event.Line_Number__c, Stacktrace__c = event.Stacktrace__c, Type__c = event.Type__c));
            if (event.Send_Email__c) {
                emailEvents.add(event);
            }
        }
        // in system context since this needs to happen always
        insert errorLogs;
        sendSupportEmails(emailEvents);
    }


    /**
    * Sends an exception email to the Appsolutely support
    *
    * @param emailEvents the platform events for which to send emails
    */
    @TestVisible
    private static void sendSupportEmails(List<Error_Events__e> emailEvents) {
        List<String> messages = new List<String>();
        for (Error_Events__e e : emailEvents) {
            String message = '\n' + 'Type: ' + e.Type__c + '\n' + 'Cause: ' + e.Cause__c + '\n' + 'Message: '
                    + e.Message__c + '\n' + 'Line #: ' + e.Line_Number__c + '\n' + e.Stacktrace__c + '\n';
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