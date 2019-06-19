/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/

// TODO: rewrite completely so a) it is not CC specific and b) it uses platform events to prevent error logs not being written to the db
public with sharing class ErrorLogUtil {

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
        New_Error_Log__e event = new New_Error_Log__e(Message__c = message);
        Database.SaveResult result = EventBus.publish(event);
        if (!result.isSuccess()) { // we couldn't publish the event, something is really wrong
            Database.Error[] errors = result.getErrors();
            String errorsToString = '';
            for (Database.Error error : errors) {
                errorsToString += error;
                errorsToString += '\n';
            }
            System.debug(LoggingLevel.ERROR, 'FATAL: cannot publish error log!\n' +
                errorsToString); // todo: label
            throw new ErrorLogException('FATAL: cannot publish error log!');
        }
    }

    /**
     * Writes the log messages to the database. Called by the trigger that listens to New_Error_log platform events. Do not call directly!
     *
     * @param logEvents
     */
    public static void writeLogs(New_Error_Log__e[] logEvents) {
        List<Error_Log__c> newLogs = new List<Error_Log__c>();
        for (New_Error_Log__e newErrorLog : logEvents) {
            newLogs.add(new Error_Log__c(Trace__c = newErrorLog.Message__c));
        }
        insert newLogs; // todo: add proper error handling
    }


}