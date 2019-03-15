public  class Application {


    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service =
            new fflib_Application.ServiceFactory(
                    new Map<Type, Type>{
                            IWebservicesNlSOAP.class => WebservicesNlSOAPImpl.class,
                            IWebServicesNLSOAPAccounting.class => WebServicesNLSOAPAccountingImpl.class
                    });

 
}
