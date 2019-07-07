/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

({
    onInit: function (component, event, helper) {
        cmp.set('v.columns', [
            {label: 'Type', fieldName: 'Type__c', type: 'text'},
            {label: 'Street', fieldName: 'Street__c', type: 'text'},
            {label: 'House Number', fieldName: 'House_Number__c', type: 'text'},
            {label: 'House Nr. Addition', fieldName: 'House_Number_Addition__c', type: 'text'},
            {label: 'Postal Code', fieldName: 'Postcode__c', type: 'text', },
            {label: 'City', fieldName: 'City__c', type: 'text'},
            {label: 'Country', fieldName: 'Country__c', type: 'text'},
        ]);
        callServer(component, 'c.getAddresses', {dossierId: component.get('dossierId')}, function(response) {
            helper.handleSuccessFulLoad(component, response);
        });
    }
});