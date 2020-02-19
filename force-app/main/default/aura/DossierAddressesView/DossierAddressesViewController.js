/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

({
    onInit: function (component, event, helper) {
        component.set('v.columns', [
            {label: 'Type', fieldName: 'appsolutely__Type__c', type: 'text'},
            {label: 'Street', fieldName: 'appsolutely__Street__c', type: 'text'},
            {label: 'House Number', fieldName: 'appsolutely__House_Number__c', type: 'text'},
            {label: 'House Nr. Addition', fieldName: 'appsolutely__House_Number_Addition__c', type: 'text'},
            {label: 'Postal Code', fieldName: 'appsolutely__Postcode__c', type: 'text', },
            {label: 'City', fieldName: 'appsolutely__City__c', type: 'text'},
            {label: 'Country', fieldName: 'appsolutely__Country__c', type: 'text'},
        ]);
        var dossierId = component.get('v.dossierId');
        helper.callServer(component, 'c.getAddresses', {dossierId: dossierId}, function(response) {
            helper.handleSuccessFulLoad(component, response);
        });
    }
});