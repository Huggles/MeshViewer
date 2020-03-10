/**
 * Created by jaapbranderhorst on 28/02/2020.
 */

({
    doInit : function(component, event, helper) {
        var flowAPIName = component.get("v.flowAPIName");
        if (!flowAPIName) {
            // get the flow from the server
            helper.getFlowAPIName(component,event);
        }
    },
    handleFlowChangeEvent : function(component, event, helper) {
        var status = event.getParam("status");
        if (status === "FINISHED") {
            var outputVariables = event.getParam("outputVariables");
            var outputVar;
            if (outputVariables) {
                for (var i = 0; i < outputVariables.length; i++) {
                    outputVar = outputVariables[i];
                    if (outputVar.name === "recordId") {
                        var urlEvent = $A.get("e.force:navigateToSObject");
                        urlEvent.setParams({
                            "recordId": outputVar.value,
                            "isredirect": "true"
                        });
                        urlEvent.fire();
                    }
                }
            }
            let overlayPromise = component.get("v.overlayPromise");
            overlayPromise.then((modal) => {modal.close()});

        }
    },
    handleFlowAPINameChangeEvent : function(component, event, helper) {
        helper.showModalAndFlow(component, event);
    }
});