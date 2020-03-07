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
            let overlayPromise = component.get("v.overlayPromise");
            overlayPromise.then((modal) => {modal.close()});
        }
    },
    handleFlowAPINameChangeEvent : function(component, event, helper) {
        helper.showModalAndFlow(component, event);
    }
});