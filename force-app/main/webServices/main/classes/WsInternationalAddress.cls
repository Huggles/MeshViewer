/**
* Created by appsolutely on 2020-02-11.
*/

public inherited sharing class WsInternationalAddress
{

    public static InternationalAddressWSDL.InternationalAddressSearchV2Result internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format){
        return newInstance().internationalAddressSearchV2( organization, building, street, housenr, pobox, locality, postcode, province, country, language, country_format);
    }

    public static IWsInternationalAddress newInstance() {
        return (IWsInternationalAddress)Application.Service.newInstance(IWsInternationalAddress.class);
    }
}
