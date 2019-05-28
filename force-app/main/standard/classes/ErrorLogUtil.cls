/**
 * Created by jaapbranderhorst on 13/02/2018.
 */

public with sharing class ErrorLogUtil {

    @TestVisible
    private static Boolean errorLogged = false;

    // without sharing since the errorLog should be saved always
    public without sharing class SaveErrorLogQueable implements Queueable {

        private Error_Log__c errorLog {get; set;}

        public SaveErrorLogQueable(Error_Log__c errorLog) {
            this.errorLog = errorLog;
        }

        public void execute(QueueableContext context) {
            // runs deliberately in system context without FLS and CRUD check. Should always be inserted.
            try {
                insert errorLog;
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, e);
                throw e;
            }

        }

    }

    public static void logException(Exception e) {
        Application.rollback(); // perform database rollback
        (new ErrorLogUtil()).doLog(e);
    }
    public static void logException(Exception e, Object msg) {
        Application.rollback(); // perform database rollback
        (new ErrorLogUtil()).doLog(e, msg);
    }
    public static void logMessage(Object msg) {
        Application.rollback(); // perform database rollback
        (new ErrorLogUtil()).doLog(msg);
    }
    private void doLog(Exception e) {
        Error_Log__c log = new Error_Log__c();
        log.Trace__c = 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';

        System.debug(LoggingLevel.ERROR, log.Trace__c);
        if (Test.isRunningTest()) {
            ErrorLogUtil.errorLogged = true;
        }
        // storing the log in a queable to ensure we don't run into issues with callouts
        if ((Limits.getLimitQueueableJobs() - Limits.getQueueableJobs()) >= 1) {
            if (!Test.isRunningTest())
                System.enqueueJob(new SaveErrorLogQueable(log));
        }
    }
    private void doLog(Object msg) {
        Error_Log__c log = new Error_Log__c();
        log.Trace__c = JSON.serializePretty(msg);
        System.debug(LoggingLevel.ERROR, log.Trace__c);
        if (Test.isRunningTest()) {
            ErrorLogUtil.errorLogged = true;
        }
        // storing the log in a queable to ensure we don't run into issues with callouts
        if ((Limits.getLimitQueueableJobs() - Limits.getQueueableJobs()) >= 1) {
            if (!Test.isRunningTest())
                System.enqueueJob(new SaveErrorLogQueable(log));
        }
    }
    private void doLog(Exception e, Object msg) {
        Error_Log__c log = new Error_Log__c();
        /*if(e instanceof BdsException){
            BdsException ex = (BdsException)e;
            log.Trace__c = JSON.serializePretty(msg) + '\n' + 'Type: ' + ex.originalException.getTypeName() + '\n' + 'Cause: ' + ex.getCause() + '\n' + 'Message: '
                + ex.getMessage() + '\n' + 'Line #: ' + ex.getLineNumber() + '\n' + ex.getStackTraceString() + '\n';
        }else{*/
            log.Trace__c = JSON.serializePretty(msg) + '\n' + 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '
                + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() + '\n';
       // }
        
        System.debug(LoggingLevel.ERROR, log.Trace__c);

        if (Test.isRunningTest()) {
            ErrorLogUtil.errorLogged = true;
        }
        //Application.rollback(); // perform database rollback(because off full handled cycle)

        // storing the log in a queable to ensure we don't run into issues with callouts
        if ((Limits.getLimitQueueableJobs() - Limits.getQueueableJobs()) >= 1) {
            if (!Test.isRunningTest())
                System.enqueueJob(new SaveErrorLogQueable(log));
        }
    }

}