({
    callServer : function(cmp, methodName, params, callback, stubResponse) {

        if (stubResponse) {
            console.log('stubbing');
            callback(JSON.parse(stubResponse));
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
                console.log("success");
                console.log(JSON.stringify(response.getReturnValue()));
                callback(response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log(state);
                console.log(JSON.stringify(response));
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        _this.showToast('Error', errors[0].message, 'error');
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        console.log('action queued');
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
        console.log(response);
        component.set('v.companyList', response);
        component.set('v.step', '2');
    },
    handleCompanyData : function(component, response) {
        console.log(this.outputProxy(response));
        this.showToast(component, 'Personnel', 'Number: ' + response.personnel, 'info');
        component.set('v.step', '3');
    }
})