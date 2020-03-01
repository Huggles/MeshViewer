/**
 * Created by jaapbranderhorst on 16/02/2020.
 */

({
    doInit : function(component, event, helper) {
        debugger;
        // Find the component whose aura:id is “flowData”
        var flow = component.find('flowData');
        // In that component, start your flow. Reference the flow’s Unique Name.
        // build a list with arguments
        // var arguments = [];
        // var stringParams = component.get("v.stringParameters");
        // for (const key of stringParams.keys()) {
        //     var value = stringParams.get(key);
        //     arguments.push({
        //         name : key,
        //         type : 'String',
        //         value : value
        //     });
        // }
        flow.startFlow(component.get("v.flowName"), arguments);
    },
    handleStatusChange : function(component, event, helper) {
        var compEvent = component.getEvent("flowChangeEvent");
        compEvent.setParam("status", event.getParam("status"));
        compEvent.fire();
    }
});