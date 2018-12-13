({
	onClick : function(component, event, helper) {
        
		var DossierNumber = component.get("v.DossierNumber");
        
        // Getting the event
        var updateEvent = component.getEvent("AccountSelect");
        
        // Setting the param on the event 
        updateEvent.setParams({ "DossierNumber": {
            "DossierNumber" : DossierNumber
            }
        });
            
        // Fire the event so all the components can hear it
        updateEvent.fire();
	}
})