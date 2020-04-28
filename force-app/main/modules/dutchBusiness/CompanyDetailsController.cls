/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/

public with sharing class CompanyDetailsController {

    @AuraEnabled
    public static Object updateDossierWithVAT(Id dossierId) {
        try{
            List<Business_Dossier__c> dossiers = DutchBusinessService.getDossiersById(new Set<Id>{dossierId});
            if (dossiers != null && dossiers.size() == 1) {
                Business_Dossier__c dossier = DutchBusinessService.updateBusinessDossierWithVATNumber(dossiers[0]);
                DutchBusinessService.storeDossiers(new List<Business_Dossier__c>{dossier}, null);
                return new AuraResponseWrapper(dossier);
            } else {
                throw new CustomException('Expected a dossier id. No dossier Id present.');
            }
        } catch (CCException e) {
            return new AuraResponseWrapper(e);
        } catch (Exception e) {
            ErrorLogUtil.logException(e);
            return new AuraResponseWrapper(e, System.Label.Error);
        }
    }

}