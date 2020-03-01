/**
 * Created by jaapbranderhorst on 29/02/2020.
 */

({
    /**
     * Triggered when the status of the flow changes. Reloads the component if the flow is finished.
     * @param component
     * @param event
     * @param helper
     */
    handleFlowChangeEvent : function(component, event) {
        debugger;
        var params = event.getParams();
        // for (var key in params) {
        //     console.log(key);
        //     console.log(event.getParam(key));
        // }
        var status = event.getParam("status");
        if (status === "FINISHED") {
            // reload the component
            component.find("accountLoader").reloadRecord(true);
            //component.set("v.reloadComponent", !component.get("v.reloadComponent"));
        }
    },
    /**
     * Handles the change of the lookup to the dossier from the account.
     * This lookup is the trigger for different behavior of the component (show the dossier or the flow).
     * Starts the flow if the lookup is null.
     * @param component
     * @param event
     * @param helper
     */
    handleDossierLookupChange : function(component, event, helper) {
        debugger;
        var oldValue = event.getParam("oldValue");
        var newValue = event.getParam("value");
        if (!newValue) {
            helper.startFlow(component);
        }
    },
    handleAccountRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            helper.startFlow(component);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            console.log(component.get("v.error"));
            // there’s an error while loading, saving, or deleting the record
        }
    },
    handleErrorChange : function(component, event, helper) {
        var error = component.get('v.error');
        if (error && error != '') {
            helper.showToast(component, $A.get('$Label.c.Error'), error);
        }
    }
});