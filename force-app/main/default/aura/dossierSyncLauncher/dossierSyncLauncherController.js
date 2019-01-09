({
    display : function(component, event, helper) {
        var rec = component.get('v.simpleRecord');
        if (rec.Company_Info_Sync__c === true && rec.Dutch_Business_Dossier__c === null) {
            component.set('v.displayForm', true);
        }
        else {
            component.set('v.displayForm', false);
        }
    },
    hideModal : function(component, event, helper) {
        component.set('v.displayForm', false);
    }
})
