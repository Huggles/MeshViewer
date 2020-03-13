/**
 * Created by hugovankrimpen on 12/03/2020.
 */

public with sharing class ErrorEventTriggerHandler {

    public static void AfterInsert(List<Error_Events__e> events){
        for(Error_Events__e event : events){


            String message = '\n' + 'Type: ' + event.Type__c + '\n' + 'Cause: ' + event.Cause__c + '\n' + 'Message: '
                    + event.Message__c + '\n' + 'Line #: ' + event.Line_Number__c;
            ErrorLogUtil.logMessage(message);
        }
    }
}