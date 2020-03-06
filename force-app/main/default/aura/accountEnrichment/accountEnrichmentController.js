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
        if((eventParams.changeType === "LOADED" || eventParams.changeType === "CHANGED") && !component.get("v.accountRecord.appsolutely__Business_Dossier__c")) {
            helper.startFlow(component);
        }
    },
    handleDossierRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var dossier = component.get("v.dossier");
            if (!dossier.appsolutely__VAT_Number__c && !dossier.appsolutely__No_VAT__c) {
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
    },
    handleDossierDeleted : function(component, event, helper) {
        component.set("v.accountRecord.appsolutely__Business_Dossier__c", null);
    },
    getVAT : function(component, event, helper) {
        var callParams = {dossierId: component.get('v.accountRecord').appsolutely__Business_Dossier__c};
        helper.callServer(component, 'c.updateDossierWithVAT', callParams, function(response) {
            if (response && (response.appsolutely__VAT_Number__c !== undefined || response.appsolutely__No_VAT_Number__c)) {
                if (response.appsolutely__VAT_Number__c !== undefined) {
                    helper.showToast(component, $A.get('$Label.c.Success'), $A.get('$Label.c.Dossier_Account_Update_Completed'), 'success');
                } else {
                    helper.showToast(component, $A.get('$Label.c.Success'), $A.get('$Label.c.VAT_Not_Found'));
                }
            }
            else {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    helper.showToast(component, $A.get('$Label.c.Error'), errors[0].message, 'error');
                } else {
                    helper.showToast(component, $A.get('$Label.c.Error'), $A.get('$Label.c.Error_Unknown'), 'error');
                }
            }
            component.find('dossierLoader').reloadRecord(true);
        });
    }
});