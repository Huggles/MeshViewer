public with sharing class ConfigAppController {
public static PermissionSet ps;


    @AuraEnabled(cacheable=true)
    public static boolean getUserOnboarded(){
       try{
           return BusinessAccountingService.getUserOnboarded();
       }catch(CCException ex){
            //throw ex; // we dont log bds exceptions, only throwing them further
            //TODO: implement error callback and reporting
            return false;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            //AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return false;
        } 
    }

    @AuraEnabled
    public static void addBudget(Double Amount){
        try{
            BusinessAccountingService.addBudget(amount);
        }catch(CCException ex){
            throw ex;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw ex;
        }

    }

    @AuraEnabled
    // TODO: use the auraresponsewrapper. Remove the strange CCException handling
    public static boolean enableTrial(String password){
        try{
            BusinessAccountingService.onboardCustomer(UserInfo.getOrganizationId(), password);
            return true;
        }catch(CCException ex){
            AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return false;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            //AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return false;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Credentials__c getCredentials(){
        try{
            Credentials__c cs = Credentials__c.getOrgDefaults();
            return cs;

        }catch(CCException ex){
            AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return null;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            //AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return null;
        }
    }

    @AuraEnabled
    public static AuraResponseWrapper saveDataUserCredentials(String username, String password){
        try{
            BusinessAccountingService.saveDataUserCredentials(username, password);
            return new AuraResponseWrapper(true);
        }catch(CCException ex){
           throw ex;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw ex;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getUserBalance(){
        Decimal balance = BusinessAccountingService.getBalance();
        return balance;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean userCheckActive(){
        return BusinessAccountingService.userCheckActive();
    }

    


}

