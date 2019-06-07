({
    doInit : function(component, event, helper) {
        $A.createComponent("c:dossierDetails", {},
           function(content, status) {
               if (status === "SUCCESS") {
                   component.find('overlayLib').showCustomModal({
                       header: $A.get("$Label.c.New_Account_CC"),
                       body: content, 
                       showCloseButton: true,
                       closeCallback: function() {
                            var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            dismissActionPanel.fire();
                       }
                   })
               }                               
           }
        );
    }
})
