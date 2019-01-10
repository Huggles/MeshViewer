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
                callback(response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                _this.showToast(component, 'Error', 'Incomplete state returned from server', 'error');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                        _this.showToast(component, 'Error', errors[0].message, 'error');
                } else {
                    _this.showToast(component, "Error", 'Unknown Error', 'error');
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
    handleCompanyData : function(component) {
        component.set('v.step', '3');
        component.find("recordHandler").reloadRecord(true);
        this.showToast(component, 'Success', 'Company.info data sync successful', 'success'); //@todo labels on all toasts
        // Close quick action if that is the origin.
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire(); 
    }
})