/****************************************************************************************
Author          : ValerijsProkudins

TODO: Move custom metadatas query to selector
******************************************************************************************/
public with sharing class BusinessAccountingServiceImpl implements IBusinessAccountingService{

    // Onboarding of the new customer. First new user is created and then the trial budged is added; username is the only param required
    public static DutchBusinessAccountingDto.userCreateResponseDto onboardCustomer(String username, String password){

        List<ApplicationProperty__mdt> aps = [SELECT Appsolutely_Contact_Email__c, Data_Provider_Account_Id__c, Data_Provider_Account_Comment__c FROM ApplicationProperty__mdt LIMIT 1];
        if (aps.size() < 0) throw new CCException(System.Label.Error_Config);
        ApplicationProperty__mdt ap = aps[0];

        Organization orgDetails = [SELECT Id, Address, Fax, Name, Phone FROM Organization WHERE Id = :UserInfo.getOrganizationId()];

        DutchBusinessAccountingDto.UserCreateRequestDto input = new DutchBusinessAccountingDto.UserCreateRequestDto();
        input.nickname = username;
        input.accountId = Integer.valueOf(ap.Data_Provider_Account_Id__c);
        input.password = password; // we can keep this empty so Company.info will generate a new password
        input.email = ap.Appsolutely_Contact_Email__c;
        input.companyname = orgDetails.Name;
        input.address = orgDetails.Address.getStreet() + ', ' + orgDetails.Address.getPostalCode();
        input.contactname = UserInfo.GetName();
        input.contactemail = UserInfo.GetUserEmail();
        input.telephone = orgDetails.Phone;
        input.fax = orgDetails.Fax;
        input.clientcode = ''; // TODO: understand what is this
        input.comments = ap.Data_Provider_Account_Comment__c;
        list<Integer> lst = new list<Integer>();
        lst.add(23); // TODO: this will be implemented sepererately and will be configurable
        input.usergroups = lst;
        try{
            DutchBusinessAccountingDto.userCreateResponseDto userResp = createCIUser(input);
            addTrialToCIUser(userResp);
            Credentials__c cs = Credentials__c.getOrgDefaults();
            cs.Username__c = userResp.nickname;
            cs.Password__c = userResp.password;
            cs.CompanyConnectUserId__c = userResp.id;
            upsert cs;
            return userResp;
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.WSCall_Unknown_Exception);
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
            ErrorLogUtil.logException(e, System.Label.WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }
    } 

    public static boolean addTrialToCIUser(DutchBusinessAccountingDto.userCreateResponseDto userId){// to think about params here
        try{
            ApplicationProperty__mdt configData = [SELECT DataProviderName__c, DefaultTrialBalance__c, DataProviderAdminUsername__c, DataProviderAdminPassword__c FROM ApplicationProperty__mdt WHERE DataProviderName__c = 'Company.Info' LIMIT 1];  
            Double amount = configData.DefaultTrialBalance__c; 
            return addBudget(amount, userId.id);
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.WSCall_Unknown_Exception);
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
            return addBudget(amount, (Integer)cs.CompanyConnectUserId__c);
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }

    }

    public static Double getBalance(){
        DutchBusinessAccountingDto.userViewBalanceRequest input = new DutchBusinessAccountingDto.userViewBalanceRequest();
        try{
            Credentials__c cs = Credentials__c.getOrgDefaults();
            input.userId = (integer)cs.CompanyConnectUserId__c;
            IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
            DutchBusinessAccountingDto.userViewBalanceResponse result = service.userGetBalance(input);
            return result.balance;
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }
    }

    public static Boolean userCheckActive(){
        DutchBusinessAccountingDto.userCheckActiveRequest input = new DutchBusinessAccountingDto.userCheckActiveRequest();
        try{
            Credentials__c cs = Credentials__c.getOrgDefaults();
            input.userId = (integer)cs.CompanyConnectUserId__c;
            IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
            DutchBusinessAccountingDto.userViewV2Response result = service.userCheckActive(input);
            return result.active;
        }catch(Exception e){
            ErrorLogUtil.logException(e, System.Label.WSCall_Unknown_Exception);
            return null; // never happens hence logging throws exceptions
        }
    }
}
