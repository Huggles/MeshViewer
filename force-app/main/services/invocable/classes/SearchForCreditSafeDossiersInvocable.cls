/**
 * Created by jaapbranderhorst on 14/02/2020.
 */

global with sharing class SearchForCreditSafeDossiersInvocable {

    global class SearchForCreditSafeResponse {
        @InvocableVariable(label='Creditsafe number' description='Creditsafe number')
        global String creditsafe_number;
        @InvocableVariable(label='Date Last Account' description='Date of last account')
        global Datetime date_last_account;
        @InvocableVariable(label='Date Last Change' description='Date of last change')
        global Datetime date_last_change;
        @InvocableVariable(label='Trade Names' description='The trade names the company uses')
        global List<String> trade_names;
        @InvocableVariable(label='VAT Numbers' description='The VAT Numbers the company uses.')
        global List<String> vat_numbers;
        @InvocableVariable(label='Country ISO Code' description='The ISO 3166-1-alpha-2 country code of the company’s country.')
        global String country;
        @InvocableVariable(label='Registration Number' description='Company registration number according to country’s Chambre of Commerce.')
        global String registration_number;
        @InvocableVariable(label='Name' description='Company name.')
        global String name;
        @InvocableVariable(label='Id' description='Creditsafe company identifier used to retrieve a report.')
        global String id;
        @InvocableVariable(label='Type' description='Company type information (Ltd, NonLtd etc.)')
        global String type;
        @InvocableVariable(label='Status' description='Company status information (Active, Closed etc.).')
        global String status;
        @InvocableVariable(label='Office Type' description='Company office type information (Headoffice etc.).')
        global String office_type;
        @InvocableVariable(label='City' description='Address city')
        global String city;
        @InvocableVariable(label='Address Country' description='Address Country')
        global String address_country;
        @InvocableVariable(label='Full Address' description='Full Address')
        global String full_address;
        @InvocableVariable(label='House Number' description='Address House Number')
        global String house_number;
        @InvocableVariable(label='Postal Code' description='Address Postal Code')
        global String postal_code;
        @InvocableVariable(label='Street' description='Address Street')
        global String street;
        @InvocableVariable(label='Telephone' description='Address Telephone')
        global String telephone;

        public SearchForCreditSafeResponse(SearchForCreditSafeDossiersResultDto searchForDossiersResultDt) {
            this.telephone = searchForDossiersResultDt.telephone;
            this.street = searchForDossiersResultDt.street;
            this.postal_code = searchForDossiersResultDt.postal_code;
            this.house_number = searchForDossiersResultDt.house_number;
            this.full_address = searchForDossiersResultDt.full_address;
            this.country = searchForDossiersResultDt.country;
            this.office_type = searchForDossiersResultDt.office_type;
            this.status = searchForDossiersResultDt.status;
            this.type = searchForDossiersResultDt.type;
            this.id = searchForDossiersResultDt.id;
            this.name = searchForDossiersResultDt.name;
            this.trade_names = searchForDossiersResultDt.trade_names;
            this.registration_number = searchForDossiersResultDt.registration_number;
            this.vat_numbers = searchForDossiersResultDt.vat_numbers;
            this.city = searchForDossiersResultDt.city;
            this.date_last_change = searchForDossiersResultDt.date_last_change;
            this.date_last_account = searchForDossiersResultDt.date_last_account;
            this.creditsafe_number = searchForDossiersResultDt.creditsafe_number;
            this.address_country = searchForDossiersResultDt.address_country;
        }
    }
    
    global class SearchForCreditSafeDossiersArgument {
        @InvocableVariable(label='Name' description='Name under which the organisation engages in commercial activity')
        global String Name;
        @InvocableVariable(label='City')
        global String city;
        @InvocableVariable(label='Street')
        global String street;
        @InvocableVariable(label='Postal Code')
        global String postal_code;
        @InvocableVariable(label='Province')
        global String province;
        @InvocableVariable(label='Registration Number')
        global String registration_number;
        @InvocableVariable(label='VAT Number')
        global String vat_number;
        @InvocableVariable(label='Registration Type')
        global String registration_type;
        @InvocableVariable(label='Status' description='Status of the company. Valid values are \'Active\', \'NonActive\' or \'Active, NonActive\'')
        global String status;
        @InvocableVariable(label='Countries' description='List of countries to search in')
        global List<String> countries;
        @InvocableVariable(label='CreditSafe Registration Id')
        global String id;
    }

    private static List<CreditSafe.Country> convertCountries(List<String> countriesAsStrings) {
        List<CreditSafe.Country> returnList = new List<CreditSafe.Country>();
        for (String str : countriesAsStrings) {
            switch on str {
                when 'NL' {
                    returnList.add(CreditSafe.Country.NL);
                }
                when 'BE' {
                    returnList.add(CreditSafe.Country.BE);
                }
                when 'IE' {
                    returnList.add(CreditSafe.Country.IE);
                }
                when 'GB' {
                    returnList.add(CreditSafe.Country.GB);
                }
                when 'DE' {
                    returnList.add(CreditSafe.Country.DE);
                }
                when 'FR' {
                    returnList.add(CreditSafe.Country.FR);
                }
                when 'SE' {
                    returnList.add(CreditSafe.Country.SE);
                }
            }

        }
        return returnList;
    }

    @InvocableMethod(label = 'Search for Credit Safe reports' description='Searches for credit safe reports based on the given arguments.' category='Company.info for Sales')
    global static List<SearchForCreditSafeResponse> searchForCreditSafeDossier(List<SearchForCreditSafeDossiersArgument> arguments) {
        List<SearchForCreditSafeDossiersResultDto> searchForDossiersResultDtos = new List<SearchForCreditSafeDossiersResultDto>();
        for (SearchForCreditSafeDossiersArgument argument : arguments) {
            searchForDossiersResultDtos.addAll(CreditSafeService.searchForCreditSafeDossiers(
                    convertCountries(argument.countries),
                    argument.id,
                    argument.status,
                    argument.registration_number,
                    argument.registration_type,
                    argument.vat_number,
                    argument.province,
                    argument.city,
                    argument.street,
                    argument.postal_code,
                    argument.name));
        }
        List<SearchForCreditSafeResponse> responses = new List<SearchForCreditSafeDossiersInvocable.SearchForCreditSafeResponse>();
        for (SearchForCreditSafeDossiersResultDto searchForDossiersResultDto : searchForDossiersResultDtos) {
            responses.add(new SearchForCreditSafeResponse(searchForDossiersResultDto));
        }
        return responses;

    }

}