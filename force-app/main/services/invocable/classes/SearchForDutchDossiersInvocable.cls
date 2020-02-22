/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

/**
 * Invocable to call the method searchForDutchDossiers
 */
global with sharing class SearchForDutchDossiersInvocable {

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
    global static List<List<Business_Dossier__c>> searchForDutchDossiers(List<SearchForDutchDossiersArgument> arguments) {
        List<List<Business_Dossier__c>> returnList = new List<List<Business_Dossier__c>>();
        for (SearchForDutchDossiersArgument searchForDutchDossiersArgument : arguments) {
            List<Business_Dossier__c> businessDossiers = new List<Business_Dossier__c>();
            businessDossiers.addAll(
                    DutchBusinessService.searchForDutchDossiersSObject(
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
//            for (Business_Dossier__c businessDossier : businessDossiers) {
//                businessDossier.Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType);
//            }
            returnList.add(businessDossiers);
            System.debug('returnList: ' + JSON.serializePretty(returnList));
        }
        return returnList;
    }

}