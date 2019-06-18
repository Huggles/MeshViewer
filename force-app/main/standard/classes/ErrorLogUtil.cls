/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/

// TODO: rewrite completely so a) it is not CC specific and b) it uses platform events to prevent error logs not being written to the db
public with sharing class ErrorLogUtil {

    public with sharing virtual class ErrorLogException extends Exception {

    }

    @TestVisible
    private static Boolean errorLogged = false;
    private static list<Error_Log__c> logList ;

    // without sharing since the errorLog should be saved always
    private without sharing class SaveErrorLogQueable implements Queueable {

        private list<Error_Log__c> errorLogs {get; set;}

        public SaveErrorLogQueable(list <Error_Log__c> errorLogs) {
            this.errorLogs = errorLogs;
        }

        public void execute(QueueableContext context) {
            // runs deliberately in system context without FLS and CRUD check. Should always be inserted.
            try {
                insert errorLogs;
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, e);
                throw e;
            }

        }

    }

    private static List<Error_Log__c> getLogList(){
        if(logList == null){
            logList = new list<Error_Log__c>();
        }
        return loglist;
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

    // TODO: move this Aura thing outside of the errorlogger
    public static AuraResponseWrapper logAndCommitUI(Exception e, Object msg){
        if(e instanceof CCException){
            Application.rollback(); // perform database rollback
            (new ErrorLogUtil()).doLog();
            return new AuraResponseWrapper(e);
        }else{
            Error_Log__c log = new Error_Log__c();
            log.Trace__c = JSON.serializePretty(msg) + '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
            getLogList().add(log);
            Application.rollback(); // perform database rollback
            (new ErrorLogUtil()).doLog();
            return new AuraResponseWrapper(e, formatError(String.valueOf(msg))); // TODO get rid of the formatError
        }

    }

    // This is really bad design since it checks for the faultcode and is specific to CI.
    private static String formatError(String msg) {
        // Format the error from the Company.info server if that's what it is. Otherwise just pass it through.
        String actualError = msg;
        if (actualError.contains('faultcode=')) {
            List<String> parts = actualError.split(':');
            if (parts.size() == 4) {
                List<String> moreparts = parts[2].split('faultcode=');
                if (moreparts.size() == 2) {
                    actualError = moreparts[0];
                }
            }
        }
        return actualError;
    }

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
//        getLogList().add(log);

    }

//    private void doLog() {
////        system.debug('DOIG LOGS **************');
//        if (Test.isRunningTest()) {
//            ErrorLogUtil.errorLogged = true;
//        }
//        // storing the log in a queable to ensure we don't run into issues with callouts
//        if ((Limits.getLimitQueueableJobs() - Limits.getQueueableJobs()) >= 1) {
//            if (!Test.isRunningTest())
//                System.enqueueJob(new SaveErrorLogQueable(getLogList()));
//        }
//        //insert(getLogList());
//    }



}