/****************************************************************************************
Author          : Jaap Branderhorst
Description     : Error log util class to log error messages to the ErrorLog SObject so even in batches you can review.

CAREFULL: doesn't work when you rollback the transaction.
******************************************************************************************/

public inherited sharing class ErrorLogUtil {

    public inherited sharing class ErrorLogQueuable implements Queueable {

        private String message { get; set; }

        public void execute(QueueableContext context) {
            Error_Log__c log = new Error_Log__c(Trace__c = message);
            insert log;
        }

        public ErrorLogQueuable(String message) {
            this.message = message;
        }

    }

    /**
     * Log an exception in the Error_log custom object.
     *
     * @param e
     */
    public static void logException(Exception e) {
            String message = '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
            logMessage(message);
        }


    /**
     * Log a message in the Error_log custom object
     *
     * @param message
     */
    public static void logMessage(String message) {
        System.debug(LoggingLevel.ERROR, 'ERROR: ' + message);
        if (Limits.getLimitQueueableJobs() - Limits.getQueueableJobs() > 0) {
            try {
                System.enqueueJob(new ErrorLogQueuable(message));
            } catch (Exception ex) {
                System.debug(LoggingLevel.ERROR, 'FATAL: cannot enqueue job to log error');
            }

        } else {
            System.debug(LoggingLevel.ERROR, 'FATAL: no queauable jobs available for logging errors');
        }
    }


    public  static void logExceptionWithEmail(List<Exception> exceptions) {
        List<Error_Log_Setting__mdt> errorLogSetting = [
                SELECT
                        Email__c,
                        Send_Via_Email__c,
                        DeveloperName,
                        Id,
                        Label,
                        Language,
                        MasterLabel,
                        NamespacePrefix,
                        QualifiedApiName
                FROM Error_Log_Setting__mdt WHERE DeveloperName = 'Incident_email' LIMIT 1];
        List<String> messages = new List<String>();
        for (Exception e : exceptions) {
            String message = '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                    + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
            messages.add(message);
            logException(e);
        }

        if (exceptions.size() > 0 && errorLogSetting.size() > 0 && errorLogSetting[0].Send_Via_Email__c) {
            //send email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setToAddresses(new String[] {errorLogSetting[0].Email__c});
            mail.setSubject('Update Scheduler Batch Processing Error');
            mail.setPlainTextBody(messages.toString());

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

}