/**
 * Created by appsolutely on 16/02/2020.
 */

public with sharing class InternationalAddressController {
    @AuraEnabled(cacheable=true)
    public static PagedResult fetchInternationaAddress(){
        PagedResult result = new PagedResult();
        result.records = InternationalAddressService.internationalAddressSearchV2( 'ESDS', '', '', '','', '', '5658LP', 'Noord-Brabant', 'Netherlands', 'english', 'nl');
    return result;
    }

    @AuraEnabled
    public static Object search(String searchParams){
        if(searchParams!=null){
            try{
                // List<SearchForDossiersResultDto> searchForDossiers(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search);
                Map<String, Object> jsonDeserialized = (Map<String, Object>)JSON.deserializeUntyped(searchParams);
                String country = (String)jsonDeserialized.get('country');
                String building = (String)jsonDeserialized.get('building');
                String pobox = (String)jsonDeserialized.get('pobox');
                String province = (String)jsonDeserialized.get('province');
                String organization = (String)jsonDeserialized.get('organization');
                String city = (String)jsonDeserialized.get('city');
                String street = (String)jsonDeserialized.get('street');
                String postcode = (String)jsonDeserialized.get('postal_code');
                //Integer house_number = null;
                String houseNumberString = (String)jsonDeserialized.get('housenr');
                if (!String.isEmpty(houseNumberString) && houseNumberString.isNumeric()) {
                  //  house_number = Integer.valueOf(houseNumberString);
                }
                String locality = (String)jsonDeserialized.get('locality');
                String language = (String)jsonDeserialized.get('language');
                //String domain_name = (String)jsonDeserialized.get('domain');


                //  public List<SearchForDossiersResultDto> searchForDossiers(String country, String trade_name, String registration_number, String vat_number, String city, String street, String postcode, Integer house_number, String house_number_addition, String province, String telephone_number, String domain_name) {
                //List<SearchForDossiersResultDto> searchResults = BusinessService.searchForDossiers(country, trade_name, registration_number, vat_number, city, street, postcode, house_number, house_number_addition, province, telephone_number, domain_name);
                List<InternationalAddressResultsDto> searchResults = InternationalAddressService.internationalAddressSearchV2( organization, building, street, houseNumberString,pobox, locality, postcode, province, country, language, country);

                return new AuraResponseWrapper(searchResults);
            } catch (CCException e) {
                return new AuraResponseWrapper(e);
            } catch (Exception e) {
                ErrorLogUtil.logException(e);
                return new AuraResponseWrapper(e, System.Label.Error);
            }
        }
        return null;
    }
}