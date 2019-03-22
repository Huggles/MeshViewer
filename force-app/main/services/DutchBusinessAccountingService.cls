public with sharing class DutchBusinessAccountingService {

    // Onboarding of the new customer. First new user is created and then the trial budged is added; customerDossierNumber is the only param required
    public static void onboardCustomer(String customerDossierNumber){
        UserCreateInputDto input = new UserCreateInputDto();
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
        input.comments = 'A user for reselling by Appsolutely. Registered through the CompanyDate for Salesforce application';
        Integer userId;
        userId = createCIUser(input);
        addTrialToCIUser(userId);
    }
    
    // creates an integration user for the customer. Gives back the Id of the user in the Company.info backend
    private static Integer createCIUser(UserCreateInputDto input){
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        service.userCreate(input);

        return null;
    }

    private static Integer addTrialToCIUser(Integer userId){
        Integer amount; // TODO: get the trial amount from custom settings or CMT
        addBudgetToUser(amount, userId);
        return null;
    }

    private static void addBudgetToUser(Integer amount, Integer userId){
        //TODO implement this
    }

}