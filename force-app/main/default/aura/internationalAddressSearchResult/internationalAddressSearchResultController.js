/**
 * Created by appsolutely on 17/02/2020.
 */

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
        updateEvent.setParams({ "selectedDataVendor": record.vendor});
        updateEvent.setParams({ "street": record.street });
        updateEvent.setParams({ "delivery_address": record.delivery_address });
        updateEvent.setParams({ "countryspecific_locality": record.countryspecific_locality});
        // Fire the event so all the components can hear it
        updateEvent.fire();
    }
});