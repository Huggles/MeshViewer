/**
 * Created by appsolutely on 17/02/2020.
 */

({
    doInit : function(component, event, helper) {
        $A.createComponent("c:internationalAddressDetails", {},
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
});
