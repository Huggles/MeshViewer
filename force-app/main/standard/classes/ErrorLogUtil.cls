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
        Error_Events__e error = new Error_Events__e();
        error.Type__c = e.getTypeName();
        error.Cause__c = String.valueOf(e.getCause());
        error.Message__c = e.getMessage();
        error.Line_Number__c = e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
        EventBus.publish(error);
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
                System.enqueueJob(new ErrorLogUtil.ErrorLogQueuable(message));
            } catch (Exception ex) {
                System.debug(LoggingLevel.ERROR, 'FATAL: cannot enqueue job to log error');
            }

        } else {
            System.debug(LoggingLevel.ERROR, 'FATAL: no queauable jobs available for logging errors');
        }
    }


}