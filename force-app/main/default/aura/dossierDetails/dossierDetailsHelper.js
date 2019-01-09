({
    callServer : function(cmp, methodName, params, callback, stubResponse) {

        // @todo remove after development
        if (stubResponse) {
            console.log('stubbing');
            callback(stubResponse);
            return;
        }
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var _this = this;
        var action = cmp.get(methodName);
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
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        _this.showToast(component, 'Error', errors[0].message, 'error');
                    }
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
    showToast : function(component, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": (type == null ? 'info' : type)
        });
        toastEvent.fire();
    },
    handleSearchResults : function(component, response) {
        component.set('v.companyList', response);
        component.set('v.step', '2');
    },
    handleCompanyData : function(component, response) {
        component.set('v.step', '3');
        component.find("recordHandler").reloadRecord(true);
        this.showToast('Success', 'Company.info data sync succesful', 'success'); //@todo labels on all toasts
    }
})