/****************************************************************************************
Author          : ValerijsProkudins

TODO: Move custom metadatas query to selector
******************************************************************************************/
public with sharing class DutchBusinessAccountingServiceImpl implements IDutchBusinessAccountingService{

    // Onboarding of the new customer. First new user is created and then the trial budged is added; username is the only param required
    public static DutchBusinessAccountingDto.userCreateResponseDto onboardCustomer(String username){

        DutchBusinessAccountingDto.UserCreateRequestDto input = new DutchBusinessAccountingDto.UserCreateRequestDto();
        input.nickname = username;
        input.accountId = 13972; //TODO: get the account ID from Custom Settings or CMT
        input.password = ''; // we keep this empty so CompanyInfo will generate a new password
        input.email = 'valerijs.prokudins@appsolutely.nl'; // TODO get the email address from custom setting or CMT
        input.companyname = 'AppsolutelysCustomer'; // TODO: understand how to get the poroper value? Company information obj?
        input.address = '';
        input.contactname = ''; //Take from the current user?
        input.contactemail = input.email; // take from the current user?
        input.telephone = '';
        input.fax = ''; // pretty sure it is not needed
        input.clientcode = ''; // TODO: undertannvb  ds what is this
        input.comments = 'A user for reselling by Appsolutely. Registered through the CompanyData for Salesforce application';
        list<Integer> lst = new list<Integer>();
        lst.add(23);// TODO: this will be implemented sepererately and will be configurable
        input.usergroups = lst;
        try{
            DutchBusinessAccountingDto.userCreateResponseDto userResp = createCIUser(input);
            addTrialToCIUser(userResp);
            Credentials__c cs = Credentials__c.getOrgDefaults();
            cs.Username__c = userResp.nickname;
            cs.Password__c = userResp.password;
            cs.CompanyInfoUserId__c = userResp.id;
            upsert cs;
            return userResp;
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }
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
    
    // creates an integration user for the customer. Gives back the Id of the user in the Company.info backend
    public static DutchBusinessAccountingDto.userCreateResponseDto createCIUser(DutchBusinessAccountingDto.UserCreateRequestDto input){
        try{    
            IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
            DutchBusinessAccountingDto.userCreateResponseDto response = service.userCreate(input);
            return response;
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }
    } 

    public static boolean addTrialToCIUser(DutchBusinessAccountingDto.userCreateResponseDto userId){// to think about params here
        try{
            ApplicationProperty__mdt configData = [SELECT DataProviderName__c, DefaultTrialBalance__c, DataProviderAdminUsername__c, DataProviderAdminPassword__c FROM ApplicationProperty__mdt WHERE DataProviderName__c = 'Company.Info' LIMIT 1];  
            Double amount = configData.DefaultTrialBalance__c; 
            return addBudget(amount, userId.id);
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }
    }

    public static boolean addBudget(Double amount, Integer userId){
        DutchBusinessAccountingDto.userChangeBalanceRequestDto input = new DutchBusinessAccountingDto.userChangeBalanceRequestDto();
        input.userId = userId;
        input.balance = amount;
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        return service.userChangeBalance(input);

    }
    public static boolean addBudget(Double amount){
        DutchBusinessAccountingDto.userChangeBalanceRequestDto input = new DutchBusinessAccountingDto.userChangeBalanceRequestDto();
        try{
            Credentials__c cs = Credentials__c.getOrgDefaults();
            return addBudget(amount, (Integer)cs.CompanyInfoUserId__c);
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }

    }

    public static Double getBalance(){
        DutchBusinessAccountingDto.userViewBalanceRequest input = new DutchBusinessAccountingDto.userViewBalanceRequest();
        try{
            Credentials__c cs = Credentials__c.getOrgDefaults();
            input.userId = (integer)cs.CompanyInfoUserId__c;
            IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
            DutchBusinessAccountingDto.userViewBalanceResponse result = service.userGetBalance(input);
            return result.balance;
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.BDS_WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }
    }
}
