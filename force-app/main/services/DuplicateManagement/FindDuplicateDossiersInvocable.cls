/**
 * Created by hugovankrimpen on 08/07/2020.
 */

global inherited sharing class FindDuplicateDossiersInvocable {
    global inherited sharing class FindDuplicateDossiersArgument {
        @InvocableVariable(label='Dossier' description='The sobject value' required=true)
        global SObject dossier;

        @TestVisible
        private FindDuplicateDossiersArgument(String dossierNumber, String establishmentNumber) {
            //this.dossierNumber = dossierNumber;
            //this.establishmentNumber = establishmentNumber;
        }

        global FindDuplicateDossiersArgument() {

        }
    }


    @InvocableMethod(
            label='Find Duplicate Dossiers'
            description='Find Duplicate Dossiers in Salesforce, based on the Dossier number and Establishment number.'
            category='Company.info')
    global static List<List<SObject>> findDuplicates(List<FindDuplicateDossiersArgument> findDuplicatesArguments) {
        try {
            List<List<Business_Dossier__c>> response = new List<List<Business_Dossier__c>>();
            List<String> dossierNumbers = new List<String>();
            List<String> establishmentNumbers = new List<String>();
            for(FindDuplicateDossiersArgument argument : findDuplicatesArguments){
                if(argument.dossier instanceof Business_Dossier__c) {
                    Business_Dossier__c businessDossier = (Business_Dossier__c)argument.dossier;
                    dossierNumbers.add(businessDossier.Dossier_Number__c);
                    establishmentNumbers.add(businessDossier.Establishment_Number__c);
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



