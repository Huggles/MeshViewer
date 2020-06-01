/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

/**
 * Invocable to call the method searchForDutchDossiers
 */
global with sharing class SearchForDutchDossiersInvocable {

    global inherited sharing class SearchForDutchDossiersArgument {
        @InvocableVariable(label='Chamber of Commerce Number' description='The Dutch Chamber of Commerce under which the organisation is registered in the Dutch Chamber of Commerce')
        global String dossier_number;
        @InvocableVariable(label='Trade Name' description='Name under which the organisation engages in commercial activity')
        global String trade_name;
        @InvocableVariable(label='City')
        global String city;
        @InvocableVariable(label='Street')
        global String street;
        @InvocableVariable(label='Postal Code')
        global String postcode;
        @InvocableVariable(label='House Number')
        global String house_number;
        @InvocableVariable(label='House Number Addition')
        global String house_number_addition;
        @InvocableVariable(label='Telephone Number')
        global String telephone_number;
        @InvocableVariable(label='Domain Name' description='Domain name or email address, when an email address is given the domain part of that address is used')
        global String domain_name;
        @InvocableVariable(label='Strict Search')
        global Boolean strictSearch;
    }

    @InvocableMethod(label = 'Search for Dutch dossiers' description='Searches for Dutch dossiers based on the given arguments.' category='Company.info')
    global static List<List<Business_Dossier__c>> searchForDutchDossiers(List<SearchForDutchDossiersArgument> arguments) {
        List<List<Business_Dossier__c>> returnList = new List<List<Business_Dossier__c>>();
        for (SearchForDutchDossiersArgument searchForDutchDossiersArgument : arguments) {
            // input check
            if (!String.isEmpty(searchForDutchDossiersArgument.house_number) && !searchForDutchDossiersArgument.house_number.isNumeric()) {
                Exception ex = new CCInputException(Label.Error_String_Not_Numeric);
                ErrorLogUtil.logException(ex);
                throw ex;
            }
            List<Business_Dossier__c> businessDossiers = new List<Business_Dossier__c>();
            System.debug(searchForDutchDossiersArgument.house_number);
            businessDossiers.addAll(
                    DutchBusinessService.searchForDutchDossiersSObject(
                            searchForDutchDossiersArgument.dossier_number,
                            searchForDutchDossiersArgument.trade_name,
                            searchForDutchDossiersArgument.city,
                            searchForDutchDossiersArgument.street,
                            searchForDutchDossiersArgument.postcode,
                            String.isEmpty(searchForDutchDossiersArgument.house_number) ? null : Integer.valueOf(searchForDutchDossiersArgument.house_number),
                            searchForDutchDossiersArgument.house_number_addition,
                            searchForDutchDossiersArgument.telephone_number,
                            searchForDutchDossiersArgument.domain_name,
                            searchForDutchDossiersArgument.strictSearch
                    )
            );
            returnList.add(businessDossiers);
        }
        return returnList;
    }

}