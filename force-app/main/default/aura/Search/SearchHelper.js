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
        var record = component.get('v.simpleRecord');
        record.Dossier_Number__c = response.dossier_number;
        component.set('v.simpleRecord', record);
        this.handleSaveRecord(component);
    },
    handleSaveRecord: function(component) {
        console.log('handleSaveRecord');
        component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {
            // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
            // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                component.set('v.dossierId', saveResult.getReturnValue());
                console.log("Saved");
                // handle component related logic in event handler
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    }
})