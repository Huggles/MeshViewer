/**
 * Created by tejaswinidandi on 09/03/2020.
 */

global with sharing class GetCompanyIdInvocable {

    @InvocableMethod(label='Search for Company ID' description='Searches for company Id based on the given arguments.' category='Company.info for Sales')
    global static List<String> searchForCompanyId(List<SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument> arguments) {
        List<List<Business_Dossier__c>> dossierLists = SearchForCreditSafeDossiersInvocable.searchForCreditSafeDossier(arguments);
        System.debug(dossierLists);
        String companyId = dossierLists.size() > 0 && dossierLists[0].size() > 0 ? dossierLists[0][0].Company_Id__c : null;
        return new List<String>{companyId};
    }
}