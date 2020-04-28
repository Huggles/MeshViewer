/**
 * Created by appsolutely on 14/02/2020.
 */

public inherited sharing class InternationalAddressImpl implements IInternationalAddressService{

    private inherited sharing class InternationalAddressComparableWrapper implements Comparable {

        public International_Address__c address { get; set; }

        private String organization { get; set; }

        private Integer organizationLevenshteinDistance { get; set; }

        private InternationalAddressComparableWrapper(International_Address__c address, String organization) {
            this.address = address;
            if (organization != null) {
                this.organization = organization;
                this.organizationLevenshteinDistance = address.Organization__c != null ? address.Organization__c.getLevenshteinDistance(organization) : null; // optimization so we don't need to do this for every compareTo call
            }
        }

        public Integer compareTo(Object param1) {
            International_Address__c addressToCompare = ((InternationalAddressComparableWrapper)param1).address;
            Integer returnValue = 0;
            if (this.organization != null && this.organizationLevenshteinDistance != null && addressToCompare.Organization__c != null) {
                Integer addressToCompareOrganizationLevenshteinDistance = addressToCompare.Organization__c.getLevenshteinDistance(this.organization);
                if (this.organizationLevenshteinDistance < addressToCompareOrganizationLevenshteinDistance) {
                    returnValue = -1;
                } else {
                    if (this.organizationLevenshteinDistance > addressToCompareOrganizationLevenshteinDistance) {
                        returnValue = 1;
                    }
                }
            }
            if (returnValue == 0 && address.Matchrate__c != null && addressToCompare.Matchrate__c != null) {
                if (address.Matchrate__c < addressToCompare.Matchrate__c) {
                    returnValue = -1;
                } else {
                    if (address.Matchrate__c > addressToCompare.Matchrate__c) {
                        returnValue = 1;
                    }
                }
            }
            return returnValue;
        }

    }

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
                resultArray.add(mapInternationalV2ToInternationalAddress(resultItem, country));
            }
        }

        // sort the results on how well the organization matches and then on the matchrate. If there is no organization, just sorts on matchrate
        List<InternationalAddressComparableWrapper> wrappedInternationalAddresses = new List<InternationalAddressImpl.InternationalAddressComparableWrapper>();
        for (International_Address__c internationalAddress : resultArray) {
            wrappedInternationalAddresses.add(new InternationalAddressComparableWrapper(internationalAddress, organization));
        }
        wrappedInternationalAddresses.sort();
        // and back to the resultArray
        resultArray = new List<International_Address__c>();
        for (InternationalAddressComparableWrapper internationalAddressComparableWrapper : wrappedInternationalAddresses) {
            resultArray.add(internationalAddressComparableWrapper.address);
        }

        return resultArray;
    }

    private International_Address__c mapInternationalV2ToInternationalAddress(InternationalAddressWsdl.InternationalV2 wsAddress, String searchCountryAlpha3Code) {
        International_Address__c address = new International_Address__c();
        // map the address fields
        if (wsAddress.address != null) {
            address.Matchrate__c = wsAddress.address.matchrate;
            address.Street__c = wsAddress.address.street;
            address.Country__c = wsAddress.address.country;
            if (!String.isEmpty(address.Country__c)) {
                address.Alpha_2_Country_Code__c = ([SELECT Alpha_2_Code__c FROM ISO_3166_Entry__mdt WHERE Label =: searchCountryAlpha3Code LIMIT 1]).Alpha_2_Code__c;
            }
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

    /**
     * Deletes the international address with the given id with all related objects
     *
     * @param internationalAddressId
     * @param checkPermissions true if permissions need to be checked
     */
    public void deleteInternationalAddress(Id internationalAddressId, Boolean checkPermissions) {
        if (String.isNotEmpty(internationalAddressId)) {
            List<International_Address__c> internationalAddresses = InternationalAddressSelector.newInstance().selectById(new Set<Id>{internationalAddressId});

            if (internationalAddresses.size() == 1) {
                fflib_ISObjectUnitOfWork unitOfWork = null;
                if (checkPermissions) {
                    unitOfWork = Application.UnitOfWork.newInstance(new DMLWithCRUD());
                } else {
                    unitOfWork = Application.UnitOfWork.newInstance();
                }
                unitOfWork.registerDeleted(internationalAddresses[0]);
                unitOfWork.commitWork();
            }
        }
        else {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }
    }
}