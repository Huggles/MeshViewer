/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

/**
 * Invocable to call the method searchForDutchDossiers
 */
global with sharing class SearchForDutchDossiersInvocable {

    global class SearchForDutchDossiersResponse {
        @InvocableVariable(label='Chamber of Commerce Number' description='The Chamber of Commerce number, consisting of 8 numbers (e.g., 00123456)')
        global String dossier_number;
        @InvocableVariable(label='Establishment Number' description='The unique identifier for this business establishment, consisting of 12 numbers (e.g.  012345678912).  Optional.  Some businesses, mainly foundations (`Stichting`), do not have establishments.  In these instances the establishment_number is not returned.')
        global String establishment_number;
        @InvocableVariable(label='Name' description='The name of the business that matched the search trade_name parameter (or default: trade_name)')
        global String name;
        @InvocableVariable(label='Match Type' description='The match type for the name. Can be trade_name (The name matches the trade name of the business), legal_name (The name matches the legal name), alternative_trade_name (The name matches one of the alternative trade names) or undetermined (The match_type could not be determined, the trade name is displayed within name.  This can occur in case the result found was matched on other parameters than the trade_name, like the city name.)')
        global String match_type;
        @InvocableVariable(label='Establishment City' description='City of the establishment address of the business')
        global String establishment_city;
        @InvocableVariable(label='Establishment Street' description='Street of the establishment address of the business')
        global String establishment_street;
        @InvocableVariable(label='Correspondence City' description='City of the correspondence address of the business')
        global String correspondence_city;
        @InvocableVariable(label='Correspondence Street' description='Street of the correspondence address of the business')
        global String correspondence_street;
        @InvocableVariable(label='Indication Economically Active' description='Boolean indicating if the business is economically active.  This indication is determined by a formula developed by the ‘Vereninging Kamers van Koophandel’.  This should not be interpreted as an indication of whether the business is currently still registered at the Chamber of Commerce: only currently registered businesses are available through our services.')
        global Boolean indication_economically_active;

        public SearchForDutchDossiersResponse(SearchForDossiersResultDto searchForDossiersResultDt) {
            dossier_number = searchForDossiersResultDt.dossier_number;
            establishment_number = searchForDossiersResultDt.establishment_number;
            name = searchForDossiersResultDt.name;
            match_type = searchForDossiersResultDt.match_type;
            establishment_city = searchForDossiersResultDt.establishment_city;
            establishment_street = searchForDossiersResultDt.establishment_street;
            correspondence_city = searchForDossiersResultDt.correspondence_city;
            correspondence_street = searchForDossiersResultDt.correspondence_street;
            indication_economically_active = searchForDossiersResultDt.indication_economically_active;
        }
    }

    global class SearchForDutchDossiersArgument {
        @InvocableVariable(label='Trade Name' description='Name under which the organisation engages in commercial activity')
        global String trade_name;
        @InvocableVariable(label='City')
        global String city;
        @InvocableVariable(label='Street')
        global String street;
        @InvocableVariable(label='Postal Code')
        global String postcode;
        @InvocableVariable(label='House Number')
        global Integer house_number;
        @InvocableVariable(label='House Number Addition')
        global String house_number_addition;
        @InvocableVariable(label='Telephone Number')
        global String telephone_number;
        @InvocableVariable(label='Domain Name' description='Domain name or email address, when an email address is given the domain part of that address is used')
        global String domain_name;
    }

    @InvocableMethod
    global static List<SearchForDutchDossiersResponse> searchForDutchDossiers(List<SearchForDutchDossiersArgument> arguments) {
        // TODO: extend exception handling
        try {
            List<SearchForDossiersResultDto> searchForDossiersResultDtos = new List<SearchForDossiersResultDto>();
            for (SearchForDutchDossiersArgument searchForDutchDossiersArgument : arguments) {
                searchForDossiersResultDtos.addAll(
                        BusinessService.searchForDutchDossiers(
                                searchForDutchDossiersArgument.trade_name,
                                searchForDutchDossiersArgument.city,
                                searchForDutchDossiersArgument.street,
                                searchForDutchDossiersArgument.postcode,
                                searchForDutchDossiersArgument.house_number,
                                searchForDutchDossiersArgument.house_number_addition,
                                searchForDutchDossiersArgument.telephone_number,
                                searchForDutchDossiersArgument.domain_name
                        )
                );
            }
            List<SearchForDutchDossiersResponse> responses = new List<SearchForDutchDossiersInvocable.SearchForDutchDossiersResponse>();
            for (SearchForDossiersResultDto searchForDossiersResultDto : searchForDossiersResultDtos) {
                responses.add(new SearchForDutchDossiersResponse(searchForDossiersResultDto));
            }
            return responses;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex);
            return null;
        }

    }

}