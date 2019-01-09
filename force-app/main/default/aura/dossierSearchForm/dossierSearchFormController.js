({
    onSearchSubmit: function( component, event, helper ) {
        var updateEvent = component.getEvent("dossierSearchSubmitEvent");
        updateEvent.setParams({ "params": component.get('v.searchFields')});
        updateEvent.fire();
    },
    handleChange: function(component,event,helper){
        component.set("v.SelectedAPI", component.find("levels").get("v.value"));
    },
    changeState : function changeState (component){ 
        component.set('v.isexpanded',component.get('v.isexpanded'));
    },
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