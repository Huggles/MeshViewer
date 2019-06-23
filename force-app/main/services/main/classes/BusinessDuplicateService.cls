/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public without sharing class BusinessDuplicateService {

    public static Business_Dossier__c checkSingleDuplicateDossier(String dossierNumber, String establishmentNumber) {
        return newInstance().checkSingleDuplicateDossier(dossierNumber, establishmentNumber);
    }

    public static List<CheckDuplicateDossierResponse> checkForDuplicateDossiers(List<CheckDuplicateDossierRequest> requests) {
        return newInstance().checkForDuplicateDossiers(requests);
    }

    public static List<Account> checkForAccountDuplicates(Account acc) {
        return newInstance().checkForAccountDuplicates(acc);
    }

    public static IBusinessDuplicateService newInstance() {
        return (IBusinessDuplicateService) Application.Service.newInstance(IBusinessDuplicateService.class);
    }

}