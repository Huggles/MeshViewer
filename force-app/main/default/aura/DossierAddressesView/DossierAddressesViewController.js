/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

({
    onInit: function (component, event, helper) {
        component.set('v.columns', [
            {label: 'Type', fieldName: 'cust_connect__Type__c', type: 'text'},
            {label: 'Street', fieldName: 'cust_connect__Street__c', type: 'text'},
            {label: 'House Number', fieldName: 'cust_connect__House_Number__c', type: 'text'},
            {label: 'House Nr. Addition', fieldName: 'cust_connect__House_Number_Addition__c', type: 'text'},
            {label: 'Postal Code', fieldName: 'cust_connect__Postcode__c', type: 'text', },
            {label: 'City', fieldName: 'cust_connect__City__c', type: 'text'},
            {label: 'Country', fieldName: 'cust_connect__Country__c', type: 'text'},
        ]);
        var dossierId = component.get('v.dossierId');
        helper.callServer(component, 'c.getAddresses', {dossierId: dossierId}, function(response) {
            helper.handleSuccessFulLoad(component, response);
        });
    }
});