/**
 * Created by appsolutely on 14/02/2020.
 */

public interface IInternationalAddressService {
    String login(String username,String password);
    void logout();
    List<InternationalAddressResultsDto> internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format);
    List<InternationalAddressResultsDto> internationalAddressSearchInteractive(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format);
    void insertInternationalAddress(List<appsolutely__International_Address__c> insertAddress);

}