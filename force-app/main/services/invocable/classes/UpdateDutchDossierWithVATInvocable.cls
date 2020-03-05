/**
 * Created by jaapbranderhorst on 03/03/2020.
 */

public with sharing class UpdateDutchDossierWithVATInvocable {

    @InvocableMethod(label = 'Update Dutch dossiers with VAT number' description='Updates the given Dutch dossiers with the Dutch VAT number if the relationship between the Dutch Chamber of Commerce number and Dutch VAT number is known by Company.info' category='Company.info for Sales')
    public static List<Business_Dossier__c> updateDutchDossiersWithVAT(List<Business_Dossier__c> dossiers) {
        for (Integer i = 0; i < dossiers.size() ; i++) {
            dossiers[i] = DutchBusinessService.updateBusinessDossierWithVATNumber(dossiers[i]);
        }
        return dossiers;
    }

}