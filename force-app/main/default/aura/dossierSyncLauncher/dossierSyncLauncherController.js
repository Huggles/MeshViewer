({
    /**
     * Launch dossierDetails component as quick action if company info sync requested but not yet complete.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    display : function(component, event, helper) {
        var rec = component.get('v.simpleRecord');
        var actionAPI = component.find("quickActionAPI");
        if (rec && rec.cinfo_sales__CC_Sync__c === true && rec.cinfo_sales__Business_Dossier__c === null) {
            // component.set('v.displayForm', true);
            var args = { actionName: "Account.cinfo_sales__Company_Info" };
            actionAPI.invokeAction(args);
        }
        else {
            actionAPI.refresh(); // close quick action is called in dossierDetails component.
        }
    }
})
