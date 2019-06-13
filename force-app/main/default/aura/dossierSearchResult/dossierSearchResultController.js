({
        /**
         * Highlight selected dossier and notify dossierSearchResults component of selection.
         * @param {*} component 
         * @param {*} event 
         * @param {*} helper 
         */
        onClick : function(component, event, helper) {
                var record = component.get("v.result");
                // component.set('v.style', 'slds-tile slds-media selected');
                // component.set('v.variant', 'inverse');
                component.set('v.icon', 'action:approval');
                // Getting the event
                var updateEvent = component.getEvent("dossierSelectedEvent");
                // Setting the param on the event 
                updateEvent.setParams({ "DossierNumber": record.dossier_number });
                updateEvent.setParams({ "EstablishmentNumber": record.establishment_number });
                // Fire the event so all the components can hear it
                updateEvent.fire();
        }
})