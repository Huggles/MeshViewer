/**
 * Created by appsolutely on 14/02/2020.
 */

public inherited sharing class InternationalAddressService {

    public static String login(String username,String password){
        return newInstance().login( username, password);
    }
    public static void logout(){
        newInstance().logout();
    }
    public static List<InternationalAddressResultsDto> internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format){
        return newInstance().internationalAddressSearchV2( organization, building, street, housenr, pobox, locality, postcode, province, country, language, country_format);
    }
    public static List<InternationalAddressResultsDto> internationalAddressSearchInteractive(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format){
        return newInstance().internationalAddressSearchInteractive( organization, building, street, housenr, pobox, locality, postcode, province, country, language, country_format);
    }
    public static IInternationalAddressService newInstance() {
        return (IInternationalAddressService)Application.Service.newInstance(IInternationalAddressService.class);
    }
}