/****************************************************************************************
Author          : ValerijsProkudins
Description     : Useb by fflib Application class to wire together the servicve definition and implementation
******************************************************************************************/
public class WebservicesNlSOAP {
 
   /* public static void getAuthentication(){
        newInstance().getAuthentication();
    }*/

    public static IWebservicesNlSOAP newInstance() {
        return (IWebservicesNlSOAP) Application.Service.newInstance(IWebservicesNlSOAP.class);
    }

}