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
        (new ErrorLogUtil()).doLog(e);
    }
    public static void logMessage(Object msg) {
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

}