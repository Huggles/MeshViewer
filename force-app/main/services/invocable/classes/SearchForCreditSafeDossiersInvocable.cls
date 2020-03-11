/**
 * Created by jaapbranderhorst on 14/02/2020.
 */

global with sharing class SearchForCreditSafeDossiersInvocable {

    global inherited sharing class SearchForCreditSafeDossiersArgument {
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

    @InvocableMethod(label='Search for Credit Safe reports' description='Searches for credit safe reports based on the given arguments.' category='Company.info')
    global static List<List<Business_Dossier__c>> searchForCreditSafeDossier(List<SearchForCreditSafeDossiersArgument> arguments) {
        List<List<Business_Dossier__c>> dossierLists = new List<List<Business_Dossier__c>>();
        for (SearchForCreditSafeDossiersArgument argument : arguments) {
            List<Business_Dossier__c> dossiers = (CreditSafeService.searchForCreditSafeDossiers(
                    argument.countries,
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
            dossierLists.add(dossiers);
        }
        return dossierLists;
    }

}