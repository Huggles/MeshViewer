/**
 * Created by appsolutely on 16/02/2020.
 */

public with sharing class InternationalAddressResultsDto {
    @AuraEnabled public String vendor { get; set; }
    @AuraEnabled public Double matchrate { get; set; }
    @AuraEnabled public String street {get; set; }
    @AuraEnabled public String housenr { get; set; } // chamber of commerce number
    @AuraEnabled public String pobox { get; set; }
    @AuraEnabled public String locality { get; set; }
    @AuraEnabled public String postcode { get; set; }
    @AuraEnabled public String province { get; set; }
    @AuraEnabled public String country { get; set; }
    @AuraEnabled public String countryspecific_locality { get; set; }
    @AuraEnabled public String delivery_address { get; set; }
    @AuraEnabled public String formatted_address { get; set; }
    @AuraEnabled public String organization {get; set;}
    @AuraEnabled public String department { get; set; }
    @AuraEnabled public String contact { get; set; }
    @AuraEnabled public String building { get; set; }

    public InternationalAddressResultsDto(InternationalAddressWSDL.InternationalV2 searchV2Result) {
        vendor = CustomerConnect.DataVendor.COMPANY_INFO.name();
        matchrate = searchV2Result.address.matchrate;
        street = searchV2Result.address.street;
        housenr = searchV2Result.address.housenr;
        pobox = searchV2Result.address.pobox;
        locality = searchV2Result.address.locality;
        postcode = searchV2Result.address.postcode;
        province = searchV2Result.address.province;
        country = searchV2Result.address.country;
        countryspecific_locality = searchV2Result.address.countryspecific_locality;
        delivery_address = searchV2Result.address.delivery_address;
        formatted_address = searchV2Result.address.formatted_address;
        organization = searchV2Result.address.organization;
        department = searchV2Result.address.department;
        contact = searchV2Result.address.contact;
    }
}