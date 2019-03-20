/****************************************************************************************
Author          : ValerijsProkudins
Description     : Application class. Please refer to fflib docs or https://quirkyapex.com/2017/12/03/fflib-application-structure/
******************************************************************************************/
public with sharing class Application {


    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service =
            new fflib_Application.ServiceFactory(
                    new Map<Type, Type>{
                            IWebservicesNlSOAP.class => WebservicesNlSOAPImpl.class,
                            IWebServicesNLSOAPAccounting.class => WebServicesNLSOAPAccountingImpl.class,
                            IWebServicesNLSOAPDutchBusiness.class => WebServicesNLSOAPDutchBusinessImpl.class
                    });
}
