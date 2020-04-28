/**
 * Created by appsolutely on 14/02/2020.
 */

public inherited sharing class InternationalAddressService {

    public static List<International_Address__c> internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format){
        return newInstance().internationalAddressSearchV2( organization, building, street, housenr, pobox, locality, postcode, province, country, language, country_format);
    }
    public static IInternationalAddressService newInstance() {
        return (IInternationalAddressService)Application.Service.newInstance(IInternationalAddressService.class);
    }
    public static void deleteInternationalAddress(Id internationalAddressId, Boolean checkPermissions) {
        newInstance().deleteInternationalAddress(internationalAddressId, checkPermissions);
    }
}