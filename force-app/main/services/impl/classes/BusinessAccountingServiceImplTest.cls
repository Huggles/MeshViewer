@isTest
public with sharing class BusinessAccountingServiceImplTest {
    @TestSetup
    private static void setupData() {
        Credentials__c c = new Credentials__c();
        c.Username__c = 'test';
        c.Password__c = 'pas';
        c.CompanyInfo_Account_Id__c = '1';
        c.CompanyConnectUserId__c = 11;
        c.Last_Executed_Batch__c = Datetime.newInstance(2019, 7, 28);

        insert c;
    }

    @IsTest
    public static void saveDataUserCredentialsPositveTest() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);

        mocks.startStubbing();
        AccountingWsdl.UserV2PagedResult output = new AccountingWsdl.UserV2PagedResult();
        output.results = new AccountingWsdl.UserV2Array();
        output.results.item = new List<AccountingWsdl.UserV2>();
        AccountingWsdl.UserV2 a = new AccountingWsdl.UserV2();
        a.id = 12;
        output.results.item.add(a);
        Integer accountId = 13972;
        mocks.when(mockWS.accountUserSearchV2(accountId, 'test', 1)).thenReturn(output);
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        test.startTest();
        BusinessAccountingService.saveDataUserCredentials('test', 'pas');
        test.stopTest();

        Credentials__c c = Credentials__c.getOrgDefaults();
        System.assertEquals(c.CompanyConnectUserId__c, 12);
    }

    @IsTest
    public static void saveDataUserCredentialsExceptionTest() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);

        mocks.startStubbing();
        AccountingWsdl.UserV2PagedResult output = new AccountingWsdl.UserV2PagedResult();
        output.results = new AccountingWsdl.UserV2Array();
        Integer accountId = 13972;
        mocks.when(mockWS.accountUserSearchV2(accountId, 'test', 1)).thenReturn(output);
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        try {
            test.startTest();
            BusinessAccountingService.saveDataUserCredentials('test', 'pas');
            test.stopTest();
        } catch(Exception e)
        {
            System.assert(e instanceof CCUserNotFoundException);
            System.assertEquals(Label.Error_user_not_found, e.getMessage());
        }
    }

    @isTest
    public static void onboardCustomerHappyTest(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);
        AccountingWsdl.userCreateV2ResponseType output = new AccountingWsdl.userCreateV2ResponseType();
        output.id = 1;
        Integer accountId = 13972;
        String username = 'test';
        String password = 'pas';
        Organization orgDetails = [SELECT Id, Address, Fax, Name, Phone FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
        AccountingWsdl.UserV2PagedResult output1 = new AccountingWsdl.UserV2PagedResult();
        output1.results = new AccountingWsdl.UserV2Array();
        output1.results.item = new List<AccountingWsdl.UserV2>();
        AccountingWsdl.UserV2 a = new AccountingWsdl.UserV2();
        a.id = 12;
        output1.results.item.add(a);

        mocks.startStubbing();
        mocks.when(mockWS.userCreateV2(accountId, username, password, BusinessAccountingServiceImpl.usergroups, 'incident@appsolutely.nl',
                orgDetails.Name, orgDetails.Address.getStreet() + ', ' + orgDetails.Address.getPostalCode(),
                UserInfo.getName(), UserInfo.getUserEmail(), orgDetails.Phone, orgDetails.Fax, '', '')).thenReturn(output);
        mocks.when(mockWS.accountUserSearchV2(accountId, 'test', 1)).thenReturn(output1);
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        test.startTest();
        BusinessAccountingService.onboardCustomer(username, password);
        test.stopTest();
        System.assertEquals(output.id, 1);

    }

    @isTest
    public static void testGetUserOnboardedFail(){
        delete Credentials__c.getOrgDefaults();
        Test.startTest();
        Boolean a = BusinessAccountingService.getUserOnboarded();
        Test.stopTest();

        System.assertEquals(false, a);
    }

    @isTest
    public static void testGetUserOnboardedSuccess(){
        Test.startTest();
        Boolean a = BusinessAccountingService.getUserOnboarded();
        Test.stopTest();

        System.assertEquals(a, true);
    }

    @isTest
    public static void testAddBudget(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);
        mocks.startStubbing();
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        Test.startTest();
        BusinessAccountingService.addBudget(10);
        Integer callouts = Limits.getCallouts();
        Test.stopTest();

        System.assertNotEquals(1, callouts);
    }

    @isTest
    public static void testGetBalancePositive(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);
        mocks.startStubbing();
        mocks.when(mockWS.userViewBalance(11)).thenReturn(10.00);
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        Test.startTest();
        Double balance = BusinessAccountingService.getBalance();
        Test.stopTest();

        System.assertEquals(10.00, balance);
    }

    @isTest
    public static void testGetBalanceNegative(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);
        mocks.startStubbing();
        mocks.when(mockWS.userViewBalance(11)).thenReturn(10.00);
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        Test.startTest();
        delete Credentials__c.getOrgDefaults();
        Double balance = BusinessAccountingService.getBalance();
        Test.stopTest();

        System.assertEquals(null, balance);
    }

    @isTest
    public static void testuserCheckActivePositive(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);
        AccountingWsdl.UserV2 user = new AccountingWsdl.UserV2();
        user.active = true;
        mocks.startStubbing();
        mocks.when(mockWS.userViewV2(11)).thenReturn(user);
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        Test.startTest();
        Boolean isActive = BusinessAccountingService.userCheckActive();
        Test.stopTest();

        System.assertEquals(true, isActive);
    }

    @isTest
    public static void testuserCheckActiveNegative(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);
        AccountingWsdl.UserV2 user = new AccountingWsdl.UserV2();
        user.active = true;
        mocks.startStubbing();
        mocks.when(mockWS.userViewV2(11)).thenReturn(user);
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        Test.startTest();
        delete Credentials__c.getOrgDefaults();
        Boolean isActive = BusinessAccountingService.userCheckActive();
        Test.stopTest();

        System.assertEquals(false, isActive);
    }

    @isTest
    public static void testuserCheckActiveException(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsAccounting mockWS = (IWsAccounting)mocks.mock(IWsAccounting.class);
        mocks.startStubbing();
        mocks.when(mockWS.userViewV2(11)).thenThrow(new CustomException());
        mocks.stopStubbing();
        Application.Service.setMock(IWsAccounting.class, mockWS);

        Boolean isActive;
        try {
            Test.startTest();
            isActive = BusinessAccountingService.userCheckActive();
            Test.stopTest();
        }catch (Exception e){
            System.assert(e instanceof CustomException);
        }
        System.assertEquals(null, isActive);
    }
}