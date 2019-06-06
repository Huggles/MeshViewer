@isTest
public with sharing class BusinessServiceImplTest {

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
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier = BusinessService.getDossier(dossierNumber);
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


        List<DutchBusinessDto.DutchBusinessReference> results = BusinessService.searchForDossiers(searchParams);
        system.debug(results);
        system.assertEquals(results.get(0).dossier_number, '199');

    }



    @isTest
    public static void upsertAccountAndDossierExistingAccountAndDossier(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
        IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);

        mocks.startStubbing();

        Account ExistingAccount = new Account(Id=fflib_IDGenerator.generate(Account.SObjectType), Name='Test');
        Business_Dossier__c ExistingDossier = new Business_Dossier__c(Id=fflib_IDGenerator.generate(Business_Dossier__c.SObjectType), Name='Test', Dossier_Number__c='123456');
        DutchBusinessDto.DutchBusinessGetDossierResponse InputDossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        InputDossier.dossier_number = '123456';
        InputDossier.legal_name = 'Test';
        InputDossier.trade_name_full = 'Test';
        InputDossier.trade_names = new list<String>{'Test', 'Test2', 'Test3'};



        mocks.when(selectorMockDossier.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(selectorMockDossier.selectByDossierNumber(new set<String>{InputDossier.dossier_number})).thenReturn(new list<Business_Dossier__c>{ExistingDossier});
        mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMockAccount.selectById(new set<Id>{ExistingAccount.Id})).thenReturn(new list<Account>{ExistingAccount});


        mocks.stopStubbing();

        Application.Selector.setMock(selectorMockAccount);
        Application.Selector.setMock(selectorMockDossier);
        Application.UnitOfWork.setMock(uowMock);

        test.startTest();

        list<Object> results = BusinessService.upsertAccountAndDossier(InputDossier, ExistingAccount.Id);
        system.debug(results);
        test.stopTest();

    }
    @isTest
    public static void upsertAccountAndDossierNewAccountAndDossier(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
        IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);

        mocks.startStubbing();

        //Account ExistingAccount = new Account(Id=fflib_IDGenerator.generate(Account.SObjectType), Name='Test'); 
        //Business_Dossier__c ExistingDossier = new Business_Dossier__c(Id=fflib_IDGenerator.generate(Business_Dossier__c.SObjectType), Name='Test', Dossier_Number__c='123456');
        DutchBusinessDto.DutchBusinessGetDossierResponse InputDossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        InputDossier.dossier_number = '123456';
        InputDossier.legal_name = 'Test';
        InputDossier.trade_name_full = 'Test';
        InputDossier.trade_names = new list<String>{'Test', 'Test2', 'Test3'};



        mocks.when(selectorMockDossier.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(selectorMockDossier.selectByDossierNumber(new set<String>{InputDossier.dossier_number})).thenReturn(new list<Business_Dossier__c>());
        mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
        //mocks.when(selectorMockAccount.selectById(new set<Id>{ExistingAccount.Id})).thenReturn();


        mocks.stopStubbing();

        //Application.Selector.setMock(selectorMockAccount);
        Application.Selector.setMock(selectorMockDossier);
        Application.UnitOfWork.setMock(uowMock);

        test.startTest();

        list<Object> results = BusinessService.upsertAccountAndDossier(InputDossier, null);
        system.debug(results);
        test.stopTest();

    }

    @isTest
    public static void testSaveBusinessDossierUow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
        IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);

        mocks.startStubbing();

        //Account ExistingAccount = new Account(Id=fflib_IDGenerator.generate(Account.SObjectType), Name='Test');
        //Business_Dossier__c ExistingDossier = new Business_Dossier__c(Id=fflib_IDGenerator.generate(Business_Dossier__c.SObjectType), Name='Test', Dossier_Number__c='123456');
        DutchBusinessDto.DutchBusinessGetDossierResponse InputDossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();

        InputDossier.annual_financial_statement_summary = 'summary';
        InputDossier.authorized_share_capital = 12;
        InputDossier.authorized_share_capital_currency = 'authorized_share_capital_currency';
        InputDossier.chamber_number = '1';
        InputDossier.class_personnel_ci = 1;
        InputDossier.class_personnel_fulltime = 1;
        InputDossier.class_personnel = 1;
        InputDossier.contact_gender = 'm';
        InputDossier.contact_initials = 'initial';
        InputDossier.contact_prefix = 'prefix';
        InputDossier.contact_surname = 'surname';
        InputDossier.contact_title1 = 'title1';
        InputDossier.contact_title2 = 'title2';
        InputDossier.continuation_date = Date.valueOf('2019-2-12');
        InputDossier.correspondence_address_official_address = 'correspondence_address';
        InputDossier.discontinuation_date = Date.valueOf('2019-2-12');
        InputDossier.domain_name = 'domain_name';
        InputDossier.dossier_number = '123456';
        InputDossier.establishment_address_official_address = 'establishment_address';
        InputDossier.establishment_date = Date.valueOf('2019-2-12');
        InputDossier.establishment_number = '10';
        InputDossier.founding_date = Date.valueOf('2019-2-12');
        InputDossier.indication_bankruptcy = false;
        InputDossier.indication_dip = false;
        InputDossier.indication_economically_active = false;
        InputDossier.indication_export = false;
        InputDossier.indication_import = true;
        InputDossier.indication_main_establishment = false;
        InputDossier.indication_main_establishment = true;
        InputDossier.indication_non_mailing = false;
        InputDossier.insolvencies = 'insolvencies';
        InputDossier.issued_share_capital_currency = 'issued_share_capital_currency';
        InputDossier.issued_share_capital = 12334234;
        InputDossier.legal_form_text = 'legal_form';
        InputDossier.legal_name = 'legal_name';
        InputDossier.mobile_number = '12334234';
        InputDossier.paid_up_share_capital_currency = 'paid_up_share_capital_currency';
        InputDossier.paid_up_share_capital = 12334234;
        InputDossier.personnel = 1;
        InputDossier.personnel_ci = 1;
        InputDossier.personnel_ci_reference_date = Date.valueOf('2019-2-12');
        InputDossier.personnel_fulltime = 1;
        InputDossier.personnel_reference_date = Date.valueOf('2019-2-12');
        InputDossier.primary_sbi_code = 'sbi_code';
        InputDossier.primary_sbi_code_text = 'sbi_code_text';
        InputDossier.sbi_collection = 'sbi_collection';
        InputDossier.structure = 'structure';
        InputDossier.telephone_number = '12334234';
        InputDossier.trade_name_full = 'trade_name';
        InputDossier.indication_organisation_code = '10';
        InputDossier.legal_form_code = '11';
        InputDossier.main_establishment_number = '12';
        InputDossier.rsin_number = '13';
        InputDossier.secondary_sbi_code1 = 'secondary_sbi_code1';
        InputDossier.secondary_sbi_code1_text = 'secondary_sbi_code1_text';
        InputDossier.secondary_sbi_code2 = 'secondary_sbi_code2';
        InputDossier.secondary_sbi_code2_text = 'secondary_sbi_code2_text';
        InputDossier.trade_name_45 = '14';
        InputDossier.trade_names = new list<String>{'Test', 'Test2', 'Test3'};

        mocks.when(selectorMockDossier.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(selectorMockDossier.selectByDossierNumber(new set<String>{InputDossier.dossier_number})).thenReturn(new list<Business_Dossier__c>());
        mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
        //mocks.when(selectorMockAccount.selectById(new set<Id>{ExistingAccount.Id})).thenReturn();


        mocks.stopStubbing();

        //Application.Selector.setMock(selectorMockAccount);
        Application.Selector.setMock(selectorMockDossier);
        Application.UnitOfWork.setMock(uowMock);

        test.startTest();
        list<Object> results = BusinessService.upsertAccountAndDossier(InputDossier, null);
        test.stopTest();
        Business_Dossier__c d = (Business_Dossier__c) results.get(0);
        System.assertEquals(d.Annual_Financial_Statement_Summary__c,'summary');
        System.assertEquals(d.Authorized_Share_Capital__c, 12);
        System.assertEquals(d.Authorized_Share_Capital_Currency__c, 'authorized_share_capital_currency');
        System.assertEquals(d.Chamber_Number__c , '1');
        System.assertEquals(d.Class_Personnel__c , '1');
        System.assertEquals(d.Class_Personnel_CI__c , '1');
        System.assertEquals(d.Class_Personnel_Fulltime__c , '1');
        System.assertEquals(d.Contact_Gender__c , 'm');
        System.assertEquals(d.Contact_Initials__c , 'initial');
        System.assertEquals(d.Contact_Prefix__c , 'prefix');
        System.assertEquals(d.Contact_Surname__c , 'surname');
        System.assertEquals(d.Contact_Title1__c , 'title1');
        System.assertEquals(d.Contact_Title2__c , 'title2');
        System.assertEquals(d.Continuation_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Correspondence_Address__c , 'correspondence_address');
        System.assertEquals(d.Discontinuation_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Domain_Name__c , 'domain_name');
        System.assertEquals(d.Dossier_Number__c , '123456');
        System.assertEquals(d.Establishment_Address__c , 'establishment_address');
        System.assertEquals(d.Establishment_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Establishment_Number__c , 10);
        System.assertEquals(d.Founding_Date__c, Date.valueOf('2019-2-12'));
        System.assertEquals(d.Indication_Main_Establishment__c , true);
        System.assertEquals(d.Indication_Organisation_Code__c , '10');
        System.assertEquals(d.Insolvencies__c , 'insolvencies');
        System.assertEquals(d.Issued_Share_Capital__c , 12334234);
        System.assertEquals(d.Issued_Share_Capital_Currency__c , 'issued_share_capital_currency');
        System.assertEquals(d.Legal_Form_Code__c , 11);
        System.assertEquals(d.Legal_Form_Text__c , 'legal_form');
        System.assertEquals(d.Main_Establishment_Number__c , 12);
        System.assertEquals(d.Mobile_Number__c , '12334234');
        System.assertEquals(d.Paid_Up_Share_Capital__c , 12334234);
        System.assertEquals(d.Paid_Up_Share_Capital_Currency__c , 'paid_up_share_capital_currency');
        System.assertEquals(d.Personnel__c , 1);
        System.assertEquals(d.Personnel_CI__c , 1);
        System.assertEquals(d.Personnel_CI_Reference_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Personnel_Fulltime__c , 1);
        System.assertEquals(d.Personnel_Reference_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Primary_Sbi_Code__c , 'sbi_code');
        System.assertEquals(d.Primary_Sbi_Code_Text__c , 'sbi_code_text');
        System.assertEquals(d.Rsin_Number__c , 13);
        System.assertEquals(d.Sbi_Collection__c , 'sbi_collection');
        System.assertEquals(d.Secondary_Sbi_Code_1__c , 'secondary_sbi_code1');
        System.assertEquals(d.Secondary_Sbi_Code_1_Text__c , 'secondary_sbi_code1_text');
        System.assertEquals(d.Secondary_Sbi_Code_2__c, 'secondary_sbi_code2');
        System.assertEquals(d.Secondary_Sbi_Code_2_Text__c , 'secondary_sbi_code2_text');
        System.assertEquals(d.Status__c , 'Import');
        System.assertEquals(d.Structure__c , 'structure');
        System.assertEquals(d.Telephone_Number__c , '12334234');
        System.assertEquals(d.Trade_Name_45__c , '14');
        System.assertEquals(d.Trade_Name_Full__c , 'trade_name');
        System.assertNotEquals(d.Trade_Names__c , 'test test1');
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
            Business_Dossier__c d = saveDutchBusinessDossierUow(dossier, acc, unitOfWork);
            //unitOfWork.registerRelationship(acc, Account.Business_Dossier__c, d);
            unitOfWork.commitWork();
            //unitOfWork.registerDirty(acc, Account.Business_Dossier__c, d); // to update a field on account level once dossier is inserted
            //unitOfWork.commitWork(); // need to wait until circullar references are releassed ion fflib. so far using another method link: https://github.com/financialforcedev/fflib-apex-common/pull/195
            result.add(d);
            result.add(acc);
            return result;
        }catch(CCException ex){
            throw ex; // we dont log bds exceptions, only throwing them further
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception+ex.getMessage(), ex);
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
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
        // Given
        mocks.startStubbing();
        String dossierNumber = '40000000';
        Account acc = new Account(
                Name = 'Test',
                Id = fflib_IDGenerator.generate(Account.SObjectType)
        );
        List<Business_Dossier__c> dossierList = new List<Business_Dossier__c> {
                new Business_Dossier__c(
                        Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType),
                        Name = 'Test',
                        Dossier_Number__c = dossierNumber,
                        Account__c = acc.Id
                )
        };
        mocks.when(selectorMockDossier.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(selectorMockDossier.selectByDossierNumber(new set<String>{dossierNumber})).thenReturn(dossierList);
        mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMockAccount.selectById(new set<Id>{acc.Id})).thenReturn(new list<Account>{acc});
        mocks.stopStubbing();
        //Application.UnitOfWork.setMock(uowMock);
        Application.Selector.setMock(selectorMockAccount);
        Application.Selector.setMock(selectorMockDossier);
        //Application.service.setMock(IWebServicesNLSOAPDutchBusiness.class, mockWS);
        test.startTest();
        //IBusinessService service = BusinessService.newInstance();
        Account result = BusinessService.getDossierAccount(String.valueOf(dossierNumber));
        system.assertEquals(acc.Id, result.Id);
    }


    /*
    @isTest
    public static void testCreateAccountForDossierNewAccountNoDups(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        //IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
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
        Application.service.setMock(IBusinessService.class, mockService);
        test.startTest();


        Account result = BusinessService.createAccountForDossier(accountId, dossier, uowMock);
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
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
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
        Application.service.setMock(IBusinessService.class, mockService);
        test.startTest();


        Account result = BusinessService.createAccountForDossier(accountId, dossier, uowMock);
        test.stopTest();
        system.assertEquals(result.name, acc.Name);
    }*/

}