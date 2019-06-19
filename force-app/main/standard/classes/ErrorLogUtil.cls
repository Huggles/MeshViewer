/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/

// TODO: rewrite completely so a) it is not CC specific and b) it uses platform events to prevent error logs not being written to the db
public with sharing class ErrorLogUtil {

    public with sharing virtual class ErrorLogException extends Exception {
    }


//    public static void commitLogs(){
//        //Application.rollback(); // perform database rollback
//        (new ErrorLogUtil()).doLog();
//    }

    // never used
//    public static void logAndCommit(Exception e){
////        if(e instanceof CCException){ // eh?
////            //throw e;
////        }else{
//            Error_Log__c log = new Error_Log__c();
//            log.Trace__c = '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
//                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
//            getLogList().add(log);
//                //throw new CCException(msg+ex.getMessage(), ex);
////        }
////
//        Application.rollback(); // perform database rollback
//        (new ErrorLogUtil()).doLog();
//    }

//    // TODO: move this Aura thing outside of the errorlogger
//    public static AuraResponseWrapper logAndCommitUI(Exception e, Object msg){
//        if(e instanceof CCException){
//            // EHhhhh???? looking at the code we are rolling back in the UI...bad, bad design. The UI doesn't/shouldn't have control over the transaction
//            Application.rollback(); // perform database rollback
//            return new AuraResponseWrapper(e);
//        }else{
//            Error_Log__c log = new Error_Log__c();
//            log.Trace__c = JSON.serializePretty(msg) + '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
//                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
//            getLogList().add(log);
//            Application.rollback(); // perform database rollback
//            (new ErrorLogUtil()).doLog();
//            return new AuraResponseWrapper(e, formatError(String.valueOf(msg))); // TODO get rid of the formatError
//        }
//
//    }
//
//    // This is really bad design since it checks for the faultcode and is specific to CI.
//    private static String formatError(String msg) {
//        // Format the error from the Company.info server if that's what it is. Otherwise just pass it through.
//        String actualError = msg;
//        if (actualError.contains('faultcode=')) {
//            List<String> parts = actualError.split(':');
//            if (parts.size() == 4) {
//                List<String> moreparts = parts[2].split('faultcode=');
//                if (moreparts.size() == 2) {
//                    actualError = moreparts[0];
//                }
//            }
//        }
//        return actualError;
//    }

    public static void logException(Exception e) {
            String message = '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
            logMessage(message);
        }


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
     * Writes the log messages to the database. Called by the trigger that listens to New_Error_log platform events
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