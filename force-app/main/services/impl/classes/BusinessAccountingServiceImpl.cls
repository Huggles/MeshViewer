/****************************************************************************************
Author          : ValerijsProkudins

TODO: Move custom metadatas query to selector
******************************************************************************************/
public inherited sharing class BusinessAccountingServiceImpl implements IBusinessAccountingService {

    private final static String COMPANY_INFO_RESELLER_ACCOUNT_ID_SETTING_NAME = 'Company_info_Reseller_Account_Id';
    private final static String APPSOLUTELY_CONTACT_EMAIL_SETTING_NAME = 'Appsolutely_Contact_Email_Address';
    private final static String TRIAL_BUDGET_SETTING_NAME = 'Company_info_Default_Trial_Balance';

    public static AccountingWsdl.intArray usergroups {
        get {
            if (usergroups == null) {
                usergroups = new AccountingWsdl.intArray();
                usergroups.item = new List<Integer>();
                usergroups.item.add(23);
            }
            return usergroups;
        }
        set;
    }

    public void saveDataUserCredentials(String username, String password) {
        Credentials__c cs = Credentials__c.getOrgDefaults();
        cs.Username__c = username;
        cs.Password__c = password;
        // TODO: cover referral
        String resellerAccountId = SettingUtils.getSetting(COMPANY_INFO_RESELLER_ACCOUNT_ID_SETTING_NAME);

        AccountingWsdl.UserV2PagedResult userSearchResult = WsAccounting.accountUserSearchV2(Integer.valueOf(resellerAccountId), username, 1);
        if (userSearchResult.results.item != null && userSearchResult.results.item.size() ==1) {
            AccountingWsdl.UserV2 user = userSearchResult.results.item[0];
            cs.CompanyConnectUserId__c = user.id;
            upsert cs;
        } else {
            throw new CCUserNotFoundException(Label.Error_user_not_found);
        }

    }

    // Onboarding of the new customer. First new user is created and then the trial budged is added; username is the only param required
    public void onboardCustomer(String username, String password){

        // get the config
        String resellerAccountId = SettingUtils.getSetting(COMPANY_INFO_RESELLER_ACCOUNT_ID_SETTING_NAME);
        String appsolutelyEmail = SettingUtils.getSetting(APPSOLUTELY_CONTACT_EMAIL_SETTING_NAME);
        String trialBudget = SettingUtils.getSetting(TRIAL_BUDGET_SETTING_NAME);

        Organization orgDetails = [SELECT Id, Address, Fax, Name, Phone FROM Organization WHERE Id = :UserInfo.getOrganizationId()];

        // create the user,throws CC exception if something goes wrong, handled by the frontend.
        // userCreateV2(Integer accountid, String nickname, String password, AccountingWsdl.intArray usergroups, String email, String companyname, String address, String contactname, String contactemail, String telephone, String fax, String clientcode, String comments)
        AccountingWsdl.userCreateV2ResponseType response = WsAccounting.userCreateV2(Integer.valueOf(resellerAccountId),
                                                                                    username, password, usergroups, appsolutelyEmail,
                                                                                    orgDetails.Name, orgDetails.Address.getStreet() + ', ' + orgDetails.Address.getPostalCode(), // getStreet is a trick so we don't need to query for the Address.Street
                                                                                    UserInfo.getName(), UserInfo.getUserEmail(), orgDetails.Phone, orgDetails.Fax, '', '');

        // upsert the new user credentials
        saveDataUserCredentials(username, password); // TODO: create a separate method so we can pass the userid we already have

        // set the trial budget, this might throw an exception if things go really bad
        WsAccounting.userEditBalance(response.id, Integer.valueOf(trialBudget));

    }

    
    public boolean getUserOnboarded(){
        try{
            Credentials__c cs = Credentials__c.getOrgDefaults();
            if(cs != null && cs.Username__c != null && cs.Username__c != '' && cs.Password__c != null && cs.Password__c != ''){
                return true;
            }else{
                return false;
            }
        }catch(exception e){
            ErrorLogUtil.logException(e);
            return false;
        }
    }

    // TODO: check if the companyconnectuser id also works for referral
    public void addBudget(Double amount){
        // get the user
        Credentials__c cs = Credentials__c.getOrgDefaults();

        // add the budget. conversion might throw an exception. We don't catch it here but handle it at the UI since this is a real exception
        // editBalance actually adds or substracts (if negative) the amount from the balance.
        WsAccounting.userEditBalance(Integer.valueOf(cs.CompanyConnectUserId__c), amount);
        // TODO: ensure we get an order in our PBO !!!
    }

    public Double getBalance(){
        Credentials__c cs = Credentials__c.getOrgDefaults();
        Double currentBalance;
        if (cs != null && cs.CompanyConnectUserId__c != null) {
            currentBalance = WsAccounting.userViewBalance(Integer.valueOf(cs.CompanyConnectUserId__c));
        }
        return currentBalance;
    }

    public Boolean userCheckActive(){
        Boolean returnValue = false;
        Credentials__c cs = Credentials__c.getOrgDefaults();
        if (cs != null && cs.CompanyConnectUserId__c != null) {
            try {
                AccountingWsdl.UserV2 user = WsAccounting.userViewV2(Integer.valueOf(cs.CompanyConnectUserId__c));
                returnValue = user.active;
            } catch(Exception ex) {
                ErrorLogUtil.logException(ex);
                throw ex;
            }
        }
        return returnValue;
    }
}
