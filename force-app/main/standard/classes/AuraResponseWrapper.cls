/****************************************************************************************
Author          : ValerijsProkudins
Description     : Wrapper for aura and lwc responses to handle log saving on exceptions
******************************************************************************************/
public with sharing class AuraResponseWrapper {
 
@AuraEnabled public Object response;
@AuraEnabled public String state;
@AuraEnabled public String errorMsg;

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
        if(response instanceof CCException){
            this.response = null;
            this.state = 'ERROR';
            this.errorMsg = response.getMessage(); //= System.Label.WSCall_Generic_UI_Exception;    // todo handle known types for proper messaging
        }else{
            this.response = null;
            this.state = 'ERROR';
            this.errorMsg = System.Label.WSCall_Generic_UI_Exception;
        }
    }
    public AuraResponseWrapper(Exception response, Object msg) {
        if(response instanceof CCException){
            this.response = null;
            this.state = 'ERROR';
            this.errorMsg = response.getMessage(); //= System.Label.WSCall_Generic_UI_Exception;    // todo handle known types for proper messaging
        }else{
            this.response = null;
            this.state = 'ERROR';
            this.errorMsg = JSON.serializePretty(msg);
        }
    }
}
