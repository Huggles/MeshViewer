({
    onSelect : function(component, event, helper) {
        var params = event.getParams();
        component.set('v.selected', params.DossierNumber);
    },
    onConfirm : function(component, event, helper) {
        // Getting the event
        var updateEvent = component.getEvent("AccountSelected");
        // Setting the param on the event 
        updateEvent.setParams({ "DossierNumber": component.get('v.selected') });
        // Fire the event so all the components can hear it
        updateEvent.fire();
    }

})