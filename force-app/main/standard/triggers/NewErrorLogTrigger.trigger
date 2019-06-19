trigger NewErrorLogTrigger on New_Error_Log__e (after insert) {

    ErrorLogUtil.writeLogs((List<New_Error_Log__e>)Trigger.new);

}