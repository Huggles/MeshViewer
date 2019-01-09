/*
###########################################################################
# File............................: LogUtil.cls
# Created by.................:  Appsolutely B.V.
# Created Date..............:  12 November 2018
# Last Modified Date......:
# Description.................: this class is used to log the errors/exception for a record/class
# VF Page......................:
# VF Component...........:
# L Comp.......................:
# Test Class…................:
#
#############################################################################
*/

//TBD as per Jaap's suggestion
public with sharing class LoggerUtil{
    /*
        A inner Class that Defines theStructure of a Log
    
    public virtual class Log {
        public String Type;
        public String ApexClass;
        public String Method;
        public String RecordId;
        public String Message;
        public String StackTrace;
    }

    /*
        A Class that Extends the Virtual Class - Log to define a log of type - Error
   
    public class Error extends Log {
        public Error(String cls, String methodName, String recId, Exception ex){
            this.Type = 'Error';
            this.ApexClass = cls;
            this.Method = methodName;
            this.RecordId = recId;
            this.Message = ex.getMessage();
            this.StackTrace = ex.getStackTraceString();
        }
    }

    
        A Class that Extends the Virtual Class - Log to define a log of type - Information
    
    public class Information extends Log {
        public Information(String cls, String methodName, String recId, String msg){
            this.Type = 'Information';
            this.ApexClass = cls;
            this.Method = methodName;
            this.RecordId = recId;
            this.Message = msg;
            this.StackTrace = NULL;
        }
    }

    
        A Public Method that can be utilized by other Apex Classes to create a record into
        the Apex Debug Log object stating the Error or Information.
    
    public void createLog(Log logToCreate){
        
            Ensure that we're well within the Governor Limits.
            The creation of the Log shouldn't disturb the execution of that Apex Class that utilizes this method to create a log.
        

        if((Limits.getDMLRows() < Limits.getLimitDMLRows()) && (Limits.getDMLStatements() < Limits.getLimitDMLStatements()))
        {
            Transaction_Log__c transactionLog = new Transaction_Log__c(
                    Apex_Class__c   = logToCreate.ApexClass,
                    Type__c         = logToCreate.Type,
                    Method__c       = logToCreate.Method,
                    Record_Id__c    = logToCreate.RecordId,
                    Message__c      = logToCreate.Message,
                    Stack_Trace__c  = logToCreate.StackTrace
            );
            insert transactionLog;
        } else {
            System.debug('The Governor Limits have already been exhausted and hence failed to create a Log!');
        }
    }
*/
}