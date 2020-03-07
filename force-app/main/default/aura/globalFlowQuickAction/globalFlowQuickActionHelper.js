/**
 * Created by jaapbranderhorst on 07/03/2020.
 */

({
    getFlowAPIName : function(component, event) {
        var action = component.get("c.getFlowAPIName");
        action.setParams({ flowSettingName : component.get("v.flowSettingName") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.flowAPIName", response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    showModalAndFlow : function(component, event) {
        var modalBody;
        $A.createComponent("lightning:flow",
            {"aura:id": "flow",
                "onstatuschange" : component.getReference("c.handleFlowChangeEvent")
            },
            function(content, status, errorMessage) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    var promiseModal = component.find('overlayLib').showCustomModal({
                        body: modalBody,
                        showCloseButton: true,
                        closeCallback: function() {
                            var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            dismissActionPanel.fire();
                        }
                    });
                    component.set("v.overlayPromise", promiseModal);
                    var flow = component.find("flow");
                    flow.startFlow(component.get("v.flowAPIName"));
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
    }
});