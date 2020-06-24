/**
 * Created by tejaswinidandi on 24/06/2020.
 */

global inherited sharing class SearchForAddressInvocable {

    global inherited sharing class SearchAddressArgument {
        @InvocableVariable(label='Organization' description='Name of the company or organisation at the address')
        global String organization;
        @InvocableVariable(label='Province' description='Province search phrase')
        global String province;
        @InvocableVariable(label='Street' description='Street search phrase')
        global String street;
        @InvocableVariable(label='Postal Code' description='Postalcode search phrase')
        global String postal_code;
        @InvocableVariable(label='House Number' description='House number search phrase')
        global String housenr;
        @InvocableVariable(label='House Number Addition' description='House number addition search phrase')
        global String housenrAddition;
        @InvocableVariable(label='Locality' description='District or municipality search phrase')
        global String locality;
        @InvocableVariable(label='Municipality' description='Municipality search phrase')
        global String municipality;
        @InvocableVariable(label='Letter Combination' description='Postcode letter combination search phrase')
        global String lettercombination;
        @InvocableVariable(label='Address Type' description='Even/Odd house number range')
        global String addresstype;

        @TestVisible
        private SearchAddressArgument(String organization, String building, String POBox, String province, String street, String postCode,
                String houseNr, String locality, String country, String language, String countryFormat, String municipality, String housenrAddition, String lettercombination, String addresstype) {
            this.organization = organization;
            this.province = province;
            this.street = street;
            this.postal_code = postCode;
            this.housenr = housenr;
            this.locality = locality;
            this.municipality = municipality;
            this.housenrAddition = housenrAddition;
            this.lettercombination = lettercombination;
            this.addresstype = addresstype;
        }

        public SearchAddressArgument() {}


    }

    @InvocableMethod(label = 'Search and complete dutch addresses'
            description='Searches and completes/corrects dutch addresses.'
            category='Company.info')
    global static List<List<International_Address__c>>  SearchAddress(List<SearchAddressArgument> arguments) {
        try {
            List<List<International_Address__c>> listInternationalAddresses2 = new List<List<International_Address__c>>();

            for (SearchAddressArgument SearchAddressArgument : arguments) {
                Integer houseNumber = String.isNotEmpty(SearchAddressArgument.housenr) ? Integer.valueOf(SearchAddressArgument.housenr) : null;
                listInternationalAddresses2.add(AddressService.dutchAddressSearch(
                        SearchAddressArgument.organization,
                        SearchAddressArgument.province,
                        SearchAddressArgument.municipality,//district
                        SearchAddressArgument.locality,//city
                        SearchAddressArgument.street,
                        houseNumber,
                        SearchAddressArgument.housenrAddition,
                        SearchAddressArgument.postal_code,//nbcode
                        SearchAddressArgument.lettercombination,
                        SearchAddressArgument.addresstype
                ));
            }
            return listInternationalAddresses2;
        } catch (Exception e) {
            ErrorLogUtil.logException(e);
            throw e;
        }
    }
}