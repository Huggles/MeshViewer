@isTest
public with sharing class DutchBusinessServiceImplTest {
    
    @isTest
    public static void testGetDossier(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        
        mocks.startStubbing();
        //DutchBusinessDto.DutchBusinessGetDossierRequest requestParams = new DutchBusinessDto.DutchBusinessGetDossierRequest();// = new DutchBusinessDto.DutchBusinessGetDossierRequest(dossier_number = dossierNumber, establishment_number = null);
        DutchBusinessDto.DutchBusinessGetDossierResponse output = new DutchBusinessDto.DutchBusinessGetDossierResponse();

        mocks.when(mockWS.dutchBusinessGetDossier((DutchBusinessDto.DutchBusinessGetDossierRequest)fflib_Match.anyObject())).thenReturn(output);
        
        mocks.stopStubbing();
        Application.Service.setMock(IWebServicesNLSOAPDutchBusiness.class, mockWS);

        test.startTest();
        string dossierNumber = '123';
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessServiceImpl.getDossier(dossierNumber);
        system.assertNotEquals(null, dossier);
        test.stopTest();
    }

    @isTest
    public static void testSearchForDossiers(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        mocks.startStubbing();
        DutchBusinessDto.dutchBusinessSearchParametersRequest searchParams = new DutchBusinessDto.dutchBusinessSearchParametersRequest();
        searchParams.postcode = '2274NA';
        DutchBusinessDto.DutchBusinessSearchParametersResponse output = new DutchBusinessDto.DutchBusinessSearchParametersResponse();
        output.items = new List<DutchBusinessDto.DutchBusinessReference>();
        DutchBusinessDto.DutchBusinessReference dr = new DutchBusinessDto.DutchBusinessReference();
        dr.dossier_number = '199';
        output.items.add(dr);
        mocks.when(mockWS.dutchBusinessSearchParameters((DutchBusinessDto.dutchBusinessSearchParametersRequest)fflib_Match.anyObject())).thenReturn(output);
        mocks.stopStubbing();
        Application.Service.setMock(IWebServicesNLSOAPDutchBusiness.class, mockWS);


        List<DutchBusinessDto.DutchBusinessReference> results = DutchBusinessServiceImpl.searchForDossiers(searchParams);
        system.debug(results);
        system.assertEquals(results.get(0).dossier_number, '199');

    }



    @isTest 
    public static void upsertAccountAndDossierExistingAccountAndDossier(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        IDutchBusinessDossierSelector selectorMockDossier = (IDutchBusinessDossierSelector)mocks.mock(IDutchBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
        IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        
        mocks.startStubbing();

        Account ExistingAccount = new Account(Id=fflib_IDGenerator.generate(Account.SObjectType), Name='Test'); 
        Dutch_Business_Dossier__c ExistingDossier = new Dutch_Business_Dossier__c(Id=fflib_IDGenerator.generate(Dutch_Business_Dossier__c.SObjectType), Name='Test', Dossier_Number__c='123456');
        DutchBusinessDto.DutchBusinessGetDossierResponse InputDossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        InputDossier.dossier_number = '123456';
        InputDossier.legal_name = 'Test';
        InputDossier.trade_name_full = 'Test';
        InputDossier.trade_names = new list<String>{'Test', 'Test2', 'Test3'};



        mocks.when(selectorMockDossier.sObjectType()).thenReturn(Dutch_Business_Dossier__c.SObjectType);
        mocks.when(selectorMockDossier.selectByDossierNumber(new set<String>{InputDossier.dossier_number})).thenReturn(new list<Dutch_Business_Dossier__c>{ExistingDossier});
        mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMockAccount.selectById(new set<Id>{ExistingAccount.Id})).thenReturn(new list<Account>{ExistingAccount});


        mocks.stopStubbing();

        Application.Selector.setMock(selectorMockAccount);
        Application.Selector.setMock(selectorMockDossier);
        Application.UnitOfWork.setMock(uowMock);
        
        test.startTest();

        list<Object> results = DutchBusinessServiceImpl.upsertAccountAndDossier(InputDossier, ExistingAccount.Id);
        system.debug(results);
        test.stopTest();

    }
    @isTest 
    public static void upsertAccountAndDossierNewAccountAndDossier(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        IDutchBusinessDossierSelector selectorMockDossier = (IDutchBusinessDossierSelector)mocks.mock(IDutchBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
        IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        
        mocks.startStubbing();

        //Account ExistingAccount = new Account(Id=fflib_IDGenerator.generate(Account.SObjectType), Name='Test'); 
        //Dutch_Business_Dossier__c ExistingDossier = new Dutch_Business_Dossier__c(Id=fflib_IDGenerator.generate(Dutch_Business_Dossier__c.SObjectType), Name='Test', Dossier_Number__c='123456');
        DutchBusinessDto.DutchBusinessGetDossierResponse InputDossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        InputDossier.dossier_number = '123456';
        InputDossier.legal_name = 'Test';
        InputDossier.trade_name_full = 'Test';
        InputDossier.trade_names = new list<String>{'Test', 'Test2', 'Test3'};



        mocks.when(selectorMockDossier.sObjectType()).thenReturn(Dutch_Business_Dossier__c.SObjectType);
        mocks.when(selectorMockDossier.selectByDossierNumber(new set<String>{InputDossier.dossier_number})).thenReturn(new list<Dutch_Business_Dossier__c>());
        mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
        //mocks.when(selectorMockAccount.selectById(new set<Id>{ExistingAccount.Id})).thenReturn();


        mocks.stopStubbing();

        //Application.Selector.setMock(selectorMockAccount);
        Application.Selector.setMock(selectorMockDossier);
        Application.UnitOfWork.setMock(uowMock);
        
        test.startTest();

        list<Object> results = DutchBusinessServiceImpl.upsertAccountAndDossier(InputDossier, null);
        system.debug(results);
        test.stopTest();

    }
/*
    //DutchBusinessDto.DutchBusinessGetDossierResponse dossier
    public static list<Object> upsertAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){
        
        try{
            list<Object> result = new list<Object>();
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance(new DMLWithCrud());
            list<String> existinAccountIds;
            Account acc = createAccountForDossier(accountId, dossier, unitOfWork);
            Dutch_Business_Dossier__c d = saveDutchBusinessDossierUow(dossier, acc, unitOfWork);
            //unitOfWork.registerRelationship(acc, Account.Dutch_Business_Dossier__c, d);
            unitOfWork.commitWork();
            //unitOfWork.registerDirty(acc, Account.Dutch_Business_Dossier__c, d); // to update a field on account level once dossier is inserted
            //unitOfWork.commitWork(); // need to wait until circullar references are releassed ion fflib. so far using another method link: https://github.com/financialforcedev/fflib-apex-common/pull/195
            result.add(d);
            result.add(acc);
            return result;
        }catch(BdsException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }
    }




    @isTest
    public static upsertAccountAndDossierNewAccount(){

    }

*/

    @isTest
    public static void testGetDossierAccount(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        //fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        //IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        IDutchBusinessDossierSelector selectorMockDossier = (IDutchBusinessDossierSelector)mocks.mock(IDutchBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
    // Given
        mocks.startStubbing();
        String dossierNumber = '40000000';
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
            mocks.when(selectorMockDossier.selectByDossierNumber(new set<String>{dossierNumber})).thenReturn(dossierList);
            mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
            mocks.when(selectorMockAccount.selectById(new set<Id>{acc.Id})).thenReturn(new list<Account>{acc});
            mocks.stopStubbing();
            //Application.UnitOfWork.setMock(uowMock);
            Application.Selector.setMock(selectorMockAccount);
            Application.Selector.setMock(selectorMockDossier);
            //Application.service.setMock(IWebServicesNLSOAPDutchBusiness.class, mockWS);
            test.startTest();
            //IDutchBusinessService service = DutchBusinessService.newInstance();
            Account result = DutchBusinessServiceImpl.getDossierAccount(String.valueOf(dossierNumber));
            system.assertEquals(acc.Id, result.Id);
    }


    /*
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
        
        //mocks.when(mockService.checkForAccountDuplicates((Account)fflib_Match.anyObject())).thenReturn(output);
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
    }*/

}