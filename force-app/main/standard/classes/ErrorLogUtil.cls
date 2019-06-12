/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/
public with sharing class ErrorLogUtil {

    @TestVisible
    private static Boolean errorLogged = false;
    private static list<Error_Log__c> logList ;

    // without sharing since the errorLog should be saved always
    public without sharing class SaveErrorLogQueable implements Queueable {

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
    private static list<Error_Log__c> getLogList(){
        if(logList == null){
            logList = new list<Error_Log__c>();
        }
        return loglist;
    }

    public static void commitLogs(){
        //Application.rollback(); // perform database rollback
        (new ErrorLogUtil()).doLog();
    }

    public static void logAndCommit(Exception e){
        if(e instanceof CCException){
            //throw e;
        }else{
            Error_Log__c log = new Error_Log__c();
            log.Trace__c = '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
                getLogList().add(log);
                //throw new CCException(msg+ex.getMessage(), ex);
        }
        
        Application.rollback(); // perform database rollback
        (new ErrorLogUtil()).doLog();
    }
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
            return new AuraResponseWrapper(e, formatError(String.valueOf(msg)));
        }

    }
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
    public static void logException(Exception e, Object msg) {
        system.debug('logging exception');
        if(e instanceof CCException){
            throw e;
        }else{
            Error_Log__c log = new Error_Log__c();
            log.Trace__c = JSON.serializePretty(msg) + '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                    + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
            getLogList().add(log);

            

            throw new CCException(msg + ':' + formatError(e.getMessage()));
        }
    }

    public static void logException(Exception e) {
        if(e instanceof CCException){
            throw e;
        }else{
            Error_Log__c log = new Error_Log__c();
            log.Trace__c = '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
            getLogList().add(log);
            throw new CCException(e.getMessage());//System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }

    public static void logMessage(Object msg) {
        Error_Log__c log = new Error_Log__c();
        log.Trace__c = JSON.serializePretty(msg);
        getLogList().add(log);

    }
    private void doLog() {
        system.debug('DOIG LOGS **************');
        if (Test.isRunningTest()) {
            ErrorLogUtil.errorLogged = true;
        }
        // storing the log in a queable to ensure we don't run into issues with callouts
        if ((Limits.getLimitQueueableJobs() - Limits.getQueueableJobs()) >= 1) {
            if (!Test.isRunningTest())
                System.enqueueJob(new SaveErrorLogQueable(getLogList()));
        }
        //insert(getLogList());
    }



}