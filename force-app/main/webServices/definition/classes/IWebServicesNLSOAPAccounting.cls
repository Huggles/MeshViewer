/****************************************************************************************
Author          : ValerijsProkudins
Description     : Interface class for CompanyInfo Accounting webservice layer
******************************************************************************************/
public interface IWebServicesNLSOAPAccounting  extends IWebServicesNLSOAP{

    AccountViewDto accountView();
    AccountViewDto accountView(String accountId);
    UserCreateResponseDto userCreate(UserCreateInputDto input);
}
