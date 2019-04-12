/****************************************************************************************
Author          : ValerijsProkudins
Description     : Application class. Please refer to fflib docs or https://quirkyapex.com/2017/12/03/fflib-application-structure/
******************************************************************************************/
public with sharing class Application {

    // Configure and create the UnitOfWorkFactory for this Application
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
        new fflib_Application.UnitOfWorkFactory(
            new List < SObjectType > {
                User.SObjectType
                });

    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service =
            new fflib_Application.ServiceFactory(
                    new Map<Type, Type>{
                            IWebservicesNlSOAP.class => WebservicesNlSOAPImpl.class,
                            IWebServicesNLSOAPAccounting.class => WebServicesNLSOAPAccountingImpl.class,
                            IWebServicesNLSOAPDutchBusiness.class => WebServicesNLSOAPDutchBusinessImpl.class
                    });

    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector =
        new fflib_Application.SelectorFactory(
            new Map < SObjectType, Type > {
                User.SObjectType => UserSelector.class
                });
}
