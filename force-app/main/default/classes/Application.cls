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
                    Creditsafe_Company_Report_Full__c.SObjectType,
                    Additional_Information_NL_Financial_Item__c.SObjectType,
                    Additional_Information_NL_Kvk_Filing__c.SObjectType,
                    Additional_Info_NL_Letter_Of_Liability__c.SObjectType,
                    Creditsafe_Comp_Additional_Info_Comment__c.SObjectType,
                    Additional_Information_Historical_Event__c.SObjectType,
                    Creditsafe_Comp_Activity_Classifications__c.SObjectType,
                    Creditsafe_Company_Activity__c.SObjectType,
                    Creditsafe_Person_Director__c.SObjectType,
                    Creditsafe_Person_Position__c.SObjectType,
                    Creditsafe_Company_Financial_Statement__c.SObjectType,
                    Creditsafe_Company__c.SObjectType,
                    Creditsafe_Company_Negative_Info_NL__c.SObjectType,
                    Negative_Information_DE_Insolvency_Event__c.SObjectType,
                    Negative_Information_DE_Director_Event__c.SObjectType,
                    Creditsafe_Company_Banker__c.SObjectType,
                    Creditsafe_Company_Advisor__c.SObjectType,
                    Creditsafe_Company_Employee_Information__c.SObjectType,
                    Creditsafe_Company_Share_Holder__c.SObjectType,
                    Creditsafe_Address__c.SObjectType,
                    Creditsafe_Company_Key_Value__c.SObjectType,
                    International_Address__c.SObjectType,
                    PermissionSetAssignment.SObjectType,
                    UserPackageLicense.SObjectType

            });

    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service =
            new fflib_Application.ServiceFactory(
                    new Map<Type, Type>{
                            IWsAccounting.class => WsAccountingImpl.class,
                            IWsDutchBusiness.class => WsDutchBusinessImpl.class,
                            IBusinessAccountingService.class => BusinessAccountingServiceImpl.class,
                            IBusinessService.class => BusinessServiceImpl.class,
                            IWsCreditsafe.class => WsCreditsafeImpl.class,
                            ICreditSafeService.class => CreditSafeServiceImpl.class,
                            IDutchBusinessService.class => DutchBusinessServiceImpl.class,
                            IInternationalAddressService.class => InternationalAddressImpl.class,
                            IWsInternationalAddress.class => WsInternationalAddressImpl.class,
                            IWsVat.class => WsVatImpl.class,
                            ISetupService.class => SetupServiceImpl.class,
                            IDuplicateManagement.class => DuplicateManagementServiceImpl.class,
                            ILicenseManagementService.class => LicenseManagementServiceImpl.class
                    });

    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector =
        new fflib_Application.SelectorFactory(
            new Map < SObjectType, Type > {
                    Account.SObjectType => AccountSelector.class,
                    Business_Dossier__c.SObjectType => BusinessDossierSelector.class,
                    Business_Data_SBI__c.SObjectType => SbiCodeSelector.class,
                    User.SObjectType => UserSelector.class,
                    PackageLicense.SObjectType => PackageLicenseSelector.class,
                    PermissionSetAssignment.SObjectType => PermissionSetAssignmentSelector.class,
                    UserPackageLicense.SObjectType => UserPackageSelector.class,
                    International_Address__c.SObjectType => InternationalAddressSelector.class,
                    PermissionSet.SObjectType => PermissionSetSelector.class
            });

}
