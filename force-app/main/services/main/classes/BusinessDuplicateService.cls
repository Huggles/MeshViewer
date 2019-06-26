/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public without sharing class BusinessDuplicateService {

    public static List<CheckDuplicateDossierResponse> checkForDuplicateDossiers(List<CheckDuplicateDossierRequest> requests) {
        return newInstance().checkForDuplicateDossiers(requests);
    }

    public static List<Account> checkForAccountDuplicates(Account acc) {
        return newInstance().checkForAccountDuplicates(acc);
    }

    public static String checkForExistingVatNumberInDB(String dossierNumber) {
        return newInstance().checkForExistingVatNumberInDB(dossierNumber);
    }

    public static IBusinessDuplicateService newInstance() {
        return (IBusinessDuplicateService) Application.Service.newInstance(IBusinessDuplicateService.class);
    }

}