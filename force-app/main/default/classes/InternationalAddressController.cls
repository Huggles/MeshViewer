/**
 * Created by appsolutely on 16/02/2020.
 */

global with sharing class InternationalAddressController {
    @AuraEnabled(cacheable=true)
    public static PagedResult fetchInternationaAddress(){
        PagedResult result = new PagedResult();
        result.records = InternationalAddressService.internationalAddressSearchV2( 'ESDS', '', '', '','', '', '5658LP', 'Noord-Brabant', 'Netherlands', 'english', 'nl');
    return result;
    }

    @AuraEnabled
    public static Object search(String organization,String building,String street,String houseNumber,String pobox,String locality,String postcode,String province,String country,String language,String country_Format){
        if(country!=null){
            try{
                // List<SearchForDossiersResultDto> searchForDossiers(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search);
               /* Map<String, Object> jsonDeserialized = (Map<String, Object>)JSON.deserializeUntyped(searchParams);
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
                //String domain_name = (String)jsonDeserialized.get('domain');*/
                String countryFormat = 'nl';


                //  public List<SearchForDossiersResultDto> searchForDossiers(String country, String trade_name, String registration_number, String vat_number, String city, String street, String postcode, Integer house_number, String house_number_addition, String province, String telephone_number, String domain_name) {
                //List<SearchForDossiersResultDto> searchResults = BusinessService.searchForDossiers(country, trade_name, registration_number, vat_number, city, street, postcode, house_number, house_number_addition, province, telephone_number, domain_name);
                List<InternationalAddressResultsDto> searchResults = InternationalAddressService.internationalAddressSearchV2( organization, building, street, houseNumber,pobox, locality, postcode, province, country, language, countryFormat);

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

    @AuraEnabled(cacheable=true)
    global static List<appsolutely__Country__mdt> getCountries(){
        return [SELECT developerName, appsolutely__Country_Format__c FROM appsolutely__Country__mdt];
    }

    @AuraEnabled(cacheable=true)
    global static List<appsolutely__International_Address__c> getSearchResults(){
        //List<appsolutely__International_Address_Request__c> lstIAR = ;

        //if(!lstIAR.isEmpty()){
            return [SELECT Id, appsolutely__International_Address_Request__c FROM appsolutely__International_Address__c WHERE appsolutely__International_Address_Request__c IN: [SELECT Id FROM appsolutely__International_Address_Request__c WHERE CreatedBy.ID =: UserInfo.getUserId() ORDER BY createddate DESC LIMIT 1]];
        //}
    }
}