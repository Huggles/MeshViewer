@isTest
public with sharing class DutchBusinessServiceImplTest {
    
    @isTest
    public static void testGetDossierAccount(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        //fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        //IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        IDutchBusinessDossierSelector selectorMockDossier = (IDutchBusinessDossierSelector)mocks.mock(IDutchBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
    // Given
        mocks.startStubbing();
        Integer dossierNumber = 40000000;
        Account acc = new Account(
                Name = 'Test',
                Id = fflib_IDGenerator.generate(Account.SObjectType)
            );
            List<Dutch_Business_Dossier__c> dossierList = new List<Dutch_Business_Dossier__c> {
                new Dutch_Business_Dossier__c(
                    Id = fflib_IDGenerator.generate(Dutch_Business_Dossier__c.SObjectType),
                    Name = 'Test',
                    Dossier_Number__c = dossierNumber,
                    Account__c = acc.Id
                )
            };
            mocks.when(selectorMockDossier.sObjectType()).thenReturn(Dutch_Business_Dossier__c.SObjectType);
            mocks.when(selectorMockDossier.selectByDossierNumber(new set<Integer>{dossierNumber})).thenReturn(dossierList);
            mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
            mocks.when(selectorMockAccount.selectById(new set<Id>{acc.Id})).thenReturn(new list<Account>{acc});
            mocks.stopStubbing();
            //Application.UnitOfWork.setMock(uowMock);
            Application.Selector.setMock(selectorMockAccount);
            Application.Selector.setMock(selectorMockDossier);
            //Application.service.setMock(IWebServicesNLSOAPDutchBusiness.class, mockWS);
            test.startTest();
            //IDutchBusinessService service = DutchBusinessService.newInstance();
            Account result = DutchBusinessService.getDossierAccount(String.valueOf(dossierNumber));
            system.assertEquals(acc.Id, result.Id);
    }


    
    @isTest
    public static void testCreateAccountForDossierNewAccountNoDups(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        //IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        IDutchBusinessService mockService = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);
        IDutchBusinessDossierSelector selectorMockDossier = (IDutchBusinessDossierSelector)mocks.mock(IDutchBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
    // Given
        mocks.startStubbing();
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        dossier.trade_name_full = 'test';
        String accountId = '';
        list<String> output = new list<String>();
        Account acc = new Account();
        acc.Name = dossier.trade_name_full;
        
        mocks.when(mockService.checkForAccountDuplicates((Account)fflib_Match.anyObject())).thenReturn(output);
        //mocks.when(mockService.createAccountForDossier(accountId, (DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject(), uowMock)).thenCallRealMethod();

        mocks.stopStubbing();
        Application.service.setMock(IDutchBusinessService.class, mockService);
        test.startTest();


        Account result = DutchBusinessService.createAccountForDossier(accountId, dossier, uowMock); 
        system.debug('result = ' + result);
        system.debug('acc = ' + acc);
        test.stopTest();
        system.assertEquals(result.name, acc.Name);
    }
@isTest
    public static void testCreateAccountForDossierNewAccountWithDuplist(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        //IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        IDutchBusinessService mockService = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);
        IDutchBusinessDossierSelector selectorMockDossier = (IDutchBusinessDossierSelector)mocks.mock(IDutchBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
    // Given
        mocks.startStubbing();
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        dossier.trade_name_full = 'test';
        String accountId = '';
        list<String> output = new list<String>();
        output.add(fflib_IDGenerator.generate(Account.SObjectType));
        output.add(fflib_IDGenerator.generate(Account.SObjectType));
        Account acc = new Account();
        acc.Name = dossier.trade_name_full;
        
        mocks.when(mockService.checkForAccountDuplicates((Account)fflib_Match.anyObject())).thenReturn(output);
        //(Account)fflib_Match.anyObject()
        

        mocks.stopStubbing();
        Application.service.setMock(IDutchBusinessService.class, mockService);
        test.startTest();


        Account result = DutchBusinessService.createAccountForDossier(accountId, dossier, uowMock); 
        test.stopTest();
        system.assertEquals(result.name, acc.Name);
    }

}