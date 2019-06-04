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
            console.log('stubbing');
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
                if(response.getReturnValue().state === 'SUCCESS'){
                    console.log('SUCCESS IN WRAPPER');
                    callback(response.getReturnValue().response);
                }else if(response.getReturnValue().state === 'ERROR'){
                    console.log('SUCCESS IN WRAPPER');
                    _this.showToast(component, $A.get('$Label.c.BDS_Error'), response.getReturnValue().errorMsg, 'error');
                }
               
                //callback(response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                _this.showToast(component, $A.get('$Label.c.BDS_Error'), $A.get('$Label.c.BDS_Error_Incomplete'), 'error');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                        _this.showToast(component, $A.get('$Label.c.BDS_Error'), errors[0].message, 'error');
                } else {
                    _this.showToast(component, $A.get('$Label.c.BDS_Error'), $A.get('$Label.c.BDS_Error_Unknown'), 'error');
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
    /**
     * Rebuilds a given proxy object to a readable format for debugging.
     * @param {*} record 
     */
    outputProxy : function(record) {
        var obj = {};
        for(var propt in record) {
            obj[propt] = record[propt];
            if (typeof(record[propt]) == 'object') {
                obj[propt] = this.outputProxy(record[propt]);
            }
        }
        return obj;
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
    },
    /**
     * Increment step and store list of results for display
     * @param {*} component 
     * @param {*} response 
     */
    handleSearchResults : function(component, response) {
        component.set('v.companyList', response);
        component.set('v.step', '2');
    },
    /**
     * Increment step and refresh LDS record.
     * @param {*} component 
     */
    handleDossierSelect : function(component, response) {
        console.log('hello!');
        this.showToast(component, $A.get('$Label.c.BDS_Success'), $A.get('$Label.c.BDS_Sync_Success'), 'success');
        component.set('v.dossier', response[0]);
        component.set('v.existingAccountId', response[1].Id);
        //component.set('v.existingAccount', response[2]);
        //if(response[2]){
        //    component.set('v.accountExists', true);
        //}
        console.log('dossier____');
        console.log(component.get('v.dossier'));
        console.log(JSON.parse(JSON.stringify(response[1])));
        console.log('acc_____');
        console.log(component.get('v.existingAccountId'));
        console.log(JSON.parse(JSON.stringify(response[1])));
        console.log('almost end________')
        console.log(response[1]);
        //component.set('v.step', '3');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": response[1].Id,
          "slideDevName": "related"
        });
        navEvt.fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire(); 

    },
    handlecreateUpdateAccount : function(component, response){
        console.log('SUCCESS!!!!!');
        component.set('v.actionCompleted', "true");

    }
})