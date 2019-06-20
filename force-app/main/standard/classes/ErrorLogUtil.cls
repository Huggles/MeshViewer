/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/

public with sharing class ErrorLogUtil {

    public with sharing class ErrorLogQueuable implements Queueable {

        private String message { get; set; }

        public void execute(QueueableContext context) {
            Error_Log__c log = new Error_Log__c(Trace__c = message);
            insert log;
        }

        public ErrorLogQueuable(String message) {
            this.message = message;
        }

    }

    public with sharing virtual class ErrorLogException extends Exception {
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
        if (Limits.getLimitQueueableJobs() - Limits.getQueueableJobs() > 0) {
            System.debug(message);
            System.enqueueJob(new ErrorLogQueuable(message));
        }
    }


}