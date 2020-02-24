/**
 * Created by appsolutely on 16/02/2020.
 */

global with sharing class InternationalAddressController {


    @AuraEnabled
    public static Object search(String organization,String building,String street,String houseNumber,String pobox,String locality,String postcode,String province,String country,String language,String country_Format){
        if(country!=null){
            try{
                Map<String, String> mapCountries = new Map<String, String>();
                String countryFormat = 'nl';
                for(appsolutely__Country__mdt countryName : getCountries()){
                    mapCountries.put(countryName.DeveloperName, countryName.appsolutely__Country_Format__c);
                }

                 countryFormat =  mapCountries.get(country);
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

    /*
    @AuraEnabled(cacheable=true)
    global static List<appsolutely__International_Address__c> getSearchResults(){
        List<appsolutely__International_Address__c> lstIAR = [SELECT Id,Name, appsolutely__Organization__c ,appsolutely__Building__c ,appsolutely__Street__c ,appsolutely__House_Number__c ,appsolutely__Locality__c ,appsolutely__POBox__c ,appsolutely__Postcode__c ,appsolutely__Country__c ,appsolutely__International_Address_Request__c   FROM appsolutely__International_Address__c ];

        //if(!lstIAR.isEmpty()){
        System.debug('lstIAR'+lstIAR);
        return lstIAR;

//            return [SELECT Id, appsolutely__Organization__c ,appsolutely__Building__c ,appsolutely__Street__c ,appsolutely__House_Number__c ,appsolutely__Locality__c ,appsolutely__POBox__c ,appsolutely__Postcode__c ,appsolutely__Country__c ,appsolutely__International_Address_Request__c   FROM appsolutely__International_Address__c WHERE appsolutely__International_Address_Request__c IN: [SELECT Id FROM appsolutely__International_Address_Request__c WHERE CreatedBy.ID =: UserInfo.getUserId() ORDER BY createddate DESC LIMIT 1]];
        //}
    }*/

    @AuraEnabled
    global static String createSearchResults(List<appsolutely__International_Address__c> userSelectedAddress){
        if(!userSelectedAddress.isEmpty()){
            try{
                insert  userSelectedAddress;
                return 'Success ';

            } catch (Exception e) {
                ErrorLogUtil.logException(e);

            }
        }
        return 'Error';
    }
}