/**
 * Created by jaapbranderhorst on 23/02/2020.
 */

global with sharing class CreateDutchDossierInvocable {

    global class CreateDutchDossierArgument {
        @InvocableVariable(label='Dossier Number' description='The dossier number of the Dutch dossier to be fetched from Company.info and created' required=true)
        global String dossierNumber;
        @InvocableVariable(label='Establishment Number' description='The establishment number of the Dutch dossier to be fetched from Company.info and created')
        global String establishmentNumber;

        @TestVisible
        private CreateDutchDossierArgument(String dossierNumber, String establishmentNumber) {
            this.dossierNumber = dossierNumber;
            this.establishmentNumber = establishmentNumber;
        }
    }


    @InvocableMethod(label='Create Dutch Dossiers' description='Fetches dossiers from the Dutch Chamber of Commerce and stores them in Salesforce' category='Company.info for Sales')
    global static List<Business_Dossier__c> createDutchDossier(List<CreateDutchDossierArgument> arguments) {
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (CreateDutchDossierArgument dutchDossierArgument : arguments) {
            dossiers.add(DutchBusinessService.createDutchDossier(dutchDossierArgument.dossierNumber, dutchDossierArgument.establishmentNumber));
        }
        return dossiers;
    }

}