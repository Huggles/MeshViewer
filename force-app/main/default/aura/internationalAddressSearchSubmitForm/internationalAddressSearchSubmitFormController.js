/**
 * Created by appsolutely on 17/02/2020.
 */

({
    doInit: function (component, event, helper) {
            var searchFields = component.get('v.searchFields');
        if (!searchFields) {
            searchFields = {};
        }
        searchFields.organization = '';
        searchFields.building = '';
        searchFields.street = '';
        searchFields.city = '';
        searchFields.housenr = '';
        searchFields.pobox = '';
        searchFields.locality = '';
        searchFields.postcode = '';
        searchFields.province = '';
        searchFields.country = '';
        searchFields.language = '';
        searchFields.country_format = '';
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