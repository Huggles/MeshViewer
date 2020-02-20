/**
 * Created by appsolutely on 18/02/2020.
 */

global with sharing class SearchIntenationalAddressInvocable {



    global class SearchInternationalAddressResponse {
        @InvocableVariable(label='Organization' description='Organination Name')
        global String organization;
        @InvocableVariable(label='Building' description='')
        global String building;
        @InvocableVariable(label='POBox' description='')
        global String pobox;
        @InvocableVariable(label='Province' description='')
        global String province;
        @InvocableVariable(label='City' description='City of the address of the business')
        global String city;
        @InvocableVariable(label='Street' description='Street of the address of the business')
        global String street;
        @InvocableVariable(label='Postal Code' description='Postal Code of the address of the business')
        global String postal_code;
        @InvocableVariable(label='House Number' description='Street of the correspondence address of the business')
        global String housenr;
        @InvocableVariable(label='Locality' description='Street of the correspondence address of the business')
        global String locality;
        @InvocableVariable(label='Language' description='Street of the correspondence address of the business')
        global String language;
        @InvocableVariable(label='Country' description='Street of the correspondence address of the business')
        global String country;



        public SearchInternationalAddressResponse(InternationalAddressResultsDto searchInternationalAddressResultsDto) {
            organization = searchInternationalAddressResultsDto.organization;
            building = searchInternationalAddressResultsDto.building;
            pobox = searchInternationalAddressResultsDto.pobox;
            //city = searchInternationalAddressResultsDto.c;
            street = searchInternationalAddressResultsDto.street;
            postal_code = searchInternationalAddressResultsDto.postcode;
            housenr = searchInternationalAddressResultsDto.housenr;
            locality = searchInternationalAddressResultsDto.locality;
            //language = searchInternationalAddressResultsDto.;
            country = searchInternationalAddressResultsDto.country;
        }

    }


    global class SearchInternationalAddressArgument {
        @InvocableVariable(label='Organization' description='Organination Name')
        global String organization;
        @InvocableVariable(label='Building' description='')
        global String building;
        @InvocableVariable(label='POBox' description='')
        global String pobox;
        @InvocableVariable(label='Province' description='')
        global String province;
        @InvocableVariable(label='City' description='City of the address of the business')
        global String city;
        @InvocableVariable(label='Street' description='Street of the address of the business')
        global String street;
        @InvocableVariable(label='Postal Code' description='Postal Code of the address of the business')
        global String postal_code;
        @InvocableVariable(label='House Number' description='Street of the correspondence address of the business')
        global String housenr;
        @InvocableVariable(label='Locality' description='Street of the correspondence address of the business')
        global String locality;
        @InvocableVariable(label='Language' description='Street of the correspondence address of the business')
        global String language;
        @InvocableVariable(label='Country' description='Street of the correspondence address of the business')
        global String country;

    }

    @InvocableMethod
    global static List<List<appsolutely__International_Address__c>> searchInternationalAddress(List<SearchInternationalAddressArgument> arguments) {
        List<List<appsolutely__International_Address__c>> listFinal = new List<List<appsolutely__International_Address__c>>();
        List<appsolutely__International_Address__c> lstInternationalAddresses = new List<appsolutely__International_Address__c>();
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
                            searchInternationalAddressArgument.country
                    )
            );
        }

        appsolutely__International_Address_Request__c interAddReq = new appsolutely__International_Address_Request__c();
        insert interAddReq;

       // if(interAddReq.Id != null) {


            List<SearchInternationalAddressResponse> responses = new List<SearchIntenationalAddressInvocable.SearchInternationalAddressResponse>();

            for (InternationalAddressResultsDto searchInternationalAddressResultDto : searchInternationalAddressResultsDtos) {
                responses.add(new SearchInternationalAddressResponse(searchInternationalAddressResultDto));
                lstInternationalAddresses.add(assignInternationalAddress(searchInternationalAddressResultDto, interAddReq.Id));
            }

       // }
        listFinal.add(lstInternationalAddresses);
        return listFinal;
    //            insert lstInternationalAddresses;
       // return responses;
    }

    public static appsolutely__International_Address__c assignInternationalAddress(InternationalAddressResultsDto searchInternationalAddressResultsDto, Id requestId) {
        appsolutely__International_Address__c interAddress = new appsolutely__International_Address__c();
        interAddress.appsolutely__Organization__c = searchInternationalAddressResultsDto.organization;
        interAddress.appsolutely__Building__c = searchInternationalAddressResultsDto.building;
        interAddress.appsolutely__Street__c = searchInternationalAddressResultsDto.pobox;
        interAddress.appsolutely__House_Number__c = searchInternationalAddressResultsDto.housenr;
        interAddress.appsolutely__Locality__c = searchInternationalAddressResultsDto.locality;
        interAddress.appsolutely__POBox__c = searchInternationalAddressResultsDto.pobox;
        interAddress.appsolutely__Postcode__c =  searchInternationalAddressResultsDto.postcode;
        interAddress.appsolutely__Country__c = searchInternationalAddressResultsDto.country;
        interAddress.appsolutely__International_Address_Request__c = requestId;
        //interAddress.appsolutely__Language__c;
        return interAddress;
    }

}