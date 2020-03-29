/**
 * Created by hugovankrimpen on 12/03/2020.
 */

trigger ErrorEventTrigger on Error_Events__e (after insert) {

    if(Trigger.isInsert && Trigger.isAfter){
        ErrorLogUtil.handleAfterInsert(Trigger.new);
    }
}