/**
* Created by appsolutely on 2020-02-11.
* See https://webview.webservices.nl/documentation/files/interfaces/more/services-txt.html
*/


public interface IWsInternationalAddress
{
    InternationalAddressWSDL.InternationalAddressSearchV2Result internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format);
}
