/**
 * Created by jaapbranderhorst on 09/04/2020.
 */

public inherited sharing class CompanyInfoLoginController {

    @AuraEnabled
    public static void safeUsernamePassword(String username, String password) {
        BusinessAccountingService.saveDataUserCredentials(username, password);
    }

}