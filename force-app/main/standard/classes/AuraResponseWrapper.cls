public with sharing class AuraResponseWrapper {
 
@AuraEnabled public Object response;
@AuraEnabled public String state;
@AuraEnabled public String errorMsg;

    public AuraResponseWrapper(Object response, String state, String errorMsg) {
        this.response = response;
        this.state = state;
        this.errorMsg = errorMsg;
    }
}
