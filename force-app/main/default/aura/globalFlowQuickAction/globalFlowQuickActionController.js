/**
 * Created by jaapbranderhorst on 28/02/2020.
 */

({
    doInit : function(component, event, helper) {
        $A.createComponent("c:flowContainer",
            {"flowName": "Organisation_Search_Flow",
                "flowChangeEvent" : component.getReference("c.handleFlowChangeEvent")},
            function(content, status) {
                if (status === "SUCCESS") {
                    // TODO: this modal takes the flow as content and thus doesn't see the footer of the flow as the footer of the modal
                    // TODO: just create a modal which takes the content of the flow through javascript/html/css
                    var promiseModal = component.find('overlayLib').showCustomModal({
                        body: content,
                        showCloseButton: true,
                        closeCallback: function() {
                            var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            dismissActionPanel.fire();
                        }
                    });
                    component.set("v.overlayPromise", promiseModal);

                }
            }
        );
    },
    handleFlowChangeEvent : function(component, event, helper) {
        var status = event.getParam("status");
        if (status === "FINISHED") {
            let overlayPromise = component.get("v.overlayPromise");
            overlayPromise.then((modal) => {modal.close()});
        }
    }
});