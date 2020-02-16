/**
 * Created by jaapbranderhorst on 16/02/2020.
 */

({
    doInit : function(component, event, helper) {
        // Find the component whose aura:id is “flowData”
        var flow = component.find('flowData');
        // In that component, start your flow. Reference the flow’s Unique Name.
        console.log(flow);
        console.log(component.get("v.flowName"));
        flow.startFlow(component.get("v.flowName"));
    },
    handleStatusChange : function(component, event, helper) {
        var compEvent = component.getEvent("flowChangeEvent");
        compEvent.setParam("status", event.getParam("status"));
        compEvent.fire();
    }
});