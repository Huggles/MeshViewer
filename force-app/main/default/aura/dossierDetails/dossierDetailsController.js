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
    }
})