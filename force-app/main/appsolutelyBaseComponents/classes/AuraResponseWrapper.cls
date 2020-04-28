/****************************************************************************************
Author          : ValerijsProkudins
Description     : Wrapper for aura and lwc responses to handle log saving on exceptions
******************************************************************************************/
public with sharing class AuraResponseWrapper {
 
@AuraEnabled public Object response { get; set; }
@AuraEnabled public String state { get; set; }
@AuraEnabled public String errorMsg { get; set; }

    public AuraResponseWrapper(Object response, String state, String errorMsg) {
        this.response = response;
        this.state = state;
        this.errorMsg = errorMsg;
    }
    public AuraResponseWrapper(Object response) {
        this.response = response;
        this.state = 'SUCCESS';
        this.errorMsg = '';
    }

    public AuraResponseWrapper(Exception response) {
        this.response = null;
        this.state = 'ERROR';
        this.errorMsg = response.getMessage();
    }

    public AuraResponseWrapper(Exception response, String msg) {
        this.response = null;
        this.state = 'ERROR';
        this.errorMsg = msg;
    }
}
