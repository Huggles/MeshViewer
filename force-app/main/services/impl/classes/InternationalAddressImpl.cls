/**
 * Created by appsolutely on 14/02/2020.
 */

public inherited sharing class InternationalAddressImpl implements IInternationalAddressService{

    public List<International_Address__c> internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format) {

        // check and complete the input
        if (String.isEmpty(country)) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }
        if (String.isEmpty(language)) {
            language = 'database';
        }
        if (String.isEmpty(country_format)) {
            country_format = 'en';
        }

        InternationalAddressWSDL.InternationalAddressSearchV2Result userSearchResult = WsInternationalAddress.internationalAddressSearchV2(organization, building, street, housenr, pobox, locality, postcode, province, country, language, country_format);

        List<International_Address__c> resultArray = new List<International_Address__c>();
        if (userSearchResult != null && userSearchResult.result != null && userSearchResult.result.item != null) {
            for (InternationalAddressWSDL.InternationalV2 resultItem : userSearchResult.result.item) {
                resultArray.add(mapInternationalV2ToInternationalAddress(resultItem));
            }
        }

        return resultArray;
    }

    private International_Address__c mapInternationalV2ToInternationalAddress(InternationalAddressWsdl.InternationalV2 wsAddress) {
        International_Address__c address = new International_Address__c();
        // map the address fields
        if (wsAddress.address != null) {
            address.Matchrate__c = wsAddress.address.matchrate;
            address.Street__c = wsAddress.address.street;
            address.Country__c = wsAddress.address.country;
            address.Building__c = wsAddress.address.building;
            address.Contact__c = wsAddress.address.contact;
            address.Country_Specific_Locality__c = wsAddress.address.countryspecific_locality;
            address.Delivery_Address__c = wsAddress.address.delivery_address;
            address.Formatted_Address__c = wsAddress.address.formatted_address;
            address.House_Number__c = wsAddress.address.housenr;
            //address.Language__c = wsAddress.address.
            address.Locality__c = wsAddress.address.locality;
            address.Organization__c = wsAddress.address.organization;
            address.POBox__c = wsAddress.address.pobox;
            address.Postcode__c = wsAddress.address.postcode;
            address.Department__c = wsAddress.address.department;
            address.Province__c = wsAddress.address.province;
        }
        // map the match status
        String elementMatchStatus = wsAddress.element_match_status;
        Map<String, String> matchStatusByFieldName = new Map<String, String>{
                'Postcode_Match_Status__c' => elementMatchStatus.substring(0,1),
                'Locality_Match_Status__c' => elementMatchStatus.substring(1,2),
                'Province_Match_Status__c' => elementMatchStatus.substring(2,3),
                'Street_Match_Status__c' => elementMatchStatus.substring(3,4),
                'Building_Number_Match_Status__c' => elementMatchStatus.substring(4,5),
                'PO_Box_Match_Status__c' => elementMatchStatus.substring(5,6),
                'Building_Match_Status__c' => elementMatchStatus.substring(6,7),
                'Organization_Match_Status__c' => elementMatchStatus.substring(7,8)
        };
        for (String fieldName : matchStatusByFieldName.keySet()) {
            String value = null;
            switch on matchStatusByFieldName.get(fieldName) {
                when '0' {
                    value = 'Empty';
                }
                when '1' {
                    value = 'Not found';
                }
                when '2' {
                    value = 'Not checked (no reference data or no chance of success)';
                }
                when '3' {
                    value = 'Matched with errors';
                }
                when '4' {
                    value = 'Matched without errors';
                }
                when else {
                    ErrorLogUtil.logException(new CCException('Unexpected value ' + matchStatusByFieldName.get(fieldName) + ' while match status for field ' + fieldName));
                }
            }
            address.put(fieldName, value);
        }
        // map the result status
        String elementResultStatus = wsAddress.element_result_status;
        Map<String, String> resultStatusByFieldName = new Map<String, String>{
                'Postcode_Result_Status__c' => elementResultStatus.substring(0,1),
                'Locality_Result_Status__c' => elementResultStatus.substring(1,2),
                'Province_Result_Status__c' => elementResultStatus.substring(2,3),
                'Street_Result_Status__c' => elementResultStatus.substring(3,4),
                'Building_Number_Result_Status__c' => elementResultStatus.substring(4,5),
                'PO_Box_Result_Status__c' => elementResultStatus.substring(5,6),
                'Building_Result_Status__c' => elementResultStatus.substring(6,7),
                'Organization_Result_Status__c' => elementResultStatus.substring(7,8)
        };
        System.debug(JSON.serializePretty(resultStatusByFieldName));
        for (String fieldName : resultStatusByFieldName.keySet()) {
            String value = null;
            switch on resultStatusByFieldName.get(fieldName) {
                when '0' {
                    value = 'Empty';
                }
                when '1' {
                    value = 'Not checked';
                }
                when '2' {
                    value = 'Not checked but standardized';
                }
                when '3' {
                    value = 'Checked and corrected (changed or inserted)';
                }
                when '4' {
                    value = 'Validated, but changed (synonyms, old names)';
                }
                when '5' {
                    value = 'Validated, but standardized';
                }
                when '6' {
                    value = 'Validated and unchanged';
                }
                when '7' {
                    value = 'No value returned, due to multiple possible matches';
                }
                when else {
                    ErrorLogUtil.logException(new CCException('Unexpected value ' + resultStatusByFieldName.get(fieldName) + ' while filling result status for field ' + fieldName));
                }
            }
            address.put(fieldName, value);
        }
        return address;
    }

}