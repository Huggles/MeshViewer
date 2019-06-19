({
    /**
     * Search event triggered. Retrieve list of matching dossiers from apex
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
	onSubmit : function(component, event, helper) {
        var params = event.getParam("params");

        helper.callServer(component, 'c.search', {searchParams: JSON.stringify(params)}, function(response) {
            helper.handleSearchResults(component, response);
        });
    },
    /**
     * Select dossier event triggered. Get dossier from API, check if the dossier already exists in the DB and if not save to sObject.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onSelect : function(component, event, helper) {
        var params = event.getParams();
        var callParams = {dossierNumber: params.DossierNumber, establishmentNumber: params.EstablishmentNumber};
        component.set('v.selected', params.DossierNumber);
        helper.callServer(component, 'c.checkDossier', callParams, function (response) {
            if (!response.result) { // no dossier found
                if (component.get('v.recordId'))
                    callParams.accountId = component.get('v.recordId');
                helper.callServer(component, 'c.createDossier', callParams, function(response) {
                    helper.handleCompanyData(component, response);
                })
            } else {
                helper.showToast(component, $A.get('$Label.c.Success'), $A.get('$Label.c.Business_Data_Exists'), 'success');
            }
        });
    },
    /**
     * Decrement step to allow another search to take place
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onBack : function (component, event, helper) {
        component.set('v.step', '1');
    },

    /**
     * Unlink dossier and delete associated record(s)
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    removeDossier : function (component, event, helper) {
        var callParams = {recordId: component.get('v.recordId')};
        helper.callServer(component, 'c.deleteDossier', callParams, function(response) {
            if (response === true)
                helper.showToast(component, $A.get('$Label.c.Success'), $A.get('$Label.c.Dossier_Removed'), 'success');
            else 
                helper.showToast(component, $A.get('$Label.c.Error'), $A.get('$Label.c.Error_Remove_Dossier'), 'error');
            component.find('recordHandler').reloadRecord(true);
        });
        
    },

    /**
     * Unlink dossier and delete associated record(s)
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    getVAT : function (component, event, helper) {
        var callParams = {dossierId: component.get('v.simpleRecord').cust_connect__Business_Dossier__c};
        helper.callServer(component, 'c.getVATDetails', callParams, function(response) {
            if (response && response.cust_connect__VAT_Number__c !== undefined)
                helper.showToast(component, $A.get('$Label.c.Success'), $A.get('$Label.c.Dossier_Account_Update_Completed'), 'success');
            else {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    _this.formattedToast(component, errors[0].message);
                } else {
                    _this.showToast(component, $A.get('$Label.c.Error'), $A.get('$Label.c.Error_Unknown'), 'error');
                }
            }
            component.find('recordHandler').reloadRecord(true);
        });
        
    }
})