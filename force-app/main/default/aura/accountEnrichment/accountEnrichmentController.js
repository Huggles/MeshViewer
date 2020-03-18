/**
 * Created by jaapbranderhorst on 29/02/2020.
 */

({

    /**
     * Triggered when the status of the flow changes. Reloads the component if the flow is finished.
     * @param component
     * @param event
     * @param helper
     */
    handleFlowChangeEvent : function(component, event) {
        console.log('handleFlowChangeEvent');
        var status = event.getParam("status");
        if (status === "FINISHED") {
            // reload the component
            component.find("accountLoader").reloadRecord(true);
        }
    },
    handleAccountRecordUpdated : function(component, event, helper) {
        console.log('handleAccountRecordUpdated');
        var eventParams = event.getParams();
        if((eventParams.changeType === "LOADED" || eventParams.changeType === "CHANGED") && !component.get("v.accountRecord.appsolutely__Business_Dossier__c")) {
            helper.startFlow(component);
        }
    },
    handleDossierRecordUpdated : function(component, event, helper) {

    },
    handleDossierVATUpdated: function(component, event, helper) {
        console.log('handleDossierVATUpdated');
        component.find('dossierLoader').reloadRecord(true);
    },
    handleErrorChange : function(component, event, helper) {
        console.log('handleErrorChange');
        var error = component.get('v.error');
        if (error && error != '') {
            helper.showToast(component, $A.get('$Label.c.Error'), error);
        }
    },
    handleDossierDeleted : function(component, event, helper) {
        console.log('handleDossierDeleted');
        component.set("v.dossier", null);
        //Reload all data to avoid caching issues.
        component.find('accountLoader').reloadRecord(true);
        component.find('dossierLoader').reloadRecord(true);

        window.location.reload();
    },
});