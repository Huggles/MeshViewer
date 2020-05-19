/**
 * Created by appsolutely on 14/02/2020.
 */

public interface IInternationalAddressService {

    List<International_Address__c> internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format);

    /**
     * Deletes the international address with the given id with all related objects
     *
     * @param internationalAddressId
     * @param checkPermissions true if permissions need to be checked
     *
     */
    void deleteInternationalAddress(Id internationalAddressId, Boolean checkPermissions);
}