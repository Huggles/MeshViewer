({
    doInit : function(component, event, helper) {
        $A.createComponent("c:flowContainer", {"flowName": "Organisation_Search_Flow"},
           function(content, status) {
               if (status === "SUCCESS") {
                   component.find('overlayLib').showCustomModal({
                       body: content,
                       showCloseButton: true,
                       closeCallback: function() {
                            var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            dismissActionPanel.fire();
                       }
                   });
               }
           }
        );
    },
    handleFlowChangeEvent : function(component, event, helper) {
        var status = event.getParam("status");
        if (status === "FINISHED") {
            component.find('overlayLib').notifyClose();
        }
    }
});
