({
    doInit : function(component, event, helper) {
        // $A.createComponent("c:dossierDetails", {},
        //    function(content, status) {
        //        if (status === "SUCCESS") {
        //            component.find('overlayLib').showCustomModal({
        //                header: $A.get("$Label.c.New_Account_CC"),
        //                body: content,
        //                showCloseButton: true,
        //                closeCallback: function() {
        //                     var dismissActionPanel = $A.get("e.force:closeQuickAction");
        //                     dismissActionPanel.fire();
        //                }
        //            })
        //        }
        //    }
        // );
        // Find the component whose aura:id is “flowData”
        var flow = component.find('flowData');
        // In that component, start your flow. Reference the flow’s Unique Name.
        flow.startFlow(component.get("v.flowName"));
    },
});
