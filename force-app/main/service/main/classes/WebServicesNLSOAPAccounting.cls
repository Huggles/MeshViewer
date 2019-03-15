public class WebServicesNLSOAPAccounting {


    public AccountViewDto accountView(){
        return newInstance().accountView();
    }

    public AccountViewDto accountView(String accountId){
        return newInstance().accountView(accountId);
    }

    public static IWebServicesNLSOAPAccounting newInstance() {
        return (IWebServicesNLSOAPAccounting) Application.Service.newInstance(IWebServicesNLSOAPAccounting.class);
    }


}
