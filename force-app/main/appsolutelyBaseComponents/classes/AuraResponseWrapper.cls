/****************************************************************************************
Author          : Jaap Branderhorst
Description     : Wrapper for aura and lwc responses to handle log saving on exceptions
******************************************************************************************/
public with sharing class AuraResponseWrapper {

    @AuraEnabled public Object data;
    @AuraEnabled public String state;
    @AuraEnabled public ErrorWrapper error;

    public class ErrorWrapper {
        @AuraEnabled
        public String message { get; set; }
        @AuraEnabled
        public String type {get; set;}
        @AuraEnabled
        public String stackTrace {get; set;}
        @AuraEnabled
        public String lineNumber {get;set;}

        public ErrorWrapper(Exception ex) {
            this.message = ex.getMessage();
            this.type = ex.getTypeName();
            this.stackTrace = ex.getStackTraceString();
            this.lineNumber = '' + ex.getLineNumber();
        }
    }

    public AuraResponseWrapper(Object data) {
        this.data = data;
        this.state = 'SUCCESS';
    }

    public AuraResponseWrapper(Exception ex, Boolean logException, Boolean emailException) {
        this.state = 'ERROR';
        this.error = new ErrorWrapper(ex);
        if (logException) {
            ErrorLogUtil.logExceptionNoDML(ex, emailException);
        }
    }

    public AuraResponseWrapper(Exception ex) {
        this(ex, false, false);
    }

    public AuraResponseWrapper(Exception ex, Boolean logException) {
        this(ex, logException, false);
    }
}