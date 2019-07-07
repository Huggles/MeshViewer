({
    /**
     * Set selected value from dossierSearchResult event.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onSelect : function(component, event, helper) {
        var params = event.getParams();
        console.log(JSON.stringify(params));
        component.set('v.selected', params.DossierNumber);
        component.set('v.selectedEstablishment', params.EstablishmentNumber);
        component.set('v.selectedDataVendor', params.selectedDataVendor);
        component.set('v.selectedCreditSafeId', params.creditSafeId);
        var results = component.find('searchResult');
        for (var i = 0; i < results.length; i++) {
            if (results[i].get('v.result').dossier_number !== params.DossierNumber || results[i].get('v.result').establishment_number !== params.EstablishmentNumber) {
                results[i].set('v.icon', 'action:record');
            }
        }
    },
    /**
     * Fire dossier number to dossierDetails component to confirm selection.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onConfirm : function(component, event, helper) {
        // Getting the event
        var updateEvent = component.getEvent("dossierSelectionConfirmedEvent");
        // Setting the param on the event 
        updateEvent.setParams({ "DossierNumber": component.get('v.selected'), "EstablishmentNumber": component.get('v.selectedEstablishment'), "selectedDataVendor": component.get('v.selectedDataVendor') , "creditSafeNumber": component.get('v.selectedCreditSafeId') });
        // Fire the event so all the components can hear it
        updateEvent.fire();
    }

});