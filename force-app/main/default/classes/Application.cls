/****************************************************************************************
Author          : ValerijsProkudins
Description     : Application class. Please refer to fflib docs or https://quirkyapex.com/2017/12/03/fflib-application-structure/
******************************************************************************************/
public inherited sharing class Application {

    // Configure and create the UnitOfWorkFactory for this Application
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
        new fflib_Application.UnitOfWorkFactory(
            new List < SObjectType > {
                    User.SObjectType,
                    Account.SObjectType,
                    Business_Dossier__c.SObjectType,
                    Business_Data_SBI__c.SObjectType,
                    Dossier_Address__c.SObjectType
            });

    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service =
            new fflib_Application.ServiceFactory(
                    new Map<Type, Type>{
                            IWsAccounting.class => WsAccountingImpl.class,
                            IWsDutchBusiness.class => WsDutchBusinessImpl.class,
                            IBusinessAccountingService.class => BusinessAccountingServiceImpl.class,
                            IBusinessService.class => BusinessServiceImpl.class,
                            IBusinessDuplicateService.class => BusinessDuplicateServiceImpl.class,
                            IWsCreditsafe.class => WsCreditsafeImpl.class,
                            ICreditSafeService.class => CreditSafeServiceImpl.class,
                            IInternationalAddressService.class => InternationalAddressImpl.class,
                            IWsInternationalAddress.class => WsInternationalAddressImpl.class

                    });

    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector =
        new fflib_Application.SelectorFactory(
            new Map < SObjectType, Type > {
                    Account.SObjectType => AccountSelector.class,
                    Business_Dossier__c.SObjectType => BusinessDossierSelector.class,
                    Dossier_Address__c.SObjectType => DossierAddressSelector.class,
                    Business_Data_SBI__c.SObjectType => SbiCodeSelector.class
            });


}
