({
    doInit: function (cmp, event, helper) {
        var searchFields = {
            street: '',
            city: '',
            postcode: '',
            country: '',
            province: '',
            name: '',
            phone: '',
            domain: ''
        }
        cmp.set('v.searchFields', searchFields);


    },
    /**
     * Ignore search params if dossier number populated. 
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    populateDossier: function (component, event, helper) {
        var fields = component.get('v.searchFields');
        if (fields.dossier_number != null && fields.dossier_number != '') {
            //component.set('v.disableSearch', true);
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
    /**
     * Populate search fields with data from current Account record.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           // record is loaded (render other component which needs record data value)
            var record = component.get('v.simpleRecord');
            var searchFields = {
                street: record.BillingStreet,
                city: record.BillingCity,
                postcode: record.BillingPostalCode,
                country: record.BillingCountry,
                province: record.BillingState,
                name: record.Name,
                phone: record.Phone,
                domain: record.Website
            }
            component.set('v.searchFields', searchFields);
            
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    }
    
})