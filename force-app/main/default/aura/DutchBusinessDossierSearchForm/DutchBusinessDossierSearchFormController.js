/**
 * Created by jaapbranderhorst on 2019-07-03.
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
        searchFields.house_number_addition = '';
        searchFields.postal_code = '';
        searchFields.name = '';
        searchFields.phone = '';
        searchFields.domain = '';
        searchFields.dossier_number = '';
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
                searchFields.domain = account.Website;
                searchFields.phone = account.Phone;
                component.set('v.searchFields', searchFields);
            }
        }
    }
});