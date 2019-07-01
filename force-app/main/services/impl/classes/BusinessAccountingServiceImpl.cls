/****************************************************************************************
Author          : ValerijsProkudins

TODO: Move custom metadatas query to selector
******************************************************************************************/
public with sharing class BusinessAccountingServiceImpl implements IBusinessAccountingService {

    // Onboarding of the new customer. First new user is created and then the trial budged is added; username is the only param required
    public static void onboardCustomer(String username, String password){

        // get the config
        List<ApplicationProperty__mdt> aps = [SELECT Appsolutely_Contact_Email__c, Data_Provider_Account_Id__c, Data_Provider_Account_Comment__c, DefaultTrialBalance__c FROM ApplicationProperty__mdt LIMIT 1];
        if (aps.size() == 0) throw new CCException(System.Label.Error_Config); // JB: checked on size < 0 ???
        ApplicationProperty__mdt applicationProperties = aps[0];

        Organization orgDetails = [SELECT Id, Address, Fax, Name, Phone FROM Organization WHERE Id = :UserInfo.getOrganizationId()];

        // create the user,throws CC exception if something goes wrong, handled by the frontend.
        // userCreateV2(Integer accountid, String nickname, String password, AccountingWsdl.intArray usergroups, String email, String companyname, String address, String contactname, String contactemail, String telephone, String fax, String clientcode, String comments)
        AccountingWsdl.intArray usergroups = new AccountingWsdl.intArray();
        usergroups.item = new List<Integer>();
        usergroups.item.add(23);
        AccountingWsdl.userCreateV2ResponseType response = WsAccounting.userCreateV2(Integer.valueOf(applicationProperties.Data_Provider_Account_Id__c),
                username, password, usergroups, applicationProperties.Appsolutely_Contact_Email__c,
                orgDetails.Name, orgDetails.Address.getStreet() + ', ' + orgDetails.Address.getPostalCode(), // getStreet is a trick so we don't need to query for the Address.Street
                UserInfo.getName(), UserInfo.getUserEmail(), orgDetails.Phone, orgDetails.Fax, '', '');

        // upsert the new user credentials
        Credentials__c cs = Credentials__c.getOrgDefaults();
        cs.Username__c = response.nickname;
        cs.Password__c = response.password;
        cs.CompanyConnectUserId__c = response.id;
        // we don't check for fls/crud since that always needs to happen
        upsert cs;

        // set the trial budget, this might throw an exception if things go really bad
        WsAccounting.userEditBalance(response.id, Integer.valueOf(applicationProperties.DefaultTrialBalance__c));

    }

    
    public static boolean getUserOnboarded(){
        try{
            Credentials__c cs = Credentials__c.getOrgDefaults();
            if(cs.Username__c != null && cs.Username__c != '' && cs.Password__c != null && cs.Password__c != ''){
                return true;
            }else{
                return false;}
        }catch(exception e){
            return false;
        }
    }

//    public static Boolean addTrialToCIUser(AccountingWsdl.userCreateResponseDto userId){// to think about params here
//        try{
//            ApplicationProperty__mdt configData = [SELECT DataProviderName__c, DefaultTrialBalance__c, DataProviderAdminUsername__c, DataProviderAdminPassword__c FROM ApplicationProperty__mdt WHERE DataProviderName__c = 'Company.Info' LIMIT 1];
//            Double amount = configData.DefaultTrialBalance__c;
//            return addBudget(amount, userId.id);
//        }catch(Exception e){
//            ErrorLogUtil.logException(e);
//            throw new CCException(System.Label.WSCall_Unknown_Exception, e);
//        }
//    }

    // TODO: check if the companyconnectuser id also works for referral
    public static void addBudget(Double amount){
        // get the user
        Credentials__c cs = Credentials__c.getOrgDefaults();
        // conversion might throw an exception. We don't catch it here but handle it at the UI since this is a real exception
        Double currentBalance = WsAccounting.userViewBalance(Integer.valueOf(cs.CompanyConnectUserId__c));

        // add the budget. conversion might throw an exception. We don't catch it here but handle it at the UI since this is a real exception
        WsAccounting.userEditBalance(Integer.valueOf(cs.CompanyConnectUserId__c), currentBalance + amount);
    }

    public static Double getBalance(){
        Credentials__c cs = Credentials__c.getOrgDefaults();
        Double currentBalance = WsAccounting.userViewBalance(Integer.valueOf(cs.CompanyConnectUserId__c));
        return currentBalance;
    }

    public static Boolean userCheckActive(){
        Boolean returnValue = false;
        Credentials__c cs = Credentials__c.getOrgDefaults();
        if (cs != null && cs.CompanyConnectUserId__c != null) {
            AccountingWsdl.UserV2 user = WsAccounting.userViewV2(Integer.valueOf(cs.CompanyConnectUserId__c));
            returnValue = user.active;
        }
        return returnValue;
    }
}
