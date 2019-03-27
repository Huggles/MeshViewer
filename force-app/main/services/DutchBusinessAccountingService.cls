public with sharing class DutchBusinessAccountingService {

    // Onboarding of the new customer. First new user is created and then the trial budged is added; customerDossierNumber is the only param required
    public static DutchBusinessAccountingDto.userCreateResponseDto onboardCustomer(String customerDossierNumber){
        DutchBusinessAccountingDto.UserCreateRequestDto input = new DutchBusinessAccountingDto.UserCreateRequestDto();
        input.nickname = customerDossierNumber;
        input.accountId = 13972; //TODO: get the account ID from Custom Settings or CMT
        input.password = ''; // we keep this empty so CompanyInfo will generate a new password
        input.email = 'valerijs.prokudins@appsolutely.nl'; // TODO get the email address from custom setting or CMT
        input.companyname = 'AppsolutelysCustomer'; // TODO: understand how to get the poroper value? Company information obj?
        input.address = '';
        input.contactname = ''; //Take from the current user?
        input.contactemail = input.email; // take from the current user?
        input.telephone = '';
        input.fax = ''; // pretty sure it is not needed
        input.clientcode = ''; // TODO: undertands what is this
        input.comments = 'A user for reselling by Appsolutely. Registered through the CompanyData for Salesforce application';
        list<Integer> lst = new list<Integer>();
        lst.add(23);// TODO: this will be implemented pererately and will be configurable
        input.usergroups = lst;
        DutchBusinessAccountingDto.userCreateResponseDto userResp = createCIUser(input);
        addTrialToCIUser(userResp);
        return userResp;
    }
    
    // creates an integration user for the customer. Gives back the Id of the user in the Company.info backend
    private static DutchBusinessAccountingDto.userCreateResponseDto createCIUser(DutchBusinessAccountingDto.UserCreateRequestDto input){
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        DutchBusinessAccountingDto.userCreateResponseDto response = service.userCreate(input);

        return response;
    }

    private static Integer addTrialToCIUser(DutchBusinessAccountingDto.userCreateResponseDto userId){// to think about params here
        Integer amount; // TODO: get the trial amount from custom settings or CMT
        addBudgetToUser(amount, userId.id);
        return null;
    }

    private static void addBudgetToUser(Integer amount, Integer userId){
        //TODO implement this
    }

}