public class WebServicesNLSOAPAccountingImpl extends WebServicesNLSOAPAccountingImplTypes implements IWebServicesNLSOAPAccounting{

    public AccountViewDto accountView(){
        return accountView('');
    }

    public AccountViewDto accountView(String accountId){

        getAuthentication();

        accountViewV2RequestType request_x = new accountViewV2RequestType();
        if(accountid != ''){
            request_x.accountid = Integer.valueOf(accountid);
        }
        
        accountViewV2ResponseType response_x;
        Map<String, accountViewV2ResponseType> response_map_x = new Map<String, accountViewV2ResponseType>();
        response_map_x.put('response_x', response_x);
        system.debug(logginglevel.error, 'this = '+ this);
        system.debug(logginglevel.error, 'request_x = '+ request_x);
        system.debug(logginglevel.error, 'response_map_x = '+ response_map_x);
        system.debug(logginglevel.error, 'some string thing' + new String[]{endpoint_x,
            'https://ws1.webservices.nl/soap_doclit.php/accountViewV2',
            'http://www.webservices.nl/soap/',
            'accountViewV2',
            'http://www.webservices.nl/soap/',
            'accountViewV2Response',
            'accountViewV2ResponseType'});

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(this));
            system.debug(logginglevel.error, 'Key values are here ********');
            for(String key: m.keySet()){
                system.debug(logginglevel.error, 'key = '+ m.get(key));
            }

            
        WebServiceCallout.invoke(
            this,
            request_x,
            response_map_x,
            new String[]{endpoint_x,
            'https://ws1.webservices.nl/soap_doclit.php/accountViewV2',
            'http://www.webservices.nl/soap/',
            'accountViewV2',
            'http://www.webservices.nl/soap/',
            'accountViewV2Response',
            'accountViewV2ResponseType'}
        );   
        response_x = response_map_x.get('response_x');
        AccountViewDto result = new AccountViewDto();
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

}