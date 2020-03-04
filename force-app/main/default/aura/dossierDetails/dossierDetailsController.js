({
    doInit : function(component, event, helper) {
        debugger;
       var flow = component.find("v.flowContainer");
       var recId = component.get("v.recordId");
       var arguments;
       if (recId) {
           arguments = [{
               name: 'recordId',
               type: 'String',
               value: recId
           }]
       }
       //flow.startFlow('')

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