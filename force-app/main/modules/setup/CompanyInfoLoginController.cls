/**
 * Created by jaapbranderhorst on 09/04/2020.
 */

public inherited sharing class CompanyInfoLoginController {

    public class Credentials {
        @AuraEnabled
        public String username;

        @AuraEnabled
        public String password;

        public Credentials(Credentials__c credentials) {
            this.username = credentials.Username__c;
            this.password = credentials.Password__c;
        }
    }

    @AuraEnabled
    public static void saveUsernamePassword(String username, String password) {
        try {
            BusinessAccountingService.saveDataUserCredentials(username, password);
        } catch(Exception ex) { // do not log the error otherwise we can see the username/password entered maybe
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static AuraResponseWrapper getCredentials(){
        try {
            return new AuraResponseWrapper(new Credentials(BusinessAccountingService.getCredentials()));
        } catch(Exception ex) {
            return new AuraResponseWrapper(ex, true, true);
        }
    }

}