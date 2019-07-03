({
    /**
     * Ignore search params if dossier number populated. 
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    populateDossier: function (component, event, helper) {
        var fields = component.get('v.searchFields');
        if (fields.dossier_number != null && fields.dossier_number != '') {
            component.set('v.disableSearch', true);
        }
        else component.set('v.disableSearch', false);
    },
    /**
     * Fire search event to dossierDetails component
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onSearchSubmit: function( component, event, helper ) {
        var updateEvent = component.getEvent("dossierSearchSubmitEvent");
        updateEvent.setParams({ "params": component.get('v.searchFields')});
        updateEvent.fire();
    },
    /**
     * Bypass search and attempt retrieve. Fire dossier number to dossierDetails component.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onMatchDossier: function( component, event, helper ) {
        // Getting the event
        var updateEvent = component.getEvent("dossierSelectionConfirmedEvent");
        // Setting the param on the event 
        var fields = component.get('v.searchFields');
        updateEvent.setParams({ "DossierNumber": fields.dossier_number });
        // Fire the event so all the components can hear it
        updateEvent.fire();
    },
    onCountrySearchChange: function(component, event, helper) {
        // Get the string of the "value" attribute on the selected option
        var selectedOptionValue = event.getParam("value");
        component.set('v.searchForm', selectedOptionValue);
    }

    
});