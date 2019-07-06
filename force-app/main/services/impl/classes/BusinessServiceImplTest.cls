@isTest
public with sharing class BusinessServiceImplTest {




    @isTest
    public static void testGetDossier(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        mocks.startStubbing();
        //DutchBusinessWsdl.DutchBusinessGetDossierRequest requestParams = new DutchBusinessWsdl.DutchBusinessGetDossierRequest();// = new DutchBusinessWsdl.DutchBusinessGetDossierRequest(dossier_number = dossierNumber, establishment_number = null);
        DutchBusinessWsdl.DutchBusinessDossierV3 output = new DutchBusinessWsdl.DutchBusinessDossierV3();

        string dossierNumber = '123';
        mocks.when(mockWS.dutchBusinessGetDossierV3(dossierNumber, null)).thenReturn(output);

        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, mockWS);

        test.startTest();

        DutchBusinessWsdl.DutchBusinessDossierV3 dossier = (new BusinessServiceImpl()).getDossier(dossierNumber, null);
        system.assertNotEquals(null, dossier);
        test.stopTest();
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
    public static void testUpdateDossiersWithDataVendorDataHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        Id accountId = null;
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossierOriginal = getDataVendorMockDossier();
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dataVendorDossierOriginal);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        // create something we can update
        InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dossierNumber, establishmentNUmber, accountId);

        Test.startTest();
        {
            DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
            dataVendorDossier.trade_name_full = 'test'; // not going to change every field since I use a central mapping function also used by insert and thus we tested it already there
            List<Business_Dossier__c> businessDossiers = BusinessService.updateDossiersWithDataVendorData(
                    new List<UpdateDossierRequestDTO>{new UpdateDossierRequestDTO(dataVendorDossier, responseDTO.dossier)});
            System.assert(businessDossiers.size() == 1);
        }
        Test.stopTest();
        List<Business_Dossier__c> dossiersInDb = [SELECT Id, Trade_Name_Full__c FROM Business_Dossier__c];
        System.assert(dossiersInDb.size() == 1);
        System.assert(dossiersInDb.get(0).Trade_Name_Full__c == 'test');

    }

    @IsTest
    public static void testSetVatNumberNoVatKnown() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        Id accountId = null;
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossierOriginal = getDataVendorMockDossier();
        DutchBusinessWsdl.DutchBusinessVatNumber vatResponse = new DutchBusinessWsdl.DutchBusinessVatNumber();
        vatResponse.dossier_number = dataVendorDossierOriginal.dossier_number;
        vatResponse.vat_number = '123456';
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dataVendorDossierOriginal.dossier_number, dataVendorDossierOriginal.establishment_number)).thenReturn(dataVendorDossierOriginal);
        mocks.when(webserviceMock.dutchBusinessGetVatNumber(dataVendorDossierOriginal.dossier_number)).thenReturn(vatResponse);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        // create something we can update
        InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dataVendorDossierOriginal.dossier_number, dataVendorDossierOriginal.establishment_number, accountId);

        Test.startTest();
        {
            Business_Dossier__c dossierReturned = BusinessService.setVatNumber(responseDTO.dossier.Id);
        }
        Test.stopTest();
        List<Business_Dossier__c> dossiersInDb = [SELECT Id, VAT_Number__c FROM Business_Dossier__c];
        System.assert(dossiersInDb.size() == 1);
        System.assert(dossiersInDb.get(0).VAT_Number__c == vatResponse.vat_number);

    }

    @IsTest
    public static void testInsertSingleDossierFromDataVendorDataGotTwoDuplicateAccounts() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness) mocks.mock(IWsDutchBusiness.class);
        IBusinessDuplicateService duplicateServiceMock = (IBusinessDuplicateService) mocks.mock(IBusinessDuplicateService.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            accounts.add(new Account(Name = 'trade_name'));
        }
        insert accounts;
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dataVendorDossier);
        mocks.when(duplicateServiceMock.checkForAccountDuplicates((Account)fflib_Match.eq(new Account(Name = 'trade_name')))).
                thenReturn(accounts);
        mocks.when(duplicateServiceMock.checkForDuplicateDossiers((List<CheckDuplicateDossierRequest>)fflib_Match.anyObject())).
                thenReturn(new List<CheckDuplicateDossierResponse>{new CheckDuplicateDossierResponse(dossierNumber, establishmentNUmber, null)});
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);
        Application.Service.setMock(IBusinessDuplicateService.class, duplicateServiceMock);

        InsertDossiersFromDataVendorResponseDTO responseDTO = null;
        Test.startTest();
        {
            Boolean exceptionThrown = false;
            try {
                responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dossierNumber, establishmentNUmber, null);
            } catch (CCDuplicateException e) {
                exceptionThrown = true;
            }
            System.assert(exceptionThrown);

        }
    }

    @IsTest
    public static void testInsertSingleDossierFromDataVendorDataUnexpectedException() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness) mocks.mock(IWsDutchBusiness.class);
        IBusinessDuplicateService duplicateServiceMock = (IBusinessDuplicateService) mocks.mock(IBusinessDuplicateService.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dataVendorDossier);
        mocks.when(duplicateServiceMock.checkForAccountDuplicates((Account)fflib_Match.eq(new Account(Name = 'trade_name')))).
                thenThrow(new CustomException());
        mocks.when(duplicateServiceMock.checkForDuplicateDossiers((List<CheckDuplicateDossierRequest>)fflib_Match.anyObject())).
                thenReturn(new List<CheckDuplicateDossierResponse>{new CheckDuplicateDossierResponse(dossierNumber, establishmentNUmber, null)});
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);
        Application.Service.setMock(IBusinessDuplicateService.class, duplicateServiceMock);

        InsertDossiersFromDataVendorResponseDTO responseDTO = null;
        Test.startTest();
        {
            Boolean exceptionThrown = false;
            try {
                responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dossierNumber, establishmentNUmber, null);
            } catch (CustomException e) {
                exceptionThrown = true;
            }
            System.assert(exceptionThrown);
        }
        Test.stopTest();
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }

    @IsTest
    public static void testInsertSingleDossierFromDataVendorDataDossierAlreadyExists() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness) mocks.mock(IWsDutchBusiness.class);
        IBusinessDuplicateService duplicateServiceMock = (IBusinessDuplicateService) mocks.mock(IBusinessDuplicateService.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        Business_Dossier__c existingDossier = new Business_Dossier__c(Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType));
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dataVendorDossier);
        mocks.when(duplicateServiceMock.checkForDuplicateDossiers((List<CheckDuplicateDossierRequest>)fflib_Match.anyObject())).
                thenReturn(new List<CheckDuplicateDossierResponse>{new CheckDuplicateDossierResponse(dossierNumber, establishmentNUmber, existingDossier)});
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);
        Application.Service.setMock(IBusinessDuplicateService.class, duplicateServiceMock);

        InsertDossiersFromDataVendorResponseDTO responseDTO = null;
        Test.startTest();
        {
            responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dossierNumber, establishmentNUmber, null);
            System.assert(responseDTO != null);
            System.assert(responseDTO.dossierExisted);
            System.assert(responseDTO.dossier == existingDossier);
        }
    }

    @IsTest
    public static void testInsertSingleDossierFromDataVendorDataGotAccount() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness) mocks.mock(IWsDutchBusiness.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        Account acc = new Account(Name = 'test');
        insert acc;
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dataVendorDossier);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        InsertDossiersFromDataVendorResponseDTO responseDTO = null;
        Test.startTest();
        {
            responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dossierNumber, establishmentNUmber, acc.Id);
        }
        Test.stopTest();
        System.assert(responseDTO != null);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
        Account accountDB = [SELECT Id, Name FROM Account];
        System.assert(accountDB != null);
        System.assert(accountDB.Name == acc.Name);
        Business_Dossier__c dossierDB = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Account__c,
                        Annual_Financial_Statement_Summary__c,
                        Assets__c,
                        Authorized_Share_Capital__c,
                        Authorized_Share_Capital_Currency__c,
                        Chamber_Code__c,
                        Chamber_Number__c,
                        Class_Personnel__c,
                        Class_Personnel_CI__c,
                        Class_Personnel_Fulltime__c,
                        Contact_Gender__c,
                        Contact_Initials__c,
                        Contact_Prefix__c,
                        Contact_Surname__c,
                        Contact_Title1__c,
                        Contact_Title2__c,
                        Continuation_Date__c,
                        Discontinuation_Date__c,
                        Domain_Name__c,
                        Dossier_Number__c,
                        Establishment_Date__c,
                        Establishment_Number__c,
                        Founding_Date__c,
                        Indication_Bankruptcy__c,
                        Indication_Dip__c,
                        Indication_Economically_Active__c,
                        Indication_Export__c,
                        Indication_Import__c,
                        Indication_Main_Establishment__c,
                        Indication_Non_Mailing__c,
                        Indication_Organisation_Code__c,
                        Insolvencies__c,
                        Issued_Share_Capital__c,
                        Issued_Share_Capital_Currency__c,
                        Legal_Form_Code__c,
                        Legal_Form_Text__c,
                        Main_Establishment_Number__c,
                        Mobile_Number__c,
                        Number_Of_Subsidiaries__c,
                        Paid_Up_Share_Capital__c,
                        Paid_Up_Share_Capital_Currency__c,
                        Parent_Chamber_Of_Commerce_Number__c,
                        Personnel__c,
                        Personnel_CI__c,
                        Personnel_CI_Reference_Date__c,
                        Personnel_Fulltime__c,
                        Personnel_Reference_Date__c,
                        Primary_Sbi_Code__c,
                        Primary_Sbi_Code_Text__c,
                        Profit__c,
                        Rsin_Number__c,
                        Sbi_Collection__c,
                        Secondary_Sbi_Code_1__c,
                        Secondary_Sbi_Code_1_Text__c,
                        Secondary_Sbi_Code_2__c,
                        Secondary_Sbi_Code_2_Text__c,
                        Status__c,
                        Structure__c,
                        Telephone_Number__c,
                        Trade_Name_45__c,
                        Trade_Name_Full__c,
                        Trade_Names__c,
                        Turnover__c,
                        Ultimate_Parent_Chamber_Of_Commerce_Nr__c,
                        VAT_Number__c,
                        Year__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        SystemModstamp
                FROM Business_Dossier__c];
        System.assert(dossierDB != null);
        System.assert(dossierDB.Account__c == accountDB.Id);

        System.assertEquals(dossierDB.Year__c, '1900');
        System.assertEquals(dossierDB.Profit__c, 'EUR 20000');
        System.assertEquals(dossierDB.Assets__c, 'EUR 200000');
        System.assertEquals(dossierDB.Turnover__c, 'EUR 1000');
        System.assertEquals(dossierDB.Authorized_Share_Capital__c, 12);
        System.assertEquals(dossierDB.Authorized_Share_Capital_Currency__c, 'USD');
        System.assertEquals(dossierDB.Chamber_Number__c , 1);
        System.assertEquals(dossierDB.Class_Personnel__c , '1');
        System.assertEquals(dossierDB.Class_Personnel_CI__c , '1');
        System.assertEquals(dossierDB.Class_Personnel_Fulltime__c , '1');
        System.assertEquals(dossierDB.Contact_Gender__c , 'm');
        System.assertEquals(dossierDB.Contact_Initials__c , 'initial');
        System.assertEquals(dossierDB.Contact_Prefix__c , 'prefix');
        System.assertEquals(dossierDB.Contact_Surname__c , 'surname');
        System.assertEquals(dossierDB.Contact_Title1__c , 'title1');
        System.assertEquals(dossierDB.Contact_Title2__c , 'title2');
        System.assertEquals(dossierDB.Continuation_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Discontinuation_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Domain_Name__c , 'domain_name');
        System.assertEquals(dossierDB.Dossier_Number__c , '123456');
        System.assertEquals(dossierDB.Establishment_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Establishment_Number__c , '10');
        System.assertEquals(dossierDB.Founding_Date__c, Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Indication_Main_Establishment__c , true);
        System.assertEquals(dossierDB.Indication_Organisation_Code__c , '10');
        //System.assertEquals(dossierDB.Insolvencies__c , 'insolvencies');
        System.assertEquals(dossierDB.Issued_Share_Capital__c , 12334234);
        System.assertEquals(dossierDB.Issued_Share_Capital_Currency__c , 'USD');
        System.assertEquals(dossierDB.Legal_Form_Code__c , 11);
        System.assertEquals(dossierDB.Legal_Form_Text__c , 'legal_form');
        System.assertEquals(dossierDB.Main_Establishment_Number__c , '12');
        System.assertEquals(dossierDB.Mobile_Number__c , '12334234');
        System.assertEquals(dossierDB.Paid_Up_Share_Capital__c , 12334234);
        System.assertEquals(dossierDB.Paid_Up_Share_Capital_Currency__c , 'USD');
        System.assertEquals(dossierDB.Personnel__c , 1);
        System.assertEquals(dossierDB.Personnel_CI__c , 1);
        System.assertEquals(dossierDB.Personnel_CI_Reference_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Personnel_Fulltime__c , 1);
        System.assertEquals(dossierDB.Personnel_Reference_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Primary_Sbi_Code__c , 'sbi');
        System.assertEquals(dossierDB.Primary_Sbi_Code_Text__c , 'sbi_code_text');
        System.assertEquals(dossierDB.Rsin_Number__c , '13');

        List<Business_Data_SBI__c> sbi = [SELECT SBI_Code__c, SBI_Description__c, SBI_Type__c, Business_Dossier__c FROM Business_Data_SBI__c WHERE Business_Dossier__c = :dossierDB.Id];
        System.assert(sbi.size() == 10);
//        for (Business_Data_SBI__c businessDataSBI : sbi) {
//            System.assert(businessDataSBI.);
//        }
//        if (sbi.size() > 0) {
//            System.assertEquals(sbi[0].SBI_Type__c, 'original');
//            System.assertEquals(sbi[0].SBI_Description__c, 'o0');
//            System.assertEquals(sbi[0].SBI_Code__c , 'o0');
//        }

        System.assertEquals(dossierDB.Secondary_Sbi_Code_1__c , 'sbi');
        System.assertEquals(dossierDB.Secondary_Sbi_Code_1_Text__c , 'secondary_sbi_code1_text');
        System.assertEquals(dossierDB.Secondary_Sbi_Code_2__c, 'sbis2');
        System.assertEquals(dossierDB.Secondary_Sbi_Code_2_Text__c , 'secondary_sbi_code2_text');
        System.assertEquals(dossierDB.Status__c , 'Import');
        System.assertEquals(dossierDB.Number_Of_Subsidiaries__c, '1');
        System.assertEquals(dossierDB.Parent_Chamber_Of_Commerce_Number__c, '123');
        System.assertEquals(dossierDB.Ultimate_Parent_Chamber_Of_Commerce_Nr__c, '1122');
        System.assertEquals(dossierDB.Telephone_Number__c , '12334234');
        System.assertEquals(dossierDB.Trade_Name_45__c , '14');
        System.assertEquals(dossierDB.Trade_Name_Full__c , 'trade_name');
        System.assertNotEquals(dossierDB.Trade_Names__c , 'test test1');
        System.assertEquals(dossierDB.Indication_Bankruptcy__c , false);
        System.assertEquals(dossierDB.Indication_Dip__c , false);
        System.assertEquals(dossierDB.Indication_Economically_Active__c , false);
        System.assertEquals(dossierDB.Indication_Export__c , false);
        System.assertEquals(dossierDB.Indication_Import__c, true);
        System.assertEquals(dossierDB.Indication_Main_Establishment__c , true);
        System.assertEquals(dossierDB.Indication_Non_Mailing__c , false);

        Dossier_Address__c cAddress = [SELECT Name, City__c, Country__c, Postcode__c, Street__c, House_Number__c, House_Number_Addition__c FROM Dossier_Address__c WHERE Business_Data__c = :dossierDB.Id AND Type__c = 'Correspondence'];

        System.assertEquals(cAddress.Name, '3533AX street');
        System.assertEquals(cAddress.Postcode__c, '3533AX');
        System.assertEquals(cAddress.Country__c, 'NL');
        System.assertEquals(cAddress.City__c, 'city');
        System.assertEquals(cAddress.Street__c, 'street');
        System.assertEquals(cAddress.House_Number_Addition__c, 'a');
        System.assertEquals(cAddress.House_Number__c, '10');

        Dossier_Address__c eAddress = [SELECT Name, City__c, Country__c, Postcode__c, Street__c, House_Number__c, House_Number_Addition__c FROM Dossier_Address__c WHERE Business_Data__c = :dossierDB.Id AND Type__c = 'Establishment'];
        System.assertEquals(eAddress.Name, '3533AX street');
        System.assertEquals(eAddress.Postcode__c, '3533AX');
        System.assertEquals(eAddress.Country__c, 'NL');
        System.assertEquals(eAddress.City__c, 'city');
        System.assertEquals(eAddress.Street__c, 'street');
        System.assertEquals(eAddress.House_Number_Addition__c, 'a');
        System.assertEquals(eAddress.House_Number__c, '10');

    }

    @IsTest
    public static void testDeleteDossierHappyScenario() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        Id accountId = null;
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dataVendorDossier);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dossierNumber, establishmentNUmber, accountId);
        Test.startTest();
        {
            System.assert([SELECT Id FROM Business_Dossier__c].size() == 1);
            Boolean result = BusinessService.deleteDossier(responseDTO.dossier.Account__c);
            System.assert(result);
            System.assert([SELECT Id FROM Business_Dossier__c].size() == 0);
        }
        Test.stopTest();


    }
    
    @IsTest
    public static void testInsertSingleDossierFromDataVendorDataNoAccountId() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        Id accountId = null;
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dataVendorDossier);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        InsertDossiersFromDataVendorResponseDTO responseDTO = null;
        Test.startTest();
        {
            responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dossierNumber, establishmentNUmber, accountId);
        }
        Test.stopTest();
        System.assert(responseDTO != null);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
        Account accountDB = [SELECT Id FROM Account];
        System.assert(accountDB != null);
        Business_Dossier__c dossierDB = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Account__c,
                        Annual_Financial_Statement_Summary__c,
                        Assets__c,
                        Authorized_Share_Capital__c,
                        Authorized_Share_Capital_Currency__c,
                        Chamber_Code__c,
                        Chamber_Number__c,
                        Class_Personnel__c,
                        Class_Personnel_CI__c,
                        Class_Personnel_Fulltime__c,
                        Contact_Gender__c,
                        Contact_Initials__c,
                        Contact_Prefix__c,
                        Contact_Surname__c,
                        Contact_Title1__c,
                        Contact_Title2__c,
                        Continuation_Date__c,
                        Discontinuation_Date__c,
                        Domain_Name__c,
                        Dossier_Number__c,
                        Establishment_Date__c,
                        Establishment_Number__c,
                        Founding_Date__c,
                        Indication_Bankruptcy__c,
                        Indication_Dip__c,
                        Indication_Economically_Active__c,
                        Indication_Export__c,
                        Indication_Import__c,
                        Indication_Main_Establishment__c,
                        Indication_Non_Mailing__c,
                        Indication_Organisation_Code__c,
                        Insolvencies__c,
                        Issued_Share_Capital__c,
                        Issued_Share_Capital_Currency__c,
                        Legal_Form_Code__c,
                        Legal_Form_Text__c,
                        Main_Establishment_Number__c,
                        Mobile_Number__c,
                        Number_Of_Subsidiaries__c,
                        Paid_Up_Share_Capital__c,
                        Paid_Up_Share_Capital_Currency__c,
                        Parent_Chamber_Of_Commerce_Number__c,
                        Personnel__c,
                        Personnel_CI__c,
                        Personnel_CI_Reference_Date__c,
                        Personnel_Fulltime__c,
                        Personnel_Reference_Date__c,
                        Primary_Sbi_Code__c,
                        Primary_Sbi_Code_Text__c,
                        Profit__c,
                        Rsin_Number__c,
                        Sbi_Collection__c,
                        Secondary_Sbi_Code_1__c,
                        Secondary_Sbi_Code_1_Text__c,
                        Secondary_Sbi_Code_2__c,
                        Secondary_Sbi_Code_2_Text__c,
                        Status__c,
                        Structure__c,
                        Telephone_Number__c,
                        Trade_Name_45__c,
                        Trade_Name_Full__c,
                        Trade_Names__c,
                        Turnover__c,
                        Ultimate_Parent_Chamber_Of_Commerce_Nr__c,
                        VAT_Number__c,
                        Year__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        SystemModstamp
                FROM Business_Dossier__c];
        System.assert(dossierDB != null);
        System.assert(dossierDB.Account__c == accountDB.Id);

        System.assertEquals(dossierDB.Year__c, '1900');
        System.assertEquals(dossierDB.Profit__c, 'EUR 20000');
        System.assertEquals(dossierDB.Assets__c, 'EUR 200000');
        System.assertEquals(dossierDB.Turnover__c, 'EUR 1000');
        System.assertEquals(dossierDB.Authorized_Share_Capital__c, 12);
        System.assertEquals(dossierDB.Authorized_Share_Capital_Currency__c, 'USD');
        System.assertEquals(dossierDB.Chamber_Number__c , 1);
        System.assertEquals(dossierDB.Class_Personnel__c , '1');
        System.assertEquals(dossierDB.Class_Personnel_CI__c , '1');
        System.assertEquals(dossierDB.Class_Personnel_Fulltime__c , '1');
        System.assertEquals(dossierDB.Contact_Gender__c , 'm');
        System.assertEquals(dossierDB.Contact_Initials__c , 'initial');
        System.assertEquals(dossierDB.Contact_Prefix__c , 'prefix');
        System.assertEquals(dossierDB.Contact_Surname__c , 'surname');
        System.assertEquals(dossierDB.Contact_Title1__c , 'title1');
        System.assertEquals(dossierDB.Contact_Title2__c , 'title2');
        System.assertEquals(dossierDB.Continuation_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Discontinuation_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Domain_Name__c , 'domain_name');
        System.assertEquals(dossierDB.Dossier_Number__c , '123456');
        System.assertEquals(dossierDB.Establishment_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Establishment_Number__c , '10');
        System.assertEquals(dossierDB.Founding_Date__c, Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Indication_Main_Establishment__c , true);
        System.assertEquals(dossierDB.Indication_Organisation_Code__c , '10');
        //System.assertEquals(dossierDB.Insolvencies__c , 'insolvencies');
        System.assertEquals(dossierDB.Issued_Share_Capital__c , 12334234);
        System.assertEquals(dossierDB.Issued_Share_Capital_Currency__c , 'USD');
        System.assertEquals(dossierDB.Legal_Form_Code__c , 11);
        System.assertEquals(dossierDB.Legal_Form_Text__c , 'legal_form');
        System.assertEquals(dossierDB.Main_Establishment_Number__c , '12');
        System.assertEquals(dossierDB.Mobile_Number__c , '12334234');
        System.assertEquals(dossierDB.Paid_Up_Share_Capital__c , 12334234);
        System.assertEquals(dossierDB.Paid_Up_Share_Capital_Currency__c , 'USD');
        System.assertEquals(dossierDB.Personnel__c , 1);
        System.assertEquals(dossierDB.Personnel_CI__c , 1);
        System.assertEquals(dossierDB.Personnel_CI_Reference_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Personnel_Fulltime__c , 1);
        System.assertEquals(dossierDB.Personnel_Reference_Date__c , Date.valueOf('2019-2-2'));
        System.assertEquals(dossierDB.Primary_Sbi_Code__c , 'sbi');
        System.assertEquals(dossierDB.Primary_Sbi_Code_Text__c , 'sbi_code_text');
        System.assertEquals(dossierDB.Rsin_Number__c , '13');

        List<Business_Data_SBI__c> sbi = [SELECT SBI_Code__c, SBI_Description__c, SBI_Type__c, Business_Dossier__c FROM Business_Data_SBI__c WHERE Business_Dossier__c = :dossierDB.Id];
        System.assert(sbi.size() == 10);
//        for (Business_Data_SBI__c businessDataSBI : sbi) {
//            System.assert(businessDataSBI.);
//        }
//        if (sbi.size() > 0) {
//            System.assertEquals(sbi[0].SBI_Type__c, 'original');
//            System.assertEquals(sbi[0].SBI_Description__c, 'o0');
//            System.assertEquals(sbi[0].SBI_Code__c , 'o0');
//        }

        System.assertEquals(dossierDB.Secondary_Sbi_Code_1__c , 'sbi');
        System.assertEquals(dossierDB.Secondary_Sbi_Code_1_Text__c , 'secondary_sbi_code1_text');
        System.assertEquals(dossierDB.Secondary_Sbi_Code_2__c, 'sbis2');
        System.assertEquals(dossierDB.Secondary_Sbi_Code_2_Text__c , 'secondary_sbi_code2_text');
        System.assertEquals(dossierDB.Status__c , 'Import');
        System.assertEquals(dossierDB.Number_Of_Subsidiaries__c, '1');
        System.assertEquals(dossierDB.Parent_Chamber_Of_Commerce_Number__c, '123');
        System.assertEquals(dossierDB.Ultimate_Parent_Chamber_Of_Commerce_Nr__c, '1122');
        System.assertEquals(dossierDB.Telephone_Number__c , '12334234');
        System.assertEquals(dossierDB.Trade_Name_45__c , '14');
        System.assertEquals(dossierDB.Trade_Name_Full__c , 'trade_name');
        System.assertNotEquals(dossierDB.Trade_Names__c , 'test test1');
        System.assertEquals(dossierDB.Indication_Bankruptcy__c , false);
        System.assertEquals(dossierDB.Indication_Dip__c , false);
        System.assertEquals(dossierDB.Indication_Economically_Active__c , false);
        System.assertEquals(dossierDB.Indication_Export__c , false);
        System.assertEquals(dossierDB.Indication_Import__c, true);
        System.assertEquals(dossierDB.Indication_Main_Establishment__c , true);
        System.assertEquals(dossierDB.Indication_Non_Mailing__c , false);

         Dossier_Address__c cAddress = [SELECT Name, City__c, Country__c, Postcode__c, Street__c, House_Number__c, House_Number_Addition__c FROM Dossier_Address__c WHERE Business_Data__c = :dossierDB.Id AND Type__c = 'Correspondence'];
        
         System.assertEquals(cAddress.Name, '3533AX street');
         System.assertEquals(cAddress.Postcode__c, '3533AX');
         System.assertEquals(cAddress.Country__c, 'NL');
         System.assertEquals(cAddress.City__c, 'city');
         System.assertEquals(cAddress.Street__c, 'street');
         System.assertEquals(cAddress.House_Number_Addition__c, 'a');
         System.assertEquals(cAddress.House_Number__c, '10');

         Dossier_Address__c eAddress = [SELECT Name, City__c, Country__c, Postcode__c, Street__c, House_Number__c, House_Number_Addition__c FROM Dossier_Address__c WHERE Business_Data__c = :dossierDB.Id AND Type__c = 'Establishment'];
        System.assertEquals(eAddress.Name, '3533AX street');
        System.assertEquals(eAddress.Postcode__c, '3533AX');
        System.assertEquals(eAddress.Country__c, 'NL');
        System.assertEquals(eAddress.City__c, 'city');
        System.assertEquals(eAddress.Street__c, 'street');
        System.assertEquals(eAddress.House_Number_Addition__c, 'a');
        System.assertEquals(eAddress.House_Number__c, '10');
        
    }

//    @IsTest
//    public static void testInsertAccountHappyFlow() {
//        fflib_ApexMocks mocks = new fflib_ApexMocks();
//        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
//        IBusinessDuplicateService duplicateServiceMock = (IBusinessDuplicateService)mocks.mock(IBusinessDuplicateService.class);
//
//        mocks.startStubbing();
//        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
//        mocks.when(webserviceMock.dutchBusinessGetDossier((DutchBusinessWsdl.DutchBusinessGetDossierRequest)fflib_Match.anyObject())).thenReturn(dataVendorDossier);
//        mocks.when(duplicateServiceMock.checkForAccountDuplicates((Account)fflib_Match.anySObject())).thenReturn(new List<Account>());
//        mocks.stopStubbing();
//
//        Test.startTest();
//        {
//            List<InsertAccountResponseDTO> responseDTOS = BusinessService.insertAccount(new List<DutchBusinessWsdl.DutchBusinessDossierV3>{dataVendorDossier});
//            System.assert(responseDTOS.size() == 1);
//            for (InsertAccountResponseDTO insertAccountResponseDTO : responseDTOS) {
//                System.assert(insertAccountResponseDTO.account != null);
//                System.assert(insertAccountResponseDTO.account.Name == dataVendorDossier.trade_name_full);
//            }
//        }
//        Test.stopTest();
//    }

    @IsTest
    public static void testInsertAccountHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        Test.startTest();
        {
            List<InsertAccountResponseDTO> responseDTOS = (new BusinessServiceImpl()).insertAccount(new List<DutchBusinessWsdl.DutchBusinessDossierV3>{dataVendorDossier}, unitOfWorkMock);
            System.assert(responseDTOS.size() == 1);
            for (InsertAccountResponseDTO insertAccountResponseDTO : responseDTOS) {
                System.assert(insertAccountResponseDTO.account != null);
                System.assert(insertAccountResponseDTO.account.Name == dataVendorDossier.trade_name_full);
            }
        }
        Test.stopTest();
    }

    @IsTest
    public static void testInsertAccountTwoAccounts() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        // IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        IBusinessDuplicateService duplicateServiceMock = (IBusinessDuplicateService)mocks.mock(IBusinessDuplicateService.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        mocks.startStubbing();
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'test', Id = fflib_IDGenerator.generate(Account.SObjectType)));
        }
        // mocks.when(webserviceMock.dutchBusinessGetDossier((DutchBusinessWsdl.DutchBusinessGetDossierRequest)fflib_Match.anyObject())).thenReturn(dataVendorDossier);
        mocks.when(duplicateServiceMock.checkForAccountDuplicates((Account)fflib_Match.anySObject())).thenReturn(accounts);
       // mocks.when(unitOfWorkMock.commitWork()).thenThrow(new DMLManager.CRUDException());
        // ((fflib_ISObjectUnitOfWork)mocks.doThrowWhen(new DMLManager.CRUDException(), unitOfWorkMock)).commitWork();
        mocks.stopStubbing();

        Application.UnitOfWork.setMock(unitOfWorkMock);
        Application.Service.setMock(IBusinessDuplicateService.class, duplicateServiceMock);

        Test.startTest();
        {
            Boolean exceptionThrown = false;
            try {
                List<InsertAccountResponseDTO> responseDTOS = (new BusinessServiceImpl()).insertAccount(new List<DutchBusinessWsdl.DutchBusinessDossierV3>{dataVendorDossier}, unitOfWorkMock);
            } catch (CCDuplicateException e) {
                exceptionThrown = true;
            }
            System.assert(exceptionThrown);
        }
        Test.stopTest();
    }

    @IsTest
    public static void testInsertAccountOneDuplicateAccount() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        // IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        IBusinessDuplicateService duplicateServiceMock = (IBusinessDuplicateService)mocks.mock(IBusinessDuplicateService.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        mocks.startStubbing();
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 1; i++) {
            accounts.add(new Account(Name = 'test', Id = fflib_IDGenerator.generate(Account.SObjectType)));
        }
        // mocks.when(webserviceMock.dutchBusinessGetDossier((DutchBusinessWsdl.DutchBusinessGetDossierRequest)fflib_Match.anyObject())).thenReturn(dataVendorDossier);
        mocks.when(duplicateServiceMock.checkForAccountDuplicates((Account)fflib_Match.anySObject())).thenReturn(accounts);
        // mocks.when(unitOfWorkMock.commitWork()).thenThrow(new DMLManager.CRUDException());
        // ((fflib_ISObjectUnitOfWork)mocks.doThrowWhen(new DMLManager.CRUDException(), unitOfWorkMock)).commitWork();
        mocks.stopStubbing();

        Application.UnitOfWork.setMock(unitOfWorkMock);
        Application.Service.setMock(IBusinessDuplicateService.class, duplicateServiceMock);

        Test.startTest();
        {
            List<InsertAccountResponseDTO> responseDTOS = (new BusinessServiceImpl()).insertAccount(new List<DutchBusinessWsdl.DutchBusinessDossierV3>{dataVendorDossier}, unitOfWorkMock);
            System.assert(responseDTOS.size() == 1);
            System.assert(responseDTOS.get(0).account == accounts.get(0));
        }
        Test.stopTest();
    }



    private static DutchBusinessWsdl.DutchBusinessDossierV3 getDataVendorMockDossier() {
        DutchBusinessWsdl.DutchBusinessDossierV3 InputDossier = new DutchBusinessWsdl.DutchBusinessDossierV3();

        InputDossier.annual_financial_statement_summary = new DutchBusinessWsdl.DutchBusinessAnnualFinancialStatementSummary();
        InputDossier.annual_financial_statement_summary.year = 1900;
        InputDossier.annual_financial_statement_summary.profit = newMoneyInstance(20000, 'EUR');
        InputDossier.annual_financial_statement_summary.turnover = newMoneyInstance(1000, 'EUR');
        InputDossier.annual_financial_statement_summary.assets =  newMoneyInstance(200000, 'EUR');
        InputDossier.authorized_share_capital = 12;
        InputDossier.authorized_share_capital_currency = 'USD';
        InputDossier.chamber_number = '01';
        InputDossier.class_personnel_ci = 1;
        InputDossier.class_personnel_fulltime = 1;
        InputDossier.class_personnel = 1;
        InputDossier.contact_gender = 'm';
        InputDossier.contact_initials = 'initial';
        InputDossier.contact_prefix = 'prefix';
        InputDossier.contact_surname = 'surname';
        InputDossier.contact_title1 = 'title1';
        InputDossier.contact_title2 = 'title2';

        InputDossier.continuation_date = newDateInstance(2019, 2, 2);
        InputDossier.discontinuation_date = newDateInstance(2019,2,2);
        InputDossier.domain_name = 'domain_name';
        InputDossier.dossier_number = '123456';
        InputDossier.establishment_date = newDateInstance(2019, 2, 2);
        InputDossier.establishment_number = '10';
        InputDossier.founding_date = newDateInstance(2019, 2, 2);
        InputDossier.indication_bankruptcy = false;
        InputDossier.indication_dip = false;
        InputDossier.indication_economically_active = false;
        InputDossier.indication_export = false;
        InputDossier.indication_import = true;
        InputDossier.indication_main_establishment = false;
        InputDossier.indication_main_establishment = true;
        InputDossier.indication_non_mailing = false;
        // TODO: setup insolvencies
        // InputDossier.insolvencies = 'insolvencies';
        InputDossier.issued_share_capital_currency = 'USD';
        InputDossier.issued_share_capital = 12334234;
        InputDossier.legal_form_text = 'legal_form';
        InputDossier.legal_name = 'legal_name';
        InputDossier.mobile_number = '12334234';
        InputDossier.paid_up_share_capital_currency = 'USD';
        InputDossier.paid_up_share_capital = 12334234;
        InputDossier.personnel = 1;
        InputDossier.personnel_ci = 1;
        InputDossier.personnel_ci_reference_date = newDateInstance(2019, 2, 2);
        InputDossier.personnel_fulltime = 1;
        InputDossier.personnel_reference_date = newDateInstance(2019, 2, 2);
        InputDossier.primary_sbi_code = 'sbi';
        InputDossier.primary_sbi_code_text = 'sbi_code_text';

        InputDossier.sbi_collection = new DutchBusinessWsdl.DutchBusinessSBICollection();
        InputDossier.sbi_collection.original = new DutchBusinessWsdl.DutchBusinessSBICodeArray();
        InputDossier.sbi_collection.company_info = new DutchBusinessWsdl.DutchBusinessSBICodeArray();
        InputDossier.sbi_collection.original.item = new List<DutchBusinessWsdl.DutchBusinessSBICode>();
        InputDossier.sbi_collection.company_info.item = new List<DutchBusinessWsdl.DutchBusinessSBICode>();
        for (Integer i = 0; i < 5; i++) {
            InputDossier.sbi_collection.original.item.add(newSBICodeInstance('o' + i, 'o' + i));
            InputDossier.sbi_collection.original.item.add(newSBICodeInstance('c' + i, 'c' + i));
        }

        InputDossier.structure = new DutchBusinessWsdl.DutchBusinessStructure();
        InputDossier.structure.number_of_subsidiaries = 1;
        InputDossier.structure.parent = '123';
        InputDossier.structure.ultimate_parent = '1122';
        InputDossier.telephone_number = '12334234';
        InputDossier.trade_name_full = 'trade_name';
        InputDossier.indication_organisation_code = '10';
        InputDossier.legal_form_code = '11';
        InputDossier.main_establishment_number = '12';
        InputDossier.rsin_number = '13';
        InputDossier.secondary_sbi_code1 = 'sbi';
        InputDossier.secondary_sbi_code1_text = 'secondary_sbi_code1_text';
        InputDossier.secondary_sbi_code2 = 'sbis2';
        InputDossier.secondary_sbi_code2_text = 'secondary_sbi_code2_text';
        InputDossier.trade_name_45 = '14';
        InputDossier.trade_names = new DutchBusinessWsdl.stringArray();
        InputDossier.trade_names.item = new List<String>();
        InputDossier.trade_names.item.add('trade1');
        InputDossier.trade_names.item.add('trade2');
        InputDossier.correspondence_address = newFormattedAddress('address', 'city', 'NL', 'street', 10, '3533AX', 'a');
        InputDossier.establishment_address = newFormattedAddress('address', 'city', 'NL', 'street', 10, '3533AX', 'a');
        return InputDossier;
    }

    private static DutchBusinessWsdl.DutchBusinessMoneyV2 newMoneyInstance(Integer amount, String currencyCode) {
        DutchBusinessWsdl.DutchBusinessMoneyV2 returnValue = new DutchBusinessWsdl.DutchBusinessMoneyV2();
        returnValue.amount = amount;
        returnValue.currency_x = currencyCode;
        returnValue.formatted = currencyCode + ' ' + amount;
        return returnValue;
    }

    private static DutchBusinessWsdl.DutchBusinessDateV3 newDateInstance(Integer year, Integer month, Integer day) {
        DutchBusinessWsdl.DutchBusinessDateV3 returnValue = new DutchBusinessWsdl.DutchBusinessDateV3();
        returnValue.day = day;
        returnValue.month = month;
        returnValue.year = year;
        return returnValue;
    }

    private static DutchBusinessWsdl.DutchBusinessSBICode newSBICodeInstance(String code, String description) {
        DutchBusinessWsdl.DutchBusinessSBICode returnValue = new DutchBusinessWsdl.DutchBusinessSBICode();
        returnValue.sbi_code = code;
        returnValue.description = description;
        return returnValue;
    }

    private static DutchBusinessWsdl.DutchBusinessFormattedAddress newFormattedAddress(String address, String city, String country, String street, Integer houseNumber, String postCode, String houseNumberAddition) {
        DutchBusinessWsdl.DutchBusinessFormattedAddress returnValue = new DutchBusinessWsdl.DutchBusinessFormattedAddress();
        returnValue.original = new DutchBusinessWsdl.DutchBusinessAddressV3();
        returnValue.formatted = new DutchBusinessWsdl.DutchBusinessAddressV3();
        returnValue.official = new DutchBusinessWsdl.DutchBusinessAddressV3();
        returnValue.original.address = address;
        returnValue.formatted.address = address;
        returnValue.official.address = address;
        returnValue.original.city = city;
        returnValue.formatted.city = city;
        returnValue.official.city = city;
        returnValue.original.country = country;
        returnValue.formatted.country = country;
        returnValue.official.country = country;
        returnValue.original.street = street;
        returnValue.official.street = street;
        returnValue.formatted.street = street;
        returnValue.original.house_number = houseNumber;
        returnValue.official.house_number = houseNumber;
        returnValue.formatted.house_number = houseNumber;
        returnValue.original.house_number_addition = houseNumberAddition;
        returnValue.official.house_number_addition = houseNumberAddition;
        returnValue.formatted.house_number_addition = houseNumberAddition;
        returnValue.original.postcode = postCode;
        returnValue.official.postcode = postCode;
        returnValue.formatted.postcode = postCode;
        return returnValue;
    }




/*
    @isTest
    public static void testSaveBusinessDossierUow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
        // ISbiCodeSelector selectorMockSbiCode = (ISbiCodeSelector)mocks.mock(ISbiCodeSelector.class);
        // IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        mocks.startStubbing();

        //Account ExistingAccount = new Account(Id=fflib_IDGenerator.generate(Account.SObjectType), Name='Test');
        //Business_Dossier__c ExistingDossier = new Business_Dossier__c(Id=fflib_IDGenerator.generate(Business_Dossier__c.SObjectType), Name='Test', Dossier_Number__c='123456');
        DutchBusinessWsdl.DutchBusinessDossierV3 InputDossier = new DutchBusinessWsdl.DutchBusinessDossierV3();

        InputDossier.annual_financial_statement_summary = 'summary';
        InputDossier.annual_financial_statement_summary_year = 'year';
        InputDossier.annual_financial_statement_summary_profit = 'profit';
        InputDossier.annual_financial_statement_summary_turnover = 'turnover';
        InputDossier.annual_financial_statement_summary_assets = 'assets';
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
        InputDossier.discontinuation_date = Date.valueOf('2019-2-12');
        InputDossier.domain_name = 'domain_name';
        InputDossier.dossier_number = '123456';
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
        InputDossier.primary_sbi_code = 'sbi';
        InputDossier.primary_sbi_code_text = 'sbi_code_text';
        Business_Data_SBI__c s1 = new Business_Data_SBI__c(SBI_Type__c = 'original', SBI_Description__c = 'desc', SBI_Code__c = '11');
        InputDossier.sbi_collection = new List<Business_Data_SBI__c>{s1};
        InputDossier.structure = 'structure';
        InputDossier.structure_number_of_subsidiaries = '1';
        InputDossier.structure_parent = '123';
        InputDossier.structure_ultimate_parent = '1122';
        InputDossier.telephone_number = '12334234';
        InputDossier.trade_name_full = 'trade_name';
        InputDossier.indication_organisation_code = '10';
        InputDossier.legal_form_code = '11';
        InputDossier.main_establishment_number = '12';
        InputDossier.rsin_number = '13';
        InputDossier.secondary_sbi_code1 = 'sbi';
        InputDossier.secondary_sbi_code1_text = 'secondary_sbi_code1_text';
        InputDossier.secondary_sbi_code2 = 'sbis2';
        InputDossier.secondary_sbi_code2_text = 'secondary_sbi_code2_text';
        InputDossier.trade_name_45 = '14';
        InputDossier.trade_names = new list<String>{'Test', 'Test2', 'Test3'};
        InputDossier.correspondence_address_original_address = 'correspondence_address.original.address';
        InputDossier.correspondence_address_original_postcode = 'correspondence_address.original.postcode';
        InputDossier.correspondence_address_original_street = 'correspondence_address.original.street';
        InputDossier.correspondence_address_original_house_number = 1;
        InputDossier.correspondence_address_original_house_number_addition = 'correspondence_address.original.house_number_addition';
        InputDossier.correspondence_address_original_city = 'correspondence_address.original.city';
        InputDossier.correspondence_address_original_country = 'correspondence_address.original.country';
        InputDossier.establishment_address_original_address = 'establishment_address.original.address';
        InputDossier.establishment_address_original_postcode = 'establishment_address.original.postcode';
        InputDossier.establishment_address_original_street = 'establishment_address.original.street';
        InputDossier.establishment_address_original_house_number = 2;
        InputDossier.establishment_address_original_house_number_addition = 'establishment_address.original.house_number_addition';
        InputDossier.establishment_address_original_city = 'establishment_address.original.city';
        InputDossier.establishment_address_original_country = 'establishment_address.original.country';

        mocks.when(selectorMockDossier.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(selectorMockDossier.selectByDossierNumbers(new Set<DossierQueryDTO>{new DossierQueryDTO(InputDossier.dossier_number, InputDossier.establishment_number)}, false)).thenReturn(new list<Business_Dossier__c>());
        mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
        //mocks.when(selectorMockAccount.selectById(new set<Id>{ExistingAccount.Id})).thenReturn();


        mocks.stopStubbing();

        //Application.Selector.setMock(selectorMockAccount);
        Application.Selector.setMock(selectorMockDossier);
        Application.UnitOfWork.setMock(uowMock);
        Application.Selector.setMock(selectorMockAccount);
        // Application.Selector.setMock(selectorMockSbiCode);

        test.startTest();
        list<Object> results = BusinessService.upsertAccountAndDossier(InputDossier, null);
        test.stopTest();
        Business_Dossier__c d = (Business_Dossier__c) results.get(0);
        System.assertEquals(d.Year__c, 'year');
        System.assertEquals(d.Profit__c, 'profit');
        System.assertEquals(d.Assets__c, 'assets');
        System.assertEquals(d.Turnover__c, 'turnover');
        System.assertEquals(d.Authorized_Share_Capital__c, 12);
        System.assertEquals(d.Authorized_Share_Capital_Currency__c, 'authorized_share_capital_currency');
        System.assertEquals(d.Chamber_Number__c , 1);
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
        System.assertEquals(d.Discontinuation_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Domain_Name__c , 'domain_name');
        System.assertEquals(d.Dossier_Number__c , '123456');
        System.assertEquals(d.Establishment_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Establishment_Number__c , '10');
        System.assertEquals(d.Founding_Date__c, Date.valueOf('2019-2-12'));
        System.assertEquals(d.Indication_Main_Establishment__c , true);
        System.assertEquals(d.Indication_Organisation_Code__c , '10');
        System.assertEquals(d.Insolvencies__c , 'insolvencies');
        System.assertEquals(d.Issued_Share_Capital__c , 12334234);
        System.assertEquals(d.Issued_Share_Capital_Currency__c , 'issued_share_capital_currency');
        System.assertEquals(d.Legal_Form_Code__c , 11);
        System.assertEquals(d.Legal_Form_Text__c , 'legal_form');
        System.assertEquals(d.Main_Establishment_Number__c , '12');
        System.assertEquals(d.Mobile_Number__c , '12334234');
        System.assertEquals(d.Paid_Up_Share_Capital__c , 12334234);
        System.assertEquals(d.Paid_Up_Share_Capital_Currency__c , 'paid_up_share_capital_currency');
        System.assertEquals(d.Personnel__c , 1);
        System.assertEquals(d.Personnel_CI__c , 1);
        System.assertEquals(d.Personnel_CI_Reference_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Personnel_Fulltime__c , 1);
        System.assertEquals(d.Personnel_Reference_Date__c , Date.valueOf('2019-2-12'));
        System.assertEquals(d.Primary_Sbi_Code__c , 'sbi');
        System.assertEquals(d.Primary_Sbi_Code_Text__c , 'sbi_code_text');
        System.assertEquals(d.Rsin_Number__c , '13');

        List<Business_Data_SBI__c> sbi = [SELECT SBI_Code__c, SBI_Description__c, SBI_Type__c, Business_Dossier__c FROM Business_Data_SBI__c WHERE Business_Dossier__c = :d.Id LIMIT 1];
        if (sbi.size() > 0) {
            System.assertEquals(sbi[0].SBI_Type__c, 'original');
            System.assertEquals(sbi[0].SBI_Description__c, 'desc');
            System.assertEquals(sbi[0].SBI_Code__c , '11');
        }

        System.assertEquals(d.Secondary_Sbi_Code_1__c , 'secondary_sbi_code1');
        System.assertEquals(d.Secondary_Sbi_Code_1_Text__c , 'secondary_sbi_code1_text');
        System.assertEquals(d.Secondary_Sbi_Code_2__c, 'sbis2');
        System.assertEquals(d.Secondary_Sbi_Code_2_Text__c , 'secondary_sbi_code2_text');
        System.assertEquals(d.Status__c , 'Import');
        System.assertEquals(d.Number_Of_Subsidiaries__c, '1');
        System.assertEquals(d.Parent_Chamber_Of_Commerce_Number__c, '123');
        System.assertEquals(d.Ultimate_Parent_Chamber_Of_Commerce_Nr__c, '1122');
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
        
        // Dossier_Address__c cAddress = [SELECT Name, City__c, Country__c, Postcode__c, Street__c, House_Number__c, House_Number_Addition__c FROM Dossier_Address__c WHERE Business_Data__c = :d.Id AND Type__c = 'Correspondence' LIMIT 1];

        // System.assertEquals(cAddress.Name, 'correspondence_address.original.address');
        // System.assertEquals(cAddress.Postcode__c, 'correspondence_address.original.postcode');
        // System.assertEquals(cAddress.Country__c, 'correspondence_address.original.country');
        // System.assertEquals(cAddress.City__c, 'correspondence_address.original.city');
        // System.assertEquals(cAddress.Street__c, 'correspondence_address.original.street');
        // System.assertEquals(cAddress.House_Number_Addition__c, 'correspondence_address.original.house_number_addition');
        // System.assertEquals(cAddress.House_Number__c, '1');

        // Dossier_Address__c eAddress = [SELECT Name, City__c, Country__c, Postcode__c, Street__c, House_Number__c, House_Number_Addition__c FROM Dossier_Address__c WHERE Business_Data__c = :d.Id AND Type__c = 'Establishment' LIMIT 1];
        // System.assertEquals(eAddress.Name, 'establishment_address.original.address');
        // System.assertEquals(eAddress.Postcode__c, 'establishment_address.original.postcode');
        // System.assertEquals(eAddress.Country__c, 'establishment_address.original.country');
        // System.assertEquals(eAddress.City__c, 'establishment_address.original.city');
        // System.assertEquals(eAddress.Street__c, 'establishment_address.original.street');
        // System.assertEquals(eAddress.House_Number_Addition__c, 'establishment_address.original.house_number_addition');
        // System.assertEquals(eAddress.House_Number__c, '2');

    }
    */


/*
    //DutchBusinessWsdl.DutchBusinessDossierV3 dossier
    public static list<Object> upsertAccountAndDossier(DutchBusinessWsdl.DutchBusinessDossierV3 dossier, String accountId){
        
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

    // @isTest
    // public static void testGetDossierAccount(){
    //     fflib_ApexMocks mocks = new fflib_ApexMocks();
    //     //fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
    //     //IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
    //     IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
    //     IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
    //     // Given
    //     mocks.startStubbing();
    //     String dossierNumber = '40000000';
    //     String establishmentNumber = '10';
    //     Account acc = new Account(
    //             Name = 'Test',
    //             Id = fflib_IDGenerator.generate(Account.SObjectType)
    //     );
    //     List<Business_Dossier__c> dossierList = new List<Business_Dossier__c> {
    //             new Business_Dossier__c(
    //                     Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType),
    //                     Name = 'Test',
    //                     Dossier_Number__c = dossierNumber,
    //                     Account__c = acc.Id
    //             )
    //     };
    //     mocks.when(selectorMockDossier.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
    //     mocks.when(selectorMockDossier.selectByDossierNumbers(new set<String>{dossierNumber}, new set<String>{establishmentNumber})).thenReturn(dossierList);
    //     mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
    //     mocks.when(selectorMockAccount.selectById(new set<Id>{acc.Id})).thenReturn(new list<Account>{acc});
    //     mocks.stopStubbing();
    //     //Application.UnitOfWork.setMock(uowMock);
    //     Application.Selector.setMock(selectorMockAccount);
    //     Application.Selector.setMock(selectorMockDossier);
    //     //Application.service.setMock(IWsDutchBusiness.class, mockWS);
    //     test.startTest();
    //     //IBusinessService service = BusinessService.newInstance();
    //     Account result = BusinessService.getDossierAccount(String.valueOf(dossierNumber));
    //     system.assertEquals(acc.Id, result.Id);
    // }


    /*
    @isTest
    public static void testCreateAccountForDossierNewAccountNoDups(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        //IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
    // Given
        mocks.startStubbing();
        DutchBusinessWsdl.DutchBusinessDossierV3 dossier = new DutchBusinessWsdl.DutchBusinessDossierV3();
        dossier.trade_name_full = 'test';
        String accountId = '';
        list<String> output = new list<String>();
        Account acc = new Account();
        acc.Name = dossier.trade_name_full;
        
        //mocks.when(mockService.checkForAccountDuplicates((Account)fflib_Match.anyObject())).thenReturn(output);
        //mocks.when(mockService.createAccountForDossier(accountId, (DutchBusinessWsdl.DutchBusinessDossierV3)fflib_Match.anyObject(), uowMock)).thenCallRealMethod();

        mocks.stopStubbing();
        Application.service.setMock(IBusinessService.class, mockService);
        test.startTest();


        Account result = BusinessService.createAccountForDossier(accountId, dossier, uowMock);


        test.stopTest();
        system.assertEquals(result.name, acc.Name);
    }
@isTest
    public static void testCreateAccountForDossierNewAccountWithDuplist(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        //IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        IBusinessDossierSelector selectorMockDossier = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
        IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
    // Given
        mocks.startStubbing();
        DutchBusinessWsdl.DutchBusinessDossierV3 dossier = new DutchBusinessWsdl.DutchBusinessDossierV3();
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