/****************************************************************************************
Author          : ValerijsProkudins
Description     : Useb by fflib Application class to wire together the servicve definition and implementation
******************************************************************************************/
public class WebServicesNLSOAPAccounting {


    public static AccountViewDto accountView(){
        return newInstance().accountView();
    }

    public static AccountViewDto accountView(String accountId){
        return newInstance().accountView(accountId);
    }

    public static IWebServicesNLSOAPAccounting newInstance() {
        return (IWebServicesNLSOAPAccounting) Application.Service.newInstance(IWebServicesNLSOAPAccounting.class);
    }


}
