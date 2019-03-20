public interface IWebServicesNLSOAPAccounting  extends IWebServicesNLSOAP{


    AccountViewDto accountView();
    AccountViewDto accountView(String accountId);

}
