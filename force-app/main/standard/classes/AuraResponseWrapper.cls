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
        
        //Application.rollback(); // perform database rollback
        if(response instanceof BdsException){
            this.response = null;
            this.state = 'ERROR';
            this.errorMsg = response.getMessage(); //= System.Label.BDS_WSCall_Generic_UI_Exception;    // todo handle known types for proper messaging
        }else{
            this.response = null;
            this.state = 'ERROR';
            this.errorMsg = System.Label.BDS_WSCall_Generic_UI_Exception;
        }

        

    }

}
