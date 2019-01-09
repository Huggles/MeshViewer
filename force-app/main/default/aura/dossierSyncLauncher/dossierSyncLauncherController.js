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
        if (rec.Company_Info_Sync__c === true && rec.Dutch_Business_Dossier__c === null) {
            // component.set('v.displayForm', true);
            var args = { actionName: "Account.Company_Info" };
            actionAPI.invokeAction(args);
        }
        else {
            actionAPI.refresh(); // close quick action is called in dossierDetails component.
        }
    }
})
