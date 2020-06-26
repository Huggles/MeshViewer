/**
 * Created by jaapbranderhorst on 09/04/2020.
 */

public inherited sharing class CompanyInfoLoginController {

    @AuraEnabled
    public static void saveUsernamePassword(String username, String password) {
        try {
            BusinessAccountingService.saveDataUserCredentials(username, password);
        } catch(Exception ex) { // do not log the error otherwise we can see the username/password entered maybe
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Credentials__c getCredentials(){
        try {
            return BusinessAccountingService.getCredentials();
        } catch(Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }
    }
}