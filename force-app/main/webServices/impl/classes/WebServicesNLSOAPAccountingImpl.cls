/****************************************************************************************
Author          : ValerijsProkudins
Description     : Company info Accounting integration implementation class. NB: it extends the Accounting implementation type class!
******************************************************************************************/
public class WebServicesNLSOAPAccountingImpl extends WebServicesNLSOAPAccountingImplTypes implements IWebServicesNLSOAPAccounting{

    public AccountViewDto accountView(){
        return accountView('');
    }

    public AccountViewDto accountView(String accountId){

       // getAuthentication();

        accountViewV2RequestType request_x = new accountViewV2RequestType();
        if(accountid != ''){
            request_x.accountid = Integer.valueOf(accountid);
        }
        
        accountViewV2ResponseType response_x;
        Map<String, accountViewV2ResponseType> response_map_x = new Map<String, accountViewV2ResponseType>();
        response_map_x.put('response_x', response_x);
        
        //Webservices_nlPort port = new Webservices_nlPort();
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