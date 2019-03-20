public class WebservicesNlSOAP {
 
   /* public static void getAuthentication(){
        newInstance().getAuthentication();
    }*/

    private static IWebservicesNlSOAP newInstance() {
        return (IWebservicesNlSOAP) Application.Service.newInstance(IWebservicesNlSOAP.class);
    }

}