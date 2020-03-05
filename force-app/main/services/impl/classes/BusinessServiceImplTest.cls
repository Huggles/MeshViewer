@isTest
public with sharing class BusinessServiceImplTest {
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
    public static void testDeleteDossierHappyFlow() {
        // given
        // a business dossier, a SBI code and an address in the DB
        Business_Dossier__c dossier = new Business_Dossier__c(Name = 'test');
        insert dossier;
        Business_Data_SBI__c sb = new Business_Data_SBI__c(Business_Dossier__c = dossier.Id);
        insert sb;
        Dossier_Address__c address = new Dossier_Address__c(Business_Data__c = dossier.Id);
        insert address;

        // when
        Test.startTest();
        BusinessService.deleteDossier(dossier.Id);
        Test.stopTest();

        // then
        // no objects any more
        System.assert([SELECT Id FROM Business_Dossier__c].size() == 0);
        System.assert([SELECT Id FROM Business_Data_SBI__c].size() == 0);
        System.assert([SELECT Id FROM Dossier_Address__c].size() == 0);

    }

    @isTest
    public static void testSearchForDutchDossiers(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        mocks.startStubbing();
        String postCode = '2274NA';
        DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult output1 = new DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult();
        output1.results = new DutchBusinessWsdl.DutchBusinessReferenceV2Array();
        output1.results.item = new List<DutchBusinessWsdl.DutchBusinessReferenceV2>();
        output1.paging = new DutchBusinessWsdl.ResultInfo();
        output1.paging.numpages = 2; // to ensure we also hit the paging mechanism
        DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult output2 = new DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult();
        output2.results = new DutchBusinessWsdl.DutchBusinessReferenceV2Array();
        output2.results.item = new List<DutchBusinessWsdl.DutchBusinessReferenceV2>();
        output2.paging = new DutchBusinessWsdl.ResultInfo();
        output2.paging.numpages = 2;

        for (Integer i = 0; i < 10; i++) {
            DutchBusinessWsdl.DutchBusinessReferenceV2 dr1 = new DutchBusinessWsdl.DutchBusinessReferenceV2();
            dr1.dossier_number = '' + i;
            output1.results.item.add(dr1);
            DutchBusinessWsdl.DutchBusinessReferenceV2 dr2 = new DutchBusinessWsdl.DutchBusinessReferenceV2();
            dr2.dossier_number = '' + i;
            output2.results.item.add(dr2);
        }
        DutchBusinessWsdl.DutchBusinessReferenceV2 dr = new DutchBusinessWsdl.DutchBusinessReferenceV2();
        mocks.when(mockWS.dutchBusinessSearchParametersV2(null, null, null, postCode,null, null, null, null, false, 1)).thenReturn(output1);
        mocks.when(mockWS.dutchBusinessSearchParametersV2(null, null, null, postCode,null, null, null, null, false, 2)).thenReturn(output2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, mockWS);
        List<SearchForDossiersResultDto> results = BusinessService.searchForDossiers('NL', null, null, null, null, null, postCode,null, null, null, null, null);
        System.assertEquals(20, results.size());
    }

    @IsTest
    public static void testSearchForDossiersNoCountryException() {
        Test.startTest();
        try {
            BusinessService.searchForDossiers(null, null, null, null, null, null, null, null, null, null, null, null);
        }catch (Exception e) {
            System.assert(e instanceof CCInputException);
            System.assertEquals(e.getMessage(), 'Country must be filled when searching for dossiers');
        }
        Test.stopTest();
        List<Error_Log__c> errorLogs = [SELECT Id FROM Error_Log__c];
        System.assertEquals(errorLogs.size(), 1);
    }

    @IsTest
    public static void testinsertSingleDossierFromCreditSafeNoAccountHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe webserviceMock = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        Id accountId = null;
        CreditsafeWsdl.stringArray trade_names = new CreditsafeWsdl.stringArray();
        trade_names.item = new List<String>();
        trade_names.item.add('trade names');
        CreditsafeWsdl.stringArray vat_numbers = new CreditsafeWsdl.stringArray();
        vat_numbers.item = new List<String>();
        vat_numbers.item.add('123');
        CreditsafeWsdl.CreditsafeAddressV2 address = new CreditsafeWsdl.CreditsafeAddressV2();
        address.city = 'city1';
        CreditsafeWsdl.CreditsafeSearchResultV2 output = new CreditsafeWsdl.CreditsafeSearchResultV2();
        output.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        output.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        CreditsafeWsdl.CreditsafeCompanyV2 item1 = new CreditsafeWsdl.CreditsafeCompanyV2();
        item1.id = '1';
        item1.creditsafe_number = '1';
        item1.name = 'test';
        item1.address = address;
        item1.trade_names = trade_names;
        item1.vat_numbers = vat_numbers;
        output.companies.item.add(item1);

        mocks.startStubbing();
        mocks.when(webserviceMock.creditsafeSearchV2(null, '1', null, null, null, null, null, null, null, null, null)).thenReturn(output);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, webserviceMock);

        Test.startTest();
        InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData('1', null, null, CustomerConnect.DataVendor.CREDIT_SAFE.name(), accountId);
        Test.stopTest();
        List<Business_Dossier__c> dossiersInDb = [SELECT Id, Creditsafe_Id__c, Trade_Name_Full__c, VAT_Number__c FROM Business_Dossier__c];
        List<Dossier_Address__c> dossierAddresses = [SELECT Id, Business_Data__c FROM Dossier_Address__c];
        System.assert(dossiersInDb.size() == 1);
        System.assertEquals(dossierAddresses.size(), 1);
        System.assertEquals(dossierAddresses[0].Business_Data__c, dossiersInDb.get(0).Id);
        System.assert(dossiersInDb.get(0).Creditsafe_Id__c == '1');
        System.assert(dossiersInDb.get(0).Trade_Name_Full__c == 'trade names');
        System.assert(dossiersInDb.get(0).VAT_Number__c == '123');

    }

    @IsTest
    public static void testinsertSingleDossierFromCreditSafeOneAccountHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe webserviceMock = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        Account acc = new Account(Name = 'test');
        insert acc;
        CreditsafeWsdl.CreditsafeSearchResultV2 output = new CreditsafeWsdl.CreditsafeSearchResultV2();
        output.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        output.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        CreditsafeWsdl.CreditsafeCompanyV2 item1 = new CreditsafeWsdl.CreditsafeCompanyV2();
        item1.id = '1';
        item1.creditsafe_number = '1';
        item1.name = 'test';
        output.companies.item.add(item1);

        mocks.startStubbing();
        mocks.when(webserviceMock.creditsafeSearchV2(null, '1', null, null, null, null, null, null, null, null, null)).thenReturn(output);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, webserviceMock);

        Test.startTest();
        InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData('1', null, null, CustomerConnect.DataVendor.CREDIT_SAFE.name(), acc.Id);
        Test.stopTest();
        List<Business_Dossier__c> dossiersInDb = [SELECT Id, Creditsafe_Id__c, Trade_Name_Full__c, Account__c FROM Business_Dossier__c];
        System.assert(dossiersInDb.size() == 1);
        System.assert(dossiersInDb.get(0).Creditsafe_Id__c == '1');
        System.assertEquals(dossiersInDb.get(0).Account__c, acc.Id);

    }

    @IsTest
    public static void testinsertSingleDossierFromCreditSafeException() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe webserviceMock = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        mocks.startStubbing();
        mocks.when(webserviceMock.creditsafeSearchV2(null, '1', null, null, null, null, null, null, null, null, null)).thenThrow(new CCDuplicateException());
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, webserviceMock);

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData('1', null, null, CustomerConnect.DataVendor.CREDIT_SAFE.name(), null);
        } catch (CCDuplicateException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(exceptionThrown);

    }

}