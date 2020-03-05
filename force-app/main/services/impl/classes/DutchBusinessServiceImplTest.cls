/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

@IsTest
private class DutchBusinessServiceImplTest {

    @IsTest
    public static void testSearchForDutchDossiersHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        mocks.startStubbing();
        DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult resultPage1 = new DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult();
        resultPage1.paging = new DutchBusinessWsdl.ResultInfo();
        resultPage1.paging.curpage = 1;
        resultPage1.paging.numpages = 2;
        resultPage1.paging.perpage = 20;
        resultPage1.paging.numresults = 30;
        resultPage1.paging.maxresults = 500;
        resultPage1.results = new DutchBusinessWsdl.DutchBusinessEstablishmentReferenceArray();

        DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult resultPage2 = new DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult();
        resultPage2.paging = new DutchBusinessWsdl.ResultInfo();
        resultPage2.paging.curpage = 2;
        resultPage2.paging.numpages = 2;
        resultPage2.paging.perpage = 20;
        resultPage2.paging.numresults = 30;
        resultPage2.paging.maxresults = 500;
        resultPage2.results = new DutchBusinessWsdl.DutchBusinessEstablishmentReferenceArray();
        
        List<DutchBusinessWsdl.DutchBusinessEstablishmentReference> establishmentReferences= new List<DutchBusinessWsdl.DutchBusinessEstablishmentReference>();
        for (Integer i = 0; i < resultPage1.paging.numresults; i++) {
            DutchBusinessWsdl.DutchBusinessEstablishmentReference establishmentReference = new DutchBusinessWsdl.DutchBusinessEstablishmentReference();
            establishmentReference.dossier_number = 'dossier_number' + i;
            establishmentReference.indication_main_establishment = true;
            establishmentReference.trade_name = 'trade_name' + i;
            establishmentReference.legal_name = 'legal_name' + i;
            establishmentReference.correspondence_street = 'correspondence_street' + i;
            establishmentReference.correspondence_city = 'correspondence_city' + i;
            establishmentReference.establishment_street = 'establishment_street' + i;
            establishmentReference.establishment_city = 'establishment_city' + i;
            establishmentReference.match_type = 'match_type' + i;
            establishmentReference.establishment_number = 'establishment_number' + i;
            establishmentReferences.add(establishmentReference);
        }

        resultPage1.results.item = new List<DutchBusinessWsdl.DutchBusinessEstablishmentReference>();
        for (Integer i = 0; i < 20; i++) {
            resultPage1.results.item.add(establishmentReferences[i]);
        }

        resultPage2.results.item = new List<DutchBusinessWsdl.DutchBusinessEstablishmentReference>();
        for (Integer i = 20; i < 30; i++) {
            resultPage2.results.item.add(establishmentReferences[i]);
        }
        mocks.when(mockWS.dutchBusinessSearch(null, 'trade_name', null, null, null, null, null, null, null, false, 1)).thenReturn(resultPage1);
        mocks.when(mockWS.dutchBusinessSearch(null, 'trade_name', null, null, null, null, null, null, null, false, 2)).thenReturn(resultPage2);

        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, mockWS);

        Test.startTest();
        List<Business_Dossier__c> dossiers = DutchBusinessService.searchForDutchDossiersSObject(null, 'trade_name', null, null, null, null, null, null, null);
        Test.stopTest();

        System.assert(dossiers.size() == 30);
        for (Business_Dossier__c businessDossier : dossiers) {
            System.assert(businessDossier.Dossier_Number__c.startsWith('dossier_number'));
            System.assert(businessDossier.Indication_Main_Establishment__c = true);
            System.assert(businessDossier.Correspondence_Street__c.startsWith('correspondence_street'));
            System.assert(businessDossier.Correspondence_City__c.startsWith('correspondence_city'));
            System.assert(businessDossier.Establishment_street__c.startsWith('establishment_street'));
            System.assert(businessDossier.Establishment_City__c.startsWith('establishment_city'));
            System.assert(businessDossier.Name.startsWith('legal_name'));
            System.assert(businessDossier.Trade_Name_Full__c.startsWith('trade_name'));
            System.assert(businessDossier.Establishment_Number__c.startsWith('establishment_number'));
        }
    }
    
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

        Test.startTest();
        DutchBusinessWsdl.DutchBusinessDossierV3 dossier = (new DutchBusinessServiceImpl()).getDossier(dossierNumber, null);
        Test.stopTest();

        System.assertNotEquals(null, dossier);

    }

    @IsTest
    public static void testGetDutchBusinessUpdatedDossiersSinceWrongInput() {
        // testing no changed date
        Boolean errorOccurred = false;
        try {
            DutchBusinessService.getDutchBusinessUpdatedDossiersSince(1, new List<String>{'test'}, null);
        } catch (CCInputException e) {
            errorOccurred = true;
        }
        System.assert(errorOccurred);
        // changed date after today
        errorOccurred = false;
        try {
            DutchBusinessService.getDutchBusinessUpdatedDossiersSince(1, new List<String>{'test'}, Date.today() + 1);
        } catch (CCInputException e) {
            errorOccurred = true;
        }
        System.assert(errorOccurred);
        // no pagenr
        errorOccurred = false;
        try {
            DutchBusinessService.getDutchBusinessUpdatedDossiersSince(null, new List<String>{'test'}, Date.today());
        } catch (CCInputException e) {
            errorOccurred = true;
        }
        System.assert(errorOccurred);
        // pagenr negative
        errorOccurred = false;
        try {
            DutchBusinessService.getDutchBusinessUpdatedDossiersSince(-1, new List<String>{'test'}, Date.today());
        } catch (CCInputException e) {
            errorOccurred = true;
        }
        System.assert(errorOccurred);
        // no update list
        errorOccurred = false;
        try {
            DutchBusinessService.getDutchBusinessUpdatedDossiersSince(1, null, Date.today());
        } catch (CCInputException e) {
            errorOccurred = true;
        }
        System.assert(errorOccurred);
        // at least one update type should be provided
        errorOccurred = false;
        try {
            DutchBusinessService.getDutchBusinessUpdatedDossiersSince(1, new List<String>(), Date.today());
        } catch (CCInputException e) {
            errorOccurred = true;
        }
        System.assert(errorOccurred);
    }

    @IsTest
    public static void testGetDutchBusinessUpdatedDossiersHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        Integer pageNr = 1;
        List<String> updateTypesResponse = new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress'};

        DutchBusinessWsdl.stringArray updateTypesArrayResponse = new DutchBusinessWsdl.stringArray();
        updateTypesArrayResponse.item = new List<String>();
        for (String s : updateTypesResponse) {
            updateTypesArrayResponse.item.add(s);
        }
        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();
        output.paging = new DutchBusinessWsdl.ResultInfo();
        output.paging.numpages = 3;
        output.results = new DutchBusinessWsdl.DutchBusinessUpdateReferenceArray();
        output.results.item = new List<DutchBusinessWsdl.DutchBusinessUpdateReference>();
        DutchBusinessWsdl.DutchBusinessUpdateReference a1 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a1.dossier_number = '1';
        a1.establishment_number = '2';
        a1.update_types = updateTypesArrayResponse;
        output.results.item.add(a1);

        mocks.startStubbing();
        mocks.when(mockWS.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray)fflib_Match.anyObject(), fflib_Match.anyInteger())).thenReturn(output);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, mockWS);

        test.startTest();
        List<UpdateDossierReferenceDTO> updateDossierReferenceDTOS = DutchBusinessService.getDutchBusinessUpdatedDossiersSince(pageNr, updateTypesResponse, date.today());
        test.stopTest();

        system.assertEquals(1, updateDossierReferenceDTOS.size());

    }

    @IsTest
    public static void testUpdateDossiersWithVendorDataNotEnoughCallouts() {
        // given
        // nr of update dossiers really big
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (Integer i = 0; i < 200; i++) {
            dossiers.add(new Business_Dossier__c(Name = '' + i));
        }

        // when
        Boolean errorThrown = false;
        Test.startTest();
        try {
            DutchBusinessService.updateDossiersWithVendorData(dossiers);
        } catch (CCInputException e){
            errorThrown = true;
        }
        Test.stopTest();

        // then
        System.assert(errorThrown);
        // an error should be thrown
    }

    @IsTest
    public static void testUpdateDossiersHappyFlow() {
        // given
        // a dossier to be updated
        Business_Dossier__c dossierToBeUpdated = (new DutchBusinessServiceImpl()).mapDutchBusinessDossierV3ToDossier(getDataVendorMockDossier(), new Business_Dossier__c());
        dossierToBeUpdated.Name = 'I need to be updated';
        Account account = new Account(Name = 'testAccount');
        insert Account;
        dossierToBeUpdated.Account__c = account.Id;
        insert dossierToBeUpdated;
        // a mock dossier from the webservice
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness wsDutchBusinessMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        mocks.startStubbing();
        mocks.when(wsDutchBusinessMock.dutchBusinessGetDossierV3('123456', '10')).thenReturn(getDataVendorMockDossier());
        mocks.stopStubbing();
        Application.Service.setMOck(IWsDutchBusiness.class, wsDutchBusinessMock);

        // when
        // we update the dossier
        Test.startTest();
        DutchBusinessService.updateDossiersWithVendorData(new List<Business_Dossier__c>{dossierToBeUpdated});
        Test.stopTest();

        // then
        // the updated dossier should assert
        assertDossier(account.Id);

    }

    @IsTest
    public static void testUpdateVATNumberNoVatKnown() {

        // given
        // we have a dossier for which we don't know the vat number
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        Id accountId = null;
        DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessDossierV3 = getDataVendorMockDossier();
        DutchBusinessWsdl.DutchBusinessVatNumber vatResponse = new DutchBusinessWsdl.DutchBusinessVatNumber();
        vatResponse.dossier_number = dutchBusinessDossierV3.dossier_number;
        vatResponse.vat_number = null;
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dutchBusinessDossierV3.dossier_number, dutchBusinessDossierV3.establishment_number)).thenReturn(dutchBusinessDossierV3);
        mocks.when(webserviceMock.dutchBusinessGetVatNumber(dutchBusinessDossierV3.dossier_number)).thenReturn(vatResponse);
        mocks.stopStubbing();
        Business_Dossier__c dossier = (new DutchBusinessServiceImpl()).mapDutchBusinessDossierV3ToDossier(dutchBusinessDossierV3, new Business_Dossier__c());


        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        // when
        Test.startTest();
        Business_Dossier__c dossierToAssert = DutchBusinessService.updateBusinessDossierWithVATNumber(dossier);
        Test.stopTest();

        // then
        System.assert(dossierToAssert.Dossier_Number__c == dossier.Dossier_Number__c);
        System.assert(dossierToAssert.VAT_Number__c == null);
        System.assert(dossierToAssert.No_VAT_Number__c = true);
    }

    @IsTest
    public static void testStoreDossiers() {
        // given
        // a new dossier, fresh from CI
        DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessDossierV3 = getDataVendorMockDossier();
        Business_Dossier__c dossier = (new DutchBusinessServiceImpl()).mapDutchBusinessDossierV3ToDossier(dutchBusinessDossierV3, new Business_Dossier__c());

        // when
        Test.startTest();
        DutchBusinessService.storeDossiers(new List<Business_Dossier__c>{dossier}, null);

        // then
        System.assert([SELECT Id FROM Business_Dossier__c].size() == 1);

        // given
        // a dossier with a name to be updated
        String newName = 'testStoreDossiers';
        dossier.Name = newName;

        // when
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        DutchBusinessService.storeDossiers(new List<Business_Dossier__c>{dossier}, unitOfWork);
        unitOfWork.commitWork();
        Test.stopTest();

        List<Business_Dossier__c> dossiersToAssert = [SELECT Name, Id FROM Business_Dossier__c];

        System.assert(dossiersToAssert.size() == 1);
        System.assert(dossiersToAssert[0].Name == newName);

    }

    @IsTest
    public static void testUpdateVATNumberVatKnown() {

        // given
        // we have a dossier for which we know the vat number
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        Id accountId = null;
        DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessDossierV3 = getDataVendorMockDossier();
        DutchBusinessWsdl.DutchBusinessVatNumber vatResponse = new DutchBusinessWsdl.DutchBusinessVatNumber();
        vatResponse.dossier_number = dutchBusinessDossierV3.dossier_number;
        vatResponse.vat_number = '12345';
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dutchBusinessDossierV3.dossier_number, dutchBusinessDossierV3.establishment_number)).thenReturn(dutchBusinessDossierV3);
        mocks.when(webserviceMock.dutchBusinessGetVatNumber(dutchBusinessDossierV3.dossier_number)).thenReturn(vatResponse);
        mocks.stopStubbing();
        Business_Dossier__c dossier = (new DutchBusinessServiceImpl()).mapDutchBusinessDossierV3ToDossier(dutchBusinessDossierV3, new Business_Dossier__c());

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        // when
        Test.startTest();
        Business_Dossier__c dossierToAssert = DutchBusinessService.updateBusinessDossierWithVATNumber(dossier);
        Test.stopTest();

        // then
        System.assert(dossierToAssert.Dossier_Number__c == dossier.Dossier_Number__c);
        System.assert(dossierToAssert.VAT_Number__c == vatResponse.vat_number);
        System.assert(dossierToAssert.No_VAT_Number__c == false);
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
        InsertDossiersFromDataVendorResponseDTO responseDTO = (new BusinessServiceImpl()).insertSingleDossierFromDataVendorData(null, dataVendorDossierOriginal.dossier_number, dataVendorDossierOriginal.establishment_number, CustomerConnect.DataVendor.COMPANY_INFO.name(), accountId);

        Test.startTest();
        {
            Business_Dossier__c dossierReturned = DutchBusinessService.setVatNumber(responseDTO.dossier.Id);
        }
        Test.stopTest();
        List<Business_Dossier__c> dossiersInDb = [SELECT Id, VAT_Number__c FROM Business_Dossier__c];
        System.assert(dossiersInDb.size() == 1);
        System.assert(dossiersInDb.get(0).VAT_Number__c == vatResponse.vat_number);

    }

    @IsTest
    public static void testInsertAccountHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        Test.startTest();
        {
            List<InsertAccountResponseDTO> responseDTOS = (new DutchBusinessServiceImpl()).insertAccount(new List<DutchBusinessWsdl.DutchBusinessDossierV3>{dataVendorDossier}, unitOfWorkMock);
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
                List<InsertAccountResponseDTO> responseDTOS = (new DutchBusinessServiceImpl()).insertAccount(new List<DutchBusinessWsdl.DutchBusinessDossierV3>{dataVendorDossier}, unitOfWorkMock);
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
            List<InsertAccountResponseDTO> responseDTOS = (new DutchBusinessServiceImpl()).insertAccount(new List<DutchBusinessWsdl.DutchBusinessDossierV3>{dataVendorDossier}, unitOfWorkMock);
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

    private static void assertDossier(Id accountId) {
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
                FROM Business_Dossier__c LIMIT 1];
        System.assert(dossierDB != null);
        if (accountId != null)
            System.assert(dossierDB.Account__c == accountId);

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

        InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData(null, dossierNumber, establishmentNUmber, CustomerConnect.DataVendor.COMPANY_INFO.name(), accountId);
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
            responseDTO = BusinessService.insertSingleDossierFromDataVendorData(null, dossierNumber, establishmentNUmber, CustomerConnect.DataVendor.COMPANY_INFO.name(), accountId);
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
                responseDTO = BusinessService.insertSingleDossierFromDataVendorData(null, dossierNumber, establishmentNUmber, CustomerConnect.DataVendor.COMPANY_INFO.name(), null);
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
                responseDTO = BusinessService.insertSingleDossierFromDataVendorData(null, dossierNumber, establishmentNUmber, CustomerConnect.DataVendor.COMPANY_INFO.name(), null);
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
            responseDTO = BusinessService.insertSingleDossierFromDataVendorData(null, dossierNumber, establishmentNUmber, CustomerConnect.DataVendor.COMPANY_INFO.name(), null);
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
            responseDTO = BusinessService.insertSingleDossierFromDataVendorData(null, dossierNumber, establishmentNUmber, CustomerConnect.DataVendor.COMPANY_INFO.name(), acc.Id);
        }
        Test.stopTest();
        System.assert(responseDTO != null);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
        Account accountDB = [SELECT Id, Name FROM Account];
        System.assert(accountDB != null);
        System.assert(accountDB.Name == acc.Name);
        assertDossier(accountDB.Id);


    }

    @IsTest
    private static void testCreateDutchDossierHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDataVendorMockDossier();
        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dataVendorDossier);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);
        Business_Dossier__c dossier = null;

        Test.startTest();
        {
            dossier = DutchBusinessService.createDutchDossier(dossierNumber, establishmentNUmber, false);
        }
        Test.stopTest();
        System.assert(dossier != null);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
        assertDossier(null);
    }

    @IsTest
    private static void testCreateDutchDossierHappyFlowWithVAT() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        String dossierNumber = '1234';
        String establishmentNUmber = '1234';
        DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessDossierV3 = getDataVendorMockDossier();DutchBusinessWsdl.DutchBusinessVatNumber vatResponse = new DutchBusinessWsdl.DutchBusinessVatNumber();
        vatResponse.dossier_number = dutchBusinessDossierV3.dossier_number;
        vatResponse.vat_number = '12345';

        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNUmber)).thenReturn(dutchBusinessDossierV3);
        mocks.when(webserviceMock.dutchBusinessGetVatNumber(dutchBusinessDossierV3.dossier_number)).thenReturn(vatResponse);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);
        Business_Dossier__c dossier = null;

        Test.startTest();
        {
            dossier = DutchBusinessService.createDutchDossier(dossierNumber, establishmentNUmber, true);
        }
        Test.stopTest();
        System.assert(dossier != null);
        System.assert([SELECT Id FROM Error_Log__c].size() == 0);
        System.assert(dossier.VAT_Number__c == vatResponse.vat_number);
        assertDossier(null);
    }

    @IsTest
    private static void testCreateDutchDossierNoDossierNumber() {
        // given
        // no dossiernumber
        String dossierNumber = null;
        String establishmentNumber = '123';

        // when
        Business_Dossier__c dossier = null;
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            {
                dossier = DutchBusinessService.createDutchDossier(dossierNumber, establishmentNUmber, false);
            }
        } catch (CCInputException e) {
            exceptionThrown = true;
        }

        // then
        // error thrown
        System.assert(exceptionThrown);
    }

    @IsTest
    private static void testProcessRemovedDutchDossiersNullDossiers() {
        Test.startTest();
        try {
            (new DutchBusinessServiceImpl()).processRemovedDutchDossiers(null);
        } catch (Exception e) {
            System.assert(false);
        }
        Test.stopTest();
        System.assert(true);
    }

    @IsTest
    private static void testProcessRemovedDutchDossiersHappyFlow() {
        Integer nrOfDossiers = 2;
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (Integer i = 0; i < nrOfDossiers; i++) {
            dossiers.add(new Business_Dossier__c(Name = '' + i));
        }
        insert dossiers;

        Test.startTest();
        (new DutchBusinessServiceImpl()).processRemovedDutchDossiers(dossiers);
        Test.stopTest();

        List<Business_Dossier__c> dossiersToAssert = [SELECT Id FROM Business_Dossier__c WHERE Is_Removed__c = true];
        System.assert(dossiers.size() == dossiersToAssert.size());
    }




}