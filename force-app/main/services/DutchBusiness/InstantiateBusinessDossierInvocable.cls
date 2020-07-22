/**
 * Created by hugovankrimpen on 08/07/2020.
 */

global with sharing class InstantiateBusinessDossierInvocable {

    global inherited sharing class InstantiateBusinessDossierArgument {
        @InvocableVariable(
                label='Dossier Number'
                description='The dossier number (Chamber of Commerce) of the Dutch dossier to be fetched from Company.info and created'
                required=true)
        global  String dossierNumber;

        @InvocableVariable(
                label='Establishment Number'
                description='The establishment number of the Dutch dossier to be fetched from Company.info and created')
        global  String establishmentNumber;

        @InvocableVariable(
                label='Enrich with VAT'
                description='If true, the VAT number of the company will be retrieved when available.')
        global  Boolean getVat;


        global  InstantiateBusinessDossierArgument() {

        }
    }

    @InvocableMethod(
            label='Instantiate Dutch Dossiers'
            description='Fetches dossiers from the Dutch Chamber of Commerce and instantiates the Business Dossier & Related objects.'
            category='Company.info')
    global static List<Business_Dossier__c> instantiateBusinessDossier(List<InstantiateBusinessDossierArgument> arguments) {
        try {
            List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
            for (InstantiateBusinessDossierArgument dutchDossierArgument : arguments) {
                Business_Dossier__c businessDossier =  DutchBusinessService.instantiateDutchDossier(dutchDossierArgument.dossierNumber, dutchDossierArgument.establishmentNumber, dutchDossierArgument.getVat);
                dossiers.add(businessDossier);
            }
            return dossiers;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }

    }


}