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
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessService.getDossier(dossierNumber);
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


        List<DutchBusinessDto.DutchBusinessReference> results = DutchBusinessService.searchForDossiers(searchParams);
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

        list<Object> results = DutchBusinessService.upsertAccountAndDossier(InputDossier, ExistingAccount.Id);
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

        list<Object> results = DutchBusinessService.upsertAccountAndDossier(InputDossier, null);
        system.debug(results);
        test.stopTest();

    }

    @isTest
    public static void testSaveDutchBusinessDossierUow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        IDutchBusinessDossierSelector selectorMockDossier = (IDutchBusinessDossierSelector)mocks.mock(IDutchBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
        IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);

        mocks.startStubbing();

        //Account ExistingAccount = new Account(Id=fflib_IDGenerator.generate(Account.SObjectType), Name='Test');
        //Dutch_Business_Dossier__c ExistingDossier = new Dutch_Business_Dossier__c(Id=fflib_IDGenerator.generate(Dutch_Business_Dossier__c.SObjectType), Name='Test', Dossier_Number__c='123456');
        DutchBusinessDto.DutchBusinessGetDossierResponse InputDossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();

        InputDossier.annual_financial_statement_summary = 'summary';
        InputDossier.authorized_share_capital = 12;
        InputDossier.authorized_share_capital_currency = 'test';
        InputDossier.chamber_number = '1';
        InputDossier.class_personnel_ci = 1;
        InputDossier.class_personnel_fulltime = 1;
        InputDossier.class_personnel = 1;
        InputDossier.contact_gender = 'm';
        InputDossier.contact_initials = 'test';
        InputDossier.contact_prefix = 'test';
        InputDossier.contact_surname = 'test';
        InputDossier.contact_title1 = 'test';
        InputDossier.contact_title2 = 'test';
        InputDossier.continuation_date = Date.valueOf('2019-2-12');
        InputDossier.correspondence_address_official_address = 'test';
        InputDossier.discontinuation_date = Date.valueOf('2019-2-12');
        InputDossier.domain_name = 'test';
        InputDossier.dossier_number = '123456';
        InputDossier.establishment_address_official_address = 'test';
        InputDossier.establishment_date = Date.valueOf('2019-2-12');
        InputDossier.establishment_number = '1';
        InputDossier.founding_date = Date.valueOf('2019-2-12');
        InputDossier.indication_bankruptcy = false;
        InputDossier.indication_dip = false;
        InputDossier.indication_economically_active = false;
        InputDossier.indication_export = false;
        InputDossier.indication_import = true;
        InputDossier.indication_main_establishment = false;
        InputDossier.indication_main_establishment = true;
        InputDossier.indication_non_mailing = false;
        InputDossier.insolvencies = 'test';
        InputDossier.issued_share_capital_currency = 'test';
        InputDossier.issued_share_capital = 12334234;
        InputDossier.legal_form_text = 'test';
        InputDossier.legal_name = 'Test';
        InputDossier.mobile_number = '12334234';
        InputDossier.paid_up_share_capital_currency = 'test';
        InputDossier.paid_up_share_capital = 12334234;
        InputDossier.personnel = 1;
        InputDossier.personnel_ci = 1;
        InputDossier.personnel_ci_reference_date = Date.valueOf('2019-2-12');
        InputDossier.personnel_fulltime = 1;
        InputDossier.personnel_reference_date = Date.valueOf('2019-2-12');
        InputDossier.primary_sbi_code = 'test';
        InputDossier.primary_sbi_code_text = 'test';
        InputDossier.sbi_collection = 'test';
        InputDossier.structure = 'test';
        InputDossier.telephone_number = '12334234';
        InputDossier.trade_name_full = 'Test';
        InputDossier.establishment_number = '12334234';
        InputDossier.indication_organisation_code = '1';
        InputDossier.legal_form_code = '1';
        InputDossier.main_establishment_number = '1';
        InputDossier.rsin_number = '1';
        InputDossier.secondary_sbi_code1 = 'test';
        InputDossier.secondary_sbi_code1_text = 'test';
        InputDossier.secondary_sbi_code2 = 'test';
        InputDossier.secondary_sbi_code2_text = 'test';
        InputDossier.trade_name_45 = '1';
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
        list<Object> results = DutchBusinessService.upsertAccountAndDossier(InputDossier, null);
        test.stopTest();
        Dutch_Business_Dossier__c d = (Dutch_Business_Dossier__c) results.get(0);
        System.assertEquals(d.Annual_Financial_Statement_Summary__c,'summary');
        System.assertEquals(d.Authorized_Share_Capital__c, 12);
        System.assertEquals(d.Authorized_Share_Capital_Currency__c, 'test');
        System.assertEquals(d.Chamber_Number__c , '1');
        System.assertEquals(d.Class_Personnel__c , '1');
        System.assertEquals(d.Class_Personnel_CI__c , '1');
        System.assertEquals(d.Class_Personnel_Fulltime__c , '1');
        System.assertEquals(d.Contact_Gender__c , 'm');
        System.assertEquals(d.Contact_Initials__c , 'test');
        System.assertEquals(d.Contact_Prefix__c , 'test');
        System.assertEquals(d.Contact_Surname__c , 'test');
        System.assertEquals(d.Contact_Title1__c , 'test');
        System.assertEquals(d.Contact_Title2__c , 'test');
        System.assertEquals(d.Continuation_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Correspondence_Address__c , 'test');
        System.assertEquals(d.Discontinuation_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Domain_Name__c , 'test');
        System.assertEquals(d.Dossier_Number__c , '123456');
        System.assertEquals(d.Establishment_Address__c , 'test');
        System.assertEquals(d.Establishment_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Establishment_Number__c , 12334234);
        System.assertEquals(d.Founding_Date__c, Date.valueOf('2019-2-12'));
        System.assertEquals(d.Indication_Main_Establishment__c , true);
        System.assertEquals(d.Indication_Organisation_Code__c , '1');
        System.assertEquals(d.Insolvencies__c , 'test');
        System.assertEquals(d.Issued_Share_Capital__c , 12334234);
        System.assertEquals(d.Issued_Share_Capital_Currency__c , 'test');
        System.assertEquals(d.Legal_Form_Code__c , 1);
        System.assertEquals(d.Legal_Form_Text__c , 'test');
        System.assertEquals(d.Main_Establishment_Number__c , 1);
        System.assertEquals(d.Mobile_Number__c , '12334234');
        System.assertEquals(d.Paid_Up_Share_Capital__c , 12334234);
        System.assertEquals(d.Paid_Up_Share_Capital_Currency__c , 'test');
        System.assertEquals(d.Personnel__c , 1);
        System.assertEquals(d.Personnel_CI__c , 1);
        System.assertEquals(d.Personnel_CI_Reference_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Personnel_Fulltime__c , 1);
        System.assertEquals(d.Personnel_Reference_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Primary_Sbi_Code__c , 'test');
        System.assertEquals(d.Primary_Sbi_Code_Text__c , 'test');
        System.assertEquals(d.Rsin_Number__c , 1);
        System.assertEquals(d.Sbi_Collection__c , 'test');
        System.assertEquals(d.Secondary_Sbi_Code_1__c , 'test');
        System.assertEquals(d.Secondary_Sbi_Code_1_Text__c , 'test');
        System.assertEquals(d.Secondary_Sbi_Code_2__c, 'test');
        System.assertEquals(d.Secondary_Sbi_Code_2_Text__c , 'test');
        System.assertEquals(d.Status__c , 'Import');
        System.assertEquals(d.Structure__c , 'test');
        System.assertEquals(d.Telephone_Number__c , '12334234');
        System.assertEquals(d.Trade_Name_45__c , '1');
        System.assertEquals(d.Trade_Name_Full__c , 'Test');
        System.assertNotEquals(d.Trade_Names__c , 'test');
        System.assertEquals(d.Indication_Bankruptcy__c , false);
        System.assertEquals(d.Indication_Dip__c , false);
        System.assertEquals(d.Indication_Economically_Active__c , false);
        System.assertEquals(d.Indication_Export__c , false);
        System.assertEquals(d.Indication_Import__c, true);
        System.assertEquals(d.Indication_Main_Establishment__c , true);
        System.assertEquals(d.Indication_Non_Mailing__c , false);





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
        Account result = DutchBusinessService.getDossierAccount(String.valueOf(dossierNumber));
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