({
	onClick : function(component, event, helper) {
        
        var record = component.get("v.result");
        component.set('v.style', 'slds-tile slds-media selected');
        component.set('v.variant', 'inverse');
        component.set('v.icon', 'utility:check');
        // Getting the event
        var updateEvent = component.getEvent("AccountSelect");
        // Setting the param on the event 
        updateEvent.setParams({ "DossierNumber": record.dossier_number });
        // Fire the event so all the components can hear it
        updateEvent.fire();
	}
})