/**
* Created by appsolutely on 2020-02-11.
*/

public inherited sharing class WsInternationalAddress
{
    public static String login(String username,String password){
        return newInstance().login( username, password);
    }
    public static void logout(){
        newInstance().logout();
    }
    public static InternationalAddressWSDL.InternationalAddressSearchV2Result internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format){
        return newInstance().internationalAddressSearchV2( organization, building, street, housenr, pobox, locality, postcode, province, country, language, country_format);
    }
    public static InternationalAddressWSDL.InternationalAddressSearchV2Result internationalAddressSearchInteractive(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format){
        return newInstance().internationalAddressSearchInteractive( organization, building, street, housenr, pobox, locality, postcode, province, country, language, country_format);
    }
    public static IWsInternationalAddress newInstance() {
        return (IWsInternationalAddress)Application.Service.newInstance(IWsInternationalAddress.class);
    }
}
