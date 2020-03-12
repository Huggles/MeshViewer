/**
 * Created by tejaswinidandi on 12/03/2020.
 */

global with sharing class GetCompanyIdsInvocable {

    @InvocableMethod(label='Get for Company IDs' description='Get for company Ids based on the given arguments.' category='Company.info')
    global static List<String> getForCompanyId(List<SearchForCreditSafeDossiersInvocable.SearchForCreditSafeDossiersArgument> arguments) {
        List<List<Business_Dossier__c>> dossierLists = SearchForCreditSafeDossiersInvocable.searchForCreditSafeDossier(arguments);
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