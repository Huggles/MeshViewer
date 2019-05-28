/****************************************************************************************
Author          : ValerijsProkudins
Description     : Application class. Please refer to fflib docs or https://quirkyapex.com/2017/12/03/fflib-application-structure/
******************************************************************************************/
public with sharing class Application {
    private static SavePoint sp;
    public static void getSavePoint(){
        if(sp == null){
            sp = Database.setSavepoint();
        }
    }
    public static void rollback(){
        if(sp != null){
            Database.rollback(sp);
        }
    }

    // Configure and create the UnitOfWorkFactory for this Application
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
        new fflib_Application.UnitOfWorkFactory(
            new List < SObjectType > {
                User.SObjectType,
                Account.SObjectType,
                Dutch_Business_Dossier__c.SObjectType
                });

    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service =
            new fflib_Application.ServiceFactory(
                    new Map<Type, Type>{
                            IWebservicesNlSOAP.class => WebservicesNlSOAPImpl.class,
                            IWebServicesNLSOAPAccounting.class => WebServicesNLSOAPAccountingImpl.class,
                            IWebServicesNLSOAPDutchBusiness.class => WebServicesNLSOAPDutchBusinessImpl.class,
                            IDutchBusinessAccountingService.class => DutchBusinessAccountingServiceImpl.class,
                            IDutchBusinessService.class => DutchBusinessServiceImpl.class
                    });

    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector =
        new fflib_Application.SelectorFactory(
            new Map < SObjectType, Type > {
                User.SObjectType => UserSelector.class,
                Account.SObjectType => AccountSelector.class,
                Dutch_Business_Dossier__c.SObjectType => DutchBusinessDossierSelector.class
                });


}
