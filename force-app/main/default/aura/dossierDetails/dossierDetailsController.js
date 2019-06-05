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
     * Select dossier event triggered. Get dossier from API and save to sObject.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onSelect : function(component, event, helper) {
        var params = event.getParams();
        var callParams = {dossierNumber: params.DossierNumber};
        if (component.get('v.recordId'))
            callParams.accountId = component.get('v.recordId');
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
                helper.showToast(component, $A.get('$Label.c.BDS_Success'), $A.get('$Label.c.Dossier_Removed'), 'success');
            else 
                helper.showToast(component, $A.get('$Label.c.BDS_Error'), $A.get('$Label.c.Error_Remove_Dossier'), 'success');
            component.find('recordHandler').reloadRecord(true);
        });
        
    }
})