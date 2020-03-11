/**
 * Created by appsolutely on 16/02/2020.
 */

global inherited sharing class InternationalAddressController {

    public static Map<String,String> countries{
        get{
            if(countries == null){
                countries = getCountriesFromPicklist();
            }
            return countries;
        }
        set;
    }

    @AuraEnabled
    public static Object search(String organization,String building,String street,String houseNumber,String pobox,String locality,String postcode,String province,String country,String language,String country_Format){
        if(country!=null){
            try{
                String countryFormat =  countries.get(country);
                 List<InternationalAddressResultsDto> searchResults = InternationalAddressService.internationalAddressSearchV2( organization, building, street, houseNumber,pobox, locality, postcode, province, country, language, country_Format);

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
    global static List<String> getCountries(){
        return new List<String>(countries.keySet());
    }

    @AuraEnabled
    global static String createSearchResults(List<International_Address__c> userSelectedAddress){
        if(!userSelectedAddress.isEmpty()){
            try{
                InternationalAddressService.insertInternationalAddress(userSelectedAddress);
                return 'Success ';

            } catch (Exception e) {
                ErrorLogUtil.logException(e);

            }
        }
        return 'Error';
    }

    private static Map<String,String> getCountriesFromPicklist() {
        Map<String,String> countries = new Map<String, String>();

        Schema.SObjectField countriesPicklist = SObjectType.Business_Dossier__c.fields.Registration_Country__c.getSobjectField();//TODO check if this picklist is ok, or create another picklist
        List<PicklistEntry> entries = countriesPicklist.getDescribe().getPicklistValues();

        for (Schema.PicklistEntry pickListVal : entries) {
           countries.put(pickListVal.getLabel(), pickListVal.getValue());
        }

        return countries;
    }
}