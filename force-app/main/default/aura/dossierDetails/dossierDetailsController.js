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
        // TODO: check why the account Id is missing from the params
        var callParams = {dossierNumber: params.DossierNumber,
            establishmentNumber: params.EstablishmentNumber,
            vendor: params.selectedDataVendor,
            creditSafeId: params.creditSafeId,
            accountId: component.get('v.recordId')};
        // TODO: does this work with CreditSafe?
        // and is it necessary even?
        component.set('v.selected', params.DossierNumber);
        helper.callServer(component, 'c.createDossier', callParams, function(response) {
            helper.handleCompanyData(component, response);
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
        var callParams = {dossierId: component.get('v.simpleRecord').appsolutely__Business_Dossier__c};
        helper.callServer(component, 'c.getVATDetails', callParams, function(response) {
            if (response && response.appsolutely__VAT_Number__c !== undefined)
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
    },
    /**
     * Handles a change of the error attribute. If the error attribute is not empty shows a toast with the error message.
     * When setting the error message take into account multi-linguality!
     * @param component
     * @param event
     * @param helper
     */
    onErrorChange : function (component, event, helper) {
        console.log('in on error change');
        var error = component.get('v.error');
        console.log('error');
        if (error && error != '') {
            helper.showToast(component, $A.get('$Label.c.Error'), error);
        }
    }
});