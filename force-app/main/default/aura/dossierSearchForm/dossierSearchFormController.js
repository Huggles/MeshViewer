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
        // check the input
        var empty = true;
        var components = component.find('searchForm');
        if(components) {
            for (var i = 0; i < components.length; i++) {
                var searchFormComponent = components[i];
                var searchFields = searchFormComponent.get('v.searchFields');
                if (searchFields.country === component.get('v.countryToSearch')) {
                    for (var key in searchFields) {
                        if (searchFields.hasOwnProperty(key)) {
                            if (key != 'country' && searchFields[key] && searchFields != "") {
                                empty = false;
                                break;
                            }
                        }
                    }
                    break;
                }
            }
        }
        if (empty) {
            // TODO: replace by firing an event so a proper error message can be shown
            component.set('v.error', $A.get('$Label.c.Error_Incomplete'));
        } else {
            var updateEvent = component.getEvent("dossierSearchSubmitEvent");
            var searchFields = {};
            var components = component.find('searchForm');
            if(components) {
                for (var i = 0; i < components.length; i++) {
                    var searchFormComponent = components[i];
                    var searchFields = searchFormComponent.get('v.searchFields');
                    if (searchFields.country === component.get('v.countryToSearch')) {
                        break;
                    }
                }
            }
            updateEvent.setParams({ "params": searchFields});
            updateEvent.fire();
        }
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
     * Sets the country in the search params
     * @param component
     * @param event
     * @param helper
     */
    onCountrySearchChange: function(component, event, helper) {
        // Get the string of the "value" attribute on the selected option
        var country = event.getParam("value");
        // set the search country field
        var components = component.find('searchForm');
        if(components) {
            for (var i = 0; i < components.length; i++) {
                var searchFormComponent = components[i];
                var searchFields = searchFormComponent.get('v.searchFields');
                if (!searchFields) {
                    searchFields = {};
                }
                searchFields.country = country;
                searchFormComponent.set('v.searchFields', searchFields);
            }
        }
        component.set('v.countryToSearch', country);
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
            // set the searchFields on the searchFormComponents
            var components = component.find('searchForm');
            if(components) {
                for (var i = 0; i < components.length; i++) {
                    var searchFormComponent = components[i];
                    var searchFields = searchFormComponent.get('v.searchFields');
                    searchFields.name = record.Name;
                    searchFormComponent.set('v.searchFields', searchFields);
                    searchFormComponent.handleChangedAccount(record);
                }
            }
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    doInit: function (component, event, helper) {
        // set the default values in the country picklist
        var options = [
            { value: "NL", label: $A.get("$Label.c.Country_Netherlands") },
            { value: "BE", label: $A.get("$Label.c.Country_Belgium") },
            { value: "SE", label: $A.get("$Label.c.Country_Sweden") },
            { value: "IE", label: $A.get("$Label.c.Country_Ireland") },
            { value: "GB", label: $A.get("$Label.c.Country_United_Kingdom") },
            { value: "DE", label: $A.get("$Label.c.Country_Germany") },
            { value: "FR", label: $A.get("$Label.c.Country_France") }
        ];
        component.set("v.options", options);

        // set the country field on the search fields
        var country = component.find('countrySearch').get('v.value');
        var components = component.find('searchForm');
        if(components) {
            for (var i = 0; i < components.length; i++) {
                var searchFormComponent = components[i];
                var searchFields = searchFormComponent.get('v.searchFields');
                if (!searchFields) {
                    searchFields = {};
                }
                searchFields.country = country;
                searchFormComponent.set('v.searchFields', searchFields);
            }
        }

    },

    
});