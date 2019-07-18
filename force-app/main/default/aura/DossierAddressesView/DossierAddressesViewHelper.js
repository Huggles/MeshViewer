/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

({
    /**
     * Call Apex Method
     * @param {*} component
     * @param {string} methodName The name of the apex method to call
     * @param {object} params An object containing the arguments to pass to the apex method
     * @param {function} callback A js function to be called on successful response from apex
     * @param {*} stubResponse To be removed, response to stub calls (to avoid costly API calls).
     */
    callServer : function(component, methodName, params, callback, stubResponse) {

        // @todo remove after development
        if (stubResponse) {
            callback(stubResponse);
            return;
        }

        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var _this = this;
        var action = component.get(methodName);
        action.setParams(params);

        // Create a callback that is executed after
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().state ==="SUCCESS"){
                    callback(response.getReturnValue().response);
                }else{
                    _this.formattedToast(component, response.getReturnValue().errorMsg);
                }
            }
            else if (state === "INCOMPLETE") {
                _this.showToast(component, $A.get('$Label.c.Error'), $A.get('$Label.c.Error_Incomplete'), 'error');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    _this.formattedToast(component, errors[0].message);
                } else {
                    _this.showToast(component, $A.get('$Label.c.Error'), $A.get('$Label.c.Error_Unknown'), 'error');
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events,
        // which could trigger other events and
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    handleSuccessFulLoad: function(component, response) {
        for (var i = 0; i < response.length; i++) {
            if (!response.cust_connect__Type__c) response.cust_connect__Type__c = '';
            if (!response.cust_connect__Street__c) response.cust_connect__Street__c = '';
            if (!response.cust_connect__House_Number__c) response.cust_connect__House_Number__c = '';
            if (!response.cust_connect__House_Number_Addition__c) response.cust_connect__House_Number_Addition__c = '';
            if (!response.cust_connect__Postcode__c) response.cust_connect__Postcode__c = '';
            if (!response.cust_connect__City__c) response.cust_connect__City__c = '';
            if (!response.cust_connect__Country__c) response.cust_connect__Country__c = '';

        }
        component.set('v.data', response);
    },
    formattedToast : function(component, msg) {
        var parts = msg.split(':');
        if (parts.length === 2)
            this.showToast(component, parts[0], parts[1], 'error');
        else
            this.showToast(component, $A.get('$Label.c.Error'), msg, 'error');
    },
    /**
     * Fire toast event
     * @param {*} component
     * @param {*} title
     * @param {*} message
     * @param {*} type success/error/info
     */
    showToast : function(component, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "mode": (type == 'error' ? 'sticky' : 'dismissible'),
            "message": message,
            "type": (type == null ? 'info' : type)
        });
        toastEvent.fire();
    }
});