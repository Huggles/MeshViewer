/****************************************************************************************
Author          : ValerijsProkudins
Description     : Company info Accounting integration implementation class. NB: it extends the Accounting implementation type class!
                  All original company.info methods are wrapped into our methods to provide DTO wrapping for both request and response params.
                  This is done to completely isolate webservice layer from the service layer. This will allow to adapt to webservice changes/updates quickly and without too much effort.
******************************************************************************************/
public with sharing class WebServicesNLSOAPAccountingImpl extends WebServicesNLSOAPAccountingImplTypes implements IWebServicesNLSOAPAccounting{

    // constructor
    public WebServicesNLSOAPAccountingImpl(){
        //super(); not applicable due to the need of running this service using admin credentials
        port = new Webservices_nlPort('Admin');
    }
    public boolean userChangeBalance(DutchBusinessAccountingDto.userChangeBalanceRequestDto input){

        boolean result = false;
        try{
            userEditBalance(input.userId, input.balance);
            result = true;
        }catch(System.CalloutException ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unsuccessful + ex.getMessage()); // throwing Bds exception further up
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }

        return result;
    }
    public userEditBalanceResponseType userEditBalance(Integer userid,Double balance) {
        userEditBalanceRequestType request_x = new userEditBalanceRequestType();
        request_x.userid = userid;
        request_x.balance = balance;
        userEditBalanceResponseType response_x;
        Map<String, userEditBalanceResponseType> response_map_x = new Map<String, userEditBalanceResponseType>();
        response_map_x.put('response_x', response_x);
        WebServiceCallout.invoke(
            port,
            request_x,
            response_map_x,
            new String[]{endpoint_x,
            'https://ws1.webservices.nl/soap_doclit.php/userEditBalance',
            'http://www.webservices.nl/soap/',
            'userEditBalance',
            'http://www.webservices.nl/soap/',
            'userEditBalanceResponse',
            'WebServicesNLSOAPAccountingImplTypes.userEditBalanceResponseType'}
        );
        response_x = response_map_x.get('response_x');
        return response_x;
    }

    public DutchBusinessAccountingDto.userViewBalanceResponse userGetBalance(DutchBusinessAccountingDto.userViewBalanceRequest input){
        DutchBusinessAccountingDto.userViewBalanceResponse result = new DutchBusinessAccountingDto.userViewBalanceResponse();
        try{
            result.balance = userViewBalance(input.userId);
        }catch(System.CalloutException ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unsuccessful + ex.getMessage()); // throwing Bds exception further up
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }

        return result;
    }
    public Double userViewBalance(Integer userid) {
        userViewBalanceRequestType request_x = new userViewBalanceRequestType();
        request_x.userid = userid;
        userViewBalanceResponseType response_x;
        Map<String, userViewBalanceResponseType> response_map_x = new Map<String, userViewBalanceResponseType>();
        response_map_x.put('response_x', response_x);
        WebServiceCallout.invoke(
            port,
            request_x,
            response_map_x,
            new String[]{endpoint_x,
            'https://ws1.webservices.nl/soap_doclit.php/userViewBalance',
            'http://www.webservices.nl/soap/',
            'userViewBalance',
            'http://www.webservices.nl/soap/',
            'userViewBalanceResponse',
            'WebServicesNLSOAPAccountingImplTypes.userViewBalanceResponseType'}
        );
        response_x = response_map_x.get('response_x');
        return response_x.balance;
    }




// Main method to create a user. Utilises createUserV2 method. 
    public DutchBusinessAccountingDto.userCreateResponseDto userCreate(DutchBusinessAccountingDto.userCreateRequestDto input){
        
        intArray arr = new intArray();
        system.debug(logginglevel.error, '******** input = ' + input);
        arr.item = new List<Integer>();
        if(input.usergroups != null){
            for(Integer value: input.usergroups){
                arr.item.add(value);
            }
        }else{
            //todo: assign all groups or throw exception
        }

        userCreateV2ResponseType response;
        try{
            response = userCreateV2(input.accountId, input.nickname, input.password, arr, input.email, input.companyname, input.address, input.contactname, input.contactemail, input.telephone, input.fax, input.clientcode, input.comments);
            
            DutchBusinessAccountingDto.userCreateResponseDto result = new DutchBusinessAccountingDto.userCreateResponseDto();
            result.id = response.id;
            result.nickname = response.nickname;
            result.password = response.password;
            return result;
        }catch(System.CalloutException ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unsuccessful + ex.getMessage()); // throwing Bds exception further up
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_WSCall_Unknown_Exception+ex.getMessage());
        }
    }

    private userCreateV2ResponseType userCreateV2(Integer accountid,String nickname,String password,intArray usergroups,String email,String companyname,String address,String contactname,String contactemail,String telephone,String fax,String clientcode,String comments) {
        userCreateV2RequestType request_x = new userCreateV2RequestType();
        request_x.accountid = accountid;
        request_x.nickname = nickname;
        request_x.password = password;
        request_x.usergroups = usergroups;
        request_x.email = email;
        request_x.companyname = companyname;
        request_x.address = address;
        request_x.contactname = contactname;
        request_x.contactemail = contactemail;
        request_x.telephone = telephone;
        request_x.fax = fax;
        request_x.clientcode = clientcode;
        request_x.comments = comments;
        userCreateV2ResponseType response_x;
        Map<String, userCreateV2ResponseType> response_map_x = new Map<String, userCreateV2ResponseType>();
        response_map_x.put('response_x', response_x);
        WebServiceCallout.invoke(
            port,
            request_x,
            response_map_x,
            new String[]{endpoint_x,
            'https://ws1.webservices.nl/soap_doclit.php/userCreateV2',
            'http://www.webservices.nl/soap/',
            'userCreateV2',
            'http://www.webservices.nl/soap/',
            'userCreateV2Response',
            'WebServicesNLSOAPAccountingImplTypes.userCreateV2ResponseType'}
        );
        response_x = response_map_x.get('response_x');
        return response_x;
    }





    /*
    public DutchBusinessAccountingDto.AccountViewResponseDto accountView(){
        return accountView('');
    }
// badly designed accountView call. The original webservice method must remain as it was. The wrapper method should utilise DTOs. Will be TODO IF WE USE THIOS WS METHOD IN FUTURE. OTHERWISE TO DELETE
    public DutchBusinessAccountingDto.AccountViewResponseDto accountView(String accountId){
        accountViewV2RequestType request_x = new accountViewV2RequestType();
        if(accountid != ''){
            request_x.accountid = Integer.valueOf(accountid);
        }
        
        accountViewV2ResponseType response_x;
        Map<String, accountViewV2ResponseType> response_map_x = new Map<String, accountViewV2ResponseType>();
        response_map_x.put('response_x', response_x);
        WebServiceCallout.invoke(
            port, // this didn't work, most likely because of the stub class name OR because stub is a subclass originally.
            request_x,
            response_map_x,
            new String[]{endpoint_x,
            'https://ws1.webservices.nl/soap_doclit.php/accountViewV2',
            'http://www.webservices.nl/soap/',
            'accountViewV2',
            'http://www.webservices.nl/soap/',
            'accountViewV2Response', // SOME typename on the remote(not related to our codebase, just something at the ws side)
            'WebServicesNLSOAPAccountingImplTypes.accountViewV2ResponseType'} // typepath in the code. Very important
        );   
        response_x = response_map_x.get('response_x');
        DutchBusinessAccountingDto.AccountViewResponseDto result = new DutchBusinessAccountingDto.AccountViewResponseDto();
        //result.companyInfoId = String.valueOf(response_x.out.id);
        result.companyInfoId = String.valueOf(response_x.out.id);
        result.Name = response_x.out.name;
        result.Address = response_x.out.address;
        result.Environment = response_x.out.environment;
        result.isReseller = response_x.out.reseller;
        result.ContactName = response_x.out.contactname;
        result.ContactEmail = response_x.out.contactemail;
        result.Telephone = response_x.out.telephone;
        result.Fax = response_x.out.fax;
        result.Description = response_x.out.description;
        result.CreationTime = response_x.out.creationtime;
        result.LastModified = response_x.out.lastmodified;
        result.ClientCode = response_x.out.clientcode;
        result.Comments = response_x.out.comments;
        result.UsernamePrefix = response_x.out.usernameprefix;
        result.Balance = response_x.out.balance;
        result.BalanceTreshold = response_x.out.balancethreshold;

        return result;
    }
*/
}