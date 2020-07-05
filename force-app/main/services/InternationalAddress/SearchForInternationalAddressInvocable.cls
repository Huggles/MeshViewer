/**
 * Created by appsolutely on 18/02/2020.
 */

global inherited sharing class SearchForInternationalAddressInvocable {

    global inherited sharing class SearchInternationalAddressArgument {
        @InvocableVariable(label='Organization' description='Name of the company or organisation at the address')
        global String organization;
        @InvocableVariable(label='Building' description='Building or sub-building name')
        global String building;
        @InvocableVariable(label='POBox' description='PO box search phrase')
        global String pobox;
        @InvocableVariable(label='Province' description='Province search phrase')
        global String province;
        @InvocableVariable(label='Street' description='Street search phrase')
        global String street;
        @InvocableVariable(label='Postal Code' description='Postalcode search phrase')
        global String postal_code;
        @InvocableVariable(label='House Number' description='House number search phrase')
        global String housenr;
        @InvocableVariable(label='Locality' description='District or municipality search phrase')
        global String locality;
        @InvocableVariable(label='Language' description='Language in which the results are returned')
        global String language;
        @InvocableVariable(label='Country' description='Country of the address')
        global String country;
        @InvocableVariable(label='Country Format' description='The format in which the country is returned.')
        global String countryFormat;
        @TestVisible
        private SearchInternationalAddressArgument(String organization, String building, String POBox, String province, String street, String postCode,
                String houseNr, String locality, String country, String language, String countryFormat) {
            this.organization = organization;
            this.building = building;
            this.pobox = POBox;
            this.province = province;
            this.street = street;
            this.postal_code = postCode;
            this.housenr = housenr;
            this.locality = locality;
            this.language = language;
            this.country = country;
            this.countryFormat = countryFormat;
        }

        public SearchInternationalAddressArgument() {}

    }

    @InvocableMethod(label = 'Search and complete for international addresses'
            description='Searches and completes/corrects international addresses.'
            category='Company.info')
    global static List<List<International_Address__c>>  searchInternationalAddress(List<SearchInternationalAddressArgument> arguments) {
        try {
            List<List<International_Address__c>> listInternationalAddresses2 = new List<List<International_Address__c>>();

            for (SearchInternationalAddressArgument searchInternationalAddressArgument : arguments) {
                listInternationalAddresses2.add(InternationalAddressService.internationalAddressSearchV2(
                        searchInternationalAddressArgument.organization,
                        searchInternationalAddressArgument.building,
                        searchInternationalAddressArgument.street,
                        searchInternationalAddressArgument.housenr,
                        searchInternationalAddressArgument.pobox,
                        searchInternationalAddressArgument.locality,
                        searchInternationalAddressArgument.postal_code,
                        searchInternationalAddressArgument.province,
                        searchInternationalAddressArgument.country,
                        searchInternationalAddressArgument.language,
                        searchInternationalAddressArgument.countryFormat
                ));
            }
            return listInternationalAddresses2;
        } catch (Exception e) {
            ErrorLogUtil.logException(e);
            throw e;
        }
    }
}