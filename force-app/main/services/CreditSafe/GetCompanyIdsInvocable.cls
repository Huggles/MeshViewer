/**
 * Created by tejaswinidandi on 12/03/2020.
 */

global with sharing class GetCompanyIdsInvocable {

    @InvocableMethod(label='Get for Company IDs' description='Get company Ids based on the input arguments.' category='Company.info')
    global static List<String> getForCompanyId(List<SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument> arguments) {
        List<SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument> newArguments = new List<SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument>();
        for (SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument argument : arguments) {
            //the reason we append extra 0's at the end is, because sometimes the eight digit Registration number is used for the headOffice and branch offices
            //which results in multiple results where one result is expected and it causes an error in the flow
            argument.registration_number = argument.registration_number.length() == 8 ? argument.registration_number + '0000' : argument.registration_number;
            newArguments.add(argument);
        }
        List<List<Business_Dossier__c>> dossierLists = SearchForCreditSafeDossiersInvocable.searchForCreditSafeDossier(newArguments);
        List<String> companyIds = new List<String>();
        for (List<appsolutely__Business_Dossier__c> dossiersList : dossierLists) {
            for (Business_Dossier__c businessDossier : dossiersList) {
                String companyId = businessDossier.Company_Id__c != null ? businessDossier.Company_Id__c : null;
                companyIds.add(companyId);
            }
        }
        return companyIds;
    }
}