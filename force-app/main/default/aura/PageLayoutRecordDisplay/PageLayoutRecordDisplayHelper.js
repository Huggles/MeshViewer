({
	retrievePageLayout : function(component, helper) {
		var action = component.get("c.getPageLayoutMetadata");
        var pageLayoutName = component.get("v.PageLayoutName");
        var objName = component.get("v.objectApiName");
        
        var actionParams = {
            "pageLayoutName" : pageLayoutName,
            "objectName" : objName
        };
        
        action.setParams(actionParams);
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var pageLayout = response.getReturnValue();
                
                component.set("v.PageLayout", pageLayout);
            }
        });
        
        $A.enqueueAction(action);
	}
});