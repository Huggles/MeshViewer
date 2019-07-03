/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

({
    doInit: function (cmp, event, helper) {
        var searchFields = {
            street: '',
            house_number: '',
            house_number_addition: '',
            city: '',
            postal_code: '',
            name: '',
            phone: '',
            domain: '',
            dossier_number: ''
        };
        cmp.set('v.searchFields', searchFields);
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
                city: record.BillingCity,
                postal_code: record.BillingPostalCode,
                name: record.Name,
                phone: record.Phone,
                domain: record.Website
            };
            component.set('v.searchFields', searchFields);

        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    }
});