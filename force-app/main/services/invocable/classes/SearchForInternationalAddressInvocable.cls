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

    }

    @InvocableMethod
    global static List<List<International_Address__c>>  searchInternationalAddress(List<SearchInternationalAddressArgument> arguments) {
        try{
            List<List<International_Address__c>> listInternationalAddressesFinal = new List<List<International_Address__c>>();
            List<International_Address__c> listInternationalAddresses = new List<International_Address__c>();
            Integer recordRefNumberCount = 1;
            List<InternationalAddressResultsDto> searchInternationalAddressResultsDtos = new List<InternationalAddressResultsDto>();
            for (SearchInternationalAddressArgument searchInternationalAddressArgument : arguments) {
                searchInternationalAddressResultsDtos.addAll(
                        InternationalAddressService.internationalAddressSearchV2(
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
                                InternationalAddressController.countries.get(searchInternationalAddressArgument.country)
                        )
                );
            }

            for (InternationalAddressResultsDto searchInternationalAddressResultDto : searchInternationalAddressResultsDtos) {
                listInternationalAddresses.add(assignInternationalAddress(searchInternationalAddressResultDto, 'IA00'+recordRefNumberCount));
                recordRefNumberCount = recordRefNumberCount + 1;
            }

            listInternationalAddressesFinal.add(listInternationalAddresses);
            return listInternationalAddressesFinal;
        } catch (Exception e) {
            ErrorLogUtil.logException(e);
        }
        return null;
    }

    private static International_Address__c assignInternationalAddress(InternationalAddressResultsDto searchInternationalAddressResultsDto, String recordRefNumber) {
        International_Address__c interAddress = new International_Address__c();
        interAddress.Organization__c = searchInternationalAddressResultsDto.organization;
        interAddress.Building__c = searchInternationalAddressResultsDto.building;
        interAddress.Street__c = searchInternationalAddressResultsDto.street;
        interAddress.House_Number__c = searchInternationalAddressResultsDto.housenr;
        interAddress.Locality__c = searchInternationalAddressResultsDto.locality;
        interAddress.POBox__c = searchInternationalAddressResultsDto.pobox;
        interAddress.Postcode__c =  searchInternationalAddressResultsDto.postcode;
        interAddress.Country__c = searchInternationalAddressResultsDto.country;
        interAddress.Province__c = searchInternationalAddressResultsDto.province;
        interAddress.Contact__c = searchInternationalAddressResultsDto.contact;
        interAddress.Country_Specific_Locality__c = searchInternationalAddressResultsDto.countryspecific_locality;
        interAddress.Delivery_Address__c = searchInternationalAddressResultsDto.delivery_address;
        interAddress.Department__c = searchInternationalAddressResultsDto.department;
        interAddress.Formatted_Address__c = searchInternationalAddressResultsDto.formatted_address;
        // interAddress.RecordRefNo__c = recordRefNumber;
        return interAddress;
    }

}