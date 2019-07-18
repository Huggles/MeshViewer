/**
 * Created by jaapbranderhorst on 2019-07-04.
 */

({
    doInit: function (component, event, helper) {
        var searchFields = component.get('v.searchFields');
        if (!searchFields) {
            searchFields = {};
        }
        searchFields.street = '';
        searchFields.city = '';
        searchFields.house_number = '';
        searchFields.registration_number = '';
        searchFields.vat_number = '';
        searchFields.name = '';
        searchFields.province = '';
        searchFields.postal_code = '';
        component.set('v.searchFields', searchFields);
    },
    handleChangedAccount: function (component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var account = params.account;
            if (account) {
                var searchFields = component.get('v.searchFields');
                if (!searchFields) {
                    searchFields = {};
                }
                searchFields.city = account.BillingCity;
                searchFields.postal_code = account.BillingPostalCode;
                component.set('v.searchFields', searchFields);
            }
        }
    }
});