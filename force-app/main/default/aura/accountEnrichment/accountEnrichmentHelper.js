/**
 * Created by jaapbranderhorst on 29/02/2020.
 */

({/**
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
     * Starts the flow
     * TODO: make the flow name configurable
     * @param component
     */
    startFlow: function(component) {
        var flow = component.find("flowData");
        if (flow) {
            var inputVariables = [
                {
                    name : 'recordId',
                    type : 'String',
                    value : component.get("v.recordId")
                }
            ];
            flow.startFlow(component.get("v.flowName"), inputVariables);
        }
    }
});