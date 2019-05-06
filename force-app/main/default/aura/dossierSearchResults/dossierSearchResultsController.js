({
    /**
     * Set selected value from dossierSearchResult event.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onSelect : function(component, event, helper) {
        var params = event.getParams();
        component.set('v.selected', params.DossierNumber);
        var results = component.find('searchResult');
        for (var i = 0; i < results.length; i++) {
            if (results[i].get('v.result').dossier_number !== params.DossierNumber) {
                results[i].set('v.icon', 'action:new');
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
        updateEvent.setParams({ "DossierNumber": component.get('v.selected') });
        // Fire the event so all the components can hear it
        console.log('firing dossierSelectionConfirmedEvent');
        updateEvent.fire();
    }

})