/****************************************************************************************
Author          : ValerijsProkudins
Description     : Company Connect Accounting integration implementation class. NB: it extends the Accounting implementation type class!
                  All original Company.Connect methods are wrapped into our methods to provide DTO wrapping for both request and response params.
                  This is done to completely isolate webservice layer from the service layer. This will allow to adapt to webservice changes/updates quickly and without too much effort.
******************************************************************************************/
// TODO: remove the extension. This class doesn't use anything of the Types class (rightfully so)
// TODO: extract types from super class and remove super class + dependencies
public with sharing class WebServicesNLSOAPAccountingImpl extends WebServicesNLSOAPAccountingImplTypes implements IWebServicesNLSOAPAccounting {

    public WebServicesNLSOAPAccountingImpl() {

    }

    //TODO: check why is this here and not in accounting interface
    public boolean userChangeBalance(DutchBusinessAccountingDto.userChangeBalanceRequestDto input){

        boolean result = false;
        try {
            userEditBalance(input.userId, input.balance);
            result = true;
        } catch(Exception e){
            ErrorLogUtil.logException(e);
            throw new CCException(System.Label.WSCall_ChangeBalance_Exception, e);
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
        WebServicesPort.executeCallout(
                WebServicesPort.ADMIN_SCOPE,
                request_x,
                response_map_x,
                new String[]{port.endpoint_x,
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

    //TODO: check why is this here and not in accounting interface
    public DutchBusinessAccountingDto.userViewBalanceResponse userGetBalance(DutchBusinessAccountingDto.userViewBalanceRequest input){
        DutchBusinessAccountingDto.userViewBalanceResponse result = new DutchBusinessAccountingDto.userViewBalanceResponse();
        try{
            result.balance = userViewBalance(input.userId);
        } catch(Exception e){
            ErrorLogUtil.logException(e);
            throw new CCException(System.Label.WSCall_Unknown_Exception, e);
        }
        return result;
    }

    public Double userViewBalance(Integer userid) {
        userViewBalanceRequestType request_x = new userViewBalanceRequestType();
        request_x.userid = userid;
        userViewBalanceResponseType response_x;
        Map<String, userViewBalanceResponseType> response_map_x = new Map<String, userViewBalanceResponseType>();
        response_map_x.put('response_x', response_x);
        WebServicesPort.executeCallout(
                WebServicesPort.ADMIN_SCOPE,
                request_x,
                response_map_x,
                new String[]{port.endpoint_x,
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

    //TODO: check why is this here and not in accounting interface
    public DutchBusinessAccountingDto.userViewV2Response userCheckActive(DutchBusinessAccountingDto.userCheckActiveRequest input){
        DutchBusinessAccountingDto.userViewV2Response result = new DutchBusinessAccountingDto.userViewV2Response();
        System.debug('userId' + input.userId);
        try{
            if (input.userId != null)
                result.active = userGetDetails(input.userId).out.active;
            else result.active = false;

        }catch(Exception e){
            ErrorLogUtil.logException(e);
            throw new CCException(System.Label.WSCall_Unknown_Exception, e);
        }
        return result;
    }

    public userViewV2ResponseType userGetDetails(Integer userid) {
        userCheckActiveRequestType request_x = new userCheckActiveRequestType();
        request_x.userid = userid;
        userViewV2ResponseType response_x;
        Map<String, userViewV2ResponseType> response_map_x = new Map<String, userViewV2ResponseType>();
        response_map_x.put('response_x', response_x);
        WebServicesPort.executeCallout(
                WebServicesPort.ADMIN_SCOPE,
                request_x,
                response_map_x,
                new String[]{port.endpoint_x,
                        'https://ws1.webservices.nl/soap_doclit.php/userViewV2',
                        'http://www.webservices.nl/soap/',
                        'userViewV2',
                        'http://www.webservices.nl/soap/',
                        'userViewV2Response',
                        'WebServicesNLSOAPAccountingImplTypes.userViewV2ResponseType'}
        );
        response_x = response_map_x.get('response_x');
        return response_x;
    }




// Main method to create a user. Utilises createUserV2 method.

    //TODO: check why is this here and not in accounting interface
    public DutchBusinessAccountingDto.userCreateResponseDto userCreate(DutchBusinessAccountingDto.userCreateRequestDto input){
        
        IntArray arr = new IntArray();
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
        }catch(Exception e){
            ErrorLogUtil.logException(e);
            throw new CCException(System.Label.WSCall_Unknown_Exception, e);
        }
    }

    private userCreateV2ResponseType userCreateV2(Integer accountid,String nickname,String password, intArray usergroups,String email,String companyname,String address,String contactname,String contactemail,String telephone,String fax,String clientcode,String comments) {
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
        WebServicesPort.executeCallout(
                WebServicesPort.ADMIN_SCOPE,
                request_x,
                response_map_x,
                        new String[]{port.endpoint_x,
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

}