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
        var status = event.getParam("status");
        if (status === "FINISHED") {
            // reload the component
            component.find("accountLoader").reloadRecord(true);
        }
    },
    handleAccountRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            helper.startFlow(component);
        }
    },
    handleDossierRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var dossier = component.get("v.dossier");
            if (!dossier.appsolutely__VAT_Number__c) {
                component.set("v.showVAT", true);
            } else {
                component.set("v.showVAT", false);
            }
        }
    },
    handleErrorChange : function(component, event, helper) {
        var error = component.get('v.error');
        if (error && error != '') {
            helper.showToast(component, $A.get('$Label.c.Error'), error);
        }
    }
});