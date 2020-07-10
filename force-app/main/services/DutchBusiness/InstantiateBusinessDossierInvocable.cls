/**
 * Created by hugovankrimpen on 08/07/2020.
 */

public with sharing class InstantiateBusinessDossierInvocable {

    public inherited sharing class InstantiateBusinessDossierArgument {
        @InvocableVariable(
                label='Dossier Number'
                description='The dossier number (Chamber of Commerce) of the Dutch dossier to be fetched from Company.info and created'
                required=true)
        public String dossierNumber;

        @InvocableVariable(
                label='Establishment Number'
                description='The establishment number of the Dutch dossier to be fetched from Company.info and created')
        public String establishmentNumber;

        @InvocableVariable(
                label='Enrich with VAT'
                description='If true, the VAT number of the company will be retrieved when available.')
        public Boolean getVat;


        public InstantiateBusinessDossierArgument() {

        }
    }

    @InvocableMethod(
            label='Instantiate Dutch Dossiers'
            description='Fetches dossiers from the Dutch Chamber of Commerce and instantiates the Business Dossier & Related objects.'
            category='Company.info')
    public static List<Business_Dossier__c> instantiateBusinessDossier(List<InstantiateBusinessDossierArgument> arguments) {
        try {
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
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