/**
 * Created by jaapbranderhorst on 09/04/2020.
 */

public inherited sharing class CompanyInfoLoginController {

    @AuraEnabled
    public static void saveUsernamePassword(String username, String password) {
        BusinessAccountingService.saveDataUserCredentials(username, password);
    }

    @AuraEnabled(cacheable=true)
    public static Credentials__c getCredentials(){
        return BusinessAccountingService.getCredentials();
    }

}