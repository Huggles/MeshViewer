/**
 * Created by hugovankrimpen on 08/07/2020.
 */

global inherited sharing class FindDuplicateDossiersInvocable {
    global inherited sharing class FindDuplicatesArgument {
        @InvocableVariable(label='Dossier' description='The sobject value' required=true)
        global SObject dossier;


        /*
        @InvocableVariable(label='Dossier Number' description='' required=true)
        global String dossierNumber;

        @InvocableVariable(label='Establishment Number' description='' )
        global String establishmentNumber;

         */

        @TestVisible
        private FindDuplicatesArgument(String dossierNumber, String establishmentNumber) {
            //this.dossierNumber = dossierNumber;
            //this.establishmentNumber = establishmentNumber;
        }

        global FindDuplicatesArgument() {

        }
    }


    @InvocableMethod(
            label='Find Duplicate Dossiers'
            description='Find Duplicate Dossiers in Salesforce, based on the Dossier number and Establishment number.'
            category='Company.info')
    global static List<List<SObject>> findDuplicates(List<FindDuplicatesArgument> findDuplicatesArguments) {
        try {
            List<List<Business_Dossier__c>> response = new List<List<Business_Dossier__c>>();
            List<String> dossierNumbers = new List<String>();
            List<String> establishmentNumbers = new List<String>();
            for(FindDuplicatesArgument argument : findDuplicatesArguments){
                if(argument.dossier instanceof Business_Dossier__c) {
                    Business_Dossier__c businessDossier = (Business_Dossier__c)argument.dossier;
                    dossierNumbers.add(businessDossier.Dossier_Number__c);
                    dossierNumbers.add(businessDossier.Establishment_Number__c);
                }
            }

            List<Business_Dossier__c> duplicateBusinessDossiers = BusinessService.findDuplicateDossiersByDossierAndEstablishmentNumber(dossierNumbers, establishmentNumbers);
            response.add(duplicateBusinessDossiers);

            return response;


        }catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw ex;
        }
    }
}



