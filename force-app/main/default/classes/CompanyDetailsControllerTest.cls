@isTest
public with sharing class CompanyDetailsControllerTest {

    @isTest
    public static void searchHappyScenarioTest(){

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        List<SearchForDossiersResultDto> serviceResponse = new List<SearchForDossiersResultDto>();

        String searchParams = '{"street":"Mendelssohnstraat","city":"Utrecht","postal_code":"3533XG","country":"Netherlands","name":"Appsolutely ","phone":"+31613341224","domain":"appsolutely.nl", "house_number": "1", "house_number_addition": "a"}';
        Map<String, Object> jsonDeserialized = (Map<String, Object>)JSON.deserializeUntyped(searchParams);
        String trade_name = (String)jsonDeserialized.get('name');
        String city = (String)jsonDeserialized.get('city');
        String street = (String)jsonDeserialized.get('street');
        String postcode = (String)jsonDeserialized.get('postal_code');
        Integer house_number = Integer.valueOf(jsonDeserialized.get('house_number'));
        String house_number_addition = (String)jsonDeserialized.get('house_number_addition');
        String telephone_number = (String)jsonDeserialized.get('phone');
        String domain_name = (String)jsonDeserialized.get('domain');

        mocks.startStubbing();
//        List<SearchForDossiersResultDto> searchForDossiers(String country, String trade_name, String registration_number, String vat_number, String city, String street, String postcode, Integer house_number, String house_number_addition, String province, String telephone_number, String domain_name);

        mocks.when(mockService.searchForDossiers('NL', trade_name, null, null, city, street, postcode, house_number, house_number_addition, null, telephone_number, domain_name)).thenReturn(serviceResponse);
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.search(searchParams);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.assert(wrapper.state == 'SUCCESS');
        System.assert(wrapper.response == serviceResponse);
    }

    @isTest
    public static void searchCCExceptionTest(){

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        String searchParams = '{"street":"Mendelssohnstraat","city":"Utrecht","postal_code":"3533XG","country":"Netherlands","name":"Appsolutely ","phone":"+31613341224","domain":"appsolutely.nl", "house_number": "1", "house_number_addition": "a"}';
        Map<String, Object> jsonDeserialized = (Map<String, Object>)JSON.deserializeUntyped(searchParams);
        String trade_name = (String)jsonDeserialized.get('name');
        String city = (String)jsonDeserialized.get('city');
        String street = (String)jsonDeserialized.get('street');
        String postcode = (String)jsonDeserialized.get('postal_code');
        Integer house_number = Integer.valueOf(jsonDeserialized.get('house_number'));
        String house_number_addition = (String)jsonDeserialized.get('house_number_addition');
        String telephone_number = (String)jsonDeserialized.get('phone');
        String domain_name = (String)jsonDeserialized.get('domain');

        mocks.startStubbing();
        // (String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search) {
 //       mocks.when(mockService.searchForDossiers(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, false)).thenThrow(new CCException('test'));
        mocks.when(mockService.searchForDossiers('NL', trade_name, null, null, city, street, postcode, house_number, house_number_addition, null, telephone_number, domain_name)).thenThrow(new CCException('test'));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.search(searchParams);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.assert(wrapper.errorMsg == 'test');
        System.assert(wrapper.state == 'ERROR');
    }

    @isTest
    public static void searchExceptionTest(){

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        String searchParams = '{"street":"Mendelssohnstraat","city":"Utrecht","postal_code":"3533XG","country":"Netherlands","name":"Appsolutely ","phone":"+31613341224","domain":"appsolutely.nl", "house_number": "1", "house_number_addition": "a"}';
        Map<String, Object> jsonDeserialized = (Map<String, Object>)JSON.deserializeUntyped(searchParams);
        String trade_name = (String)jsonDeserialized.get('name');
        String city = (String)jsonDeserialized.get('city');
        String street = (String)jsonDeserialized.get('street');
        String postcode = (String)jsonDeserialized.get('postal_code');
        Integer house_number = Integer.valueOf(jsonDeserialized.get('house_number'));
        String house_number_addition = (String)jsonDeserialized.get('house_number_addition');
        String telephone_number = (String)jsonDeserialized.get('phone');
        String domain_name = (String)jsonDeserialized.get('domain');

        mocks.startStubbing();
        // (String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search) {
        mocks.when(mockService.searchForDossiers('NL', trade_name, null, null, city, street, postcode, house_number, house_number_addition, null, telephone_number, domain_name)).thenThrow(new CustomException(Label.WSCall_Generic_UI_Exception));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.search(searchParams);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.assert(wrapper.errorMsg == System.Label.Error);
        System.assert(wrapper.state == 'ERROR');
    }

    @isTest
    public static void searchNoSearchParamsTest(){
        Test.startTest();
        Object result = CompanyDetailsController.search(null);
        Test.stopTest();

        System.assert(result == null);
    }

    @IsTest
    public static void createDossierHappyTest() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);

        mocks.startStubbing();
        InsertDossiersFromDataVendorResponseDTO responseDTO = new InsertDossiersFromDataVendorResponseDTO(new Business_Dossier__c(), false);
        mocks.when(mockService.insertSingleDossierFromDataVendorData('1234', '1234', null)).thenReturn(responseDTO);
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.createDossier('1234', '1234', null);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.assert(wrapper.response instanceof InsertDossiersFromDataVendorResponseDTO);

    }

    @IsTest
    public static void createDossierExceptionTest() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);

        mocks.startStubbing();
        mocks.when(mockService.insertSingleDossierFromDataVendorData('1234', '1234', null)).thenThrow(new CustomException('exception'));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.createDossier('1234', '1234', null);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.assert(wrapper.errorMsg == 'exception');
        System.assert(wrapper.state == 'ERROR');

    }

    @IsTest
    public static void deleteDossierHappyTest() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);

        mocks.startStubbing();
        mocks.when(mockService.deleteDossier(accountId)).thenReturn(true);
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.deleteDossier(accountId);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.assert(wrapper.response == true);

    }

    @IsTest
    public static void deleteDossierExceptionTest() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);

        mocks.startStubbing();
        mocks.when(mockService.deleteDossier(accountId)).thenThrow(new CCException('exception'));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.deleteDossier(accountId);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.assert(wrapper.errorMsg == 'exception');
        System.assert(wrapper.state == 'ERROR');

    }



    @IsTest
    public static void getVatHappyScenario() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockBusinessService = (IBusinessService)mocks.mock(IBusinessService.class);
        Id dossierId = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType);

        mocks.startStubbing();
        mocks.when(mockBusinessService.setVatNumber(dossierId)).thenReturn(new Business_Dossier__c(VAT_Number__c = '1234', Id = dossierId));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockBusinessService);

        Test.startTest();
        AuraResponseWrapper wrapper = (AuraResponseWrapper)CompanyDetailsController.getVATDetails(dossierId);
        Test.stopTest();

        System.assert(wrapper.response instanceof Business_Dossier__c);
        Business_Dossier__c response = (Business_Dossier__c)wrapper.response;
        System.assert(response.VAT_Number__c == '1234');
    }

    @IsTest
    public static void getVatCCVatNotFoundExceptionScenario() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockBusinessService = (IBusinessService)mocks.mock(IBusinessService.class);
        Id dossierId = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType);

        mocks.startStubbing();
        mocks.when(mockBusinessService.setVatNumber(dossierId)).thenThrow(new CCWsServerDataNotFoundVatException('test'));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockBusinessService);

        Test.startTest();
        AuraResponseWrapper wrapper = (AuraResponseWrapper)CompanyDetailsController.getVATDetails(dossierId);
        Test.stopTest();

        System.assert(wrapper.errorMsg == 'test');
        System.assert(wrapper.state == 'ERROR');
    }

    @IsTest
    public static void getVatGenericExceptionScenario() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockBusinessService = (IBusinessService)mocks.mock(IBusinessService.class);
        Id dossierId = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType);

        mocks.startStubbing();
        mocks.when(mockBusinessService.setVatNumber(dossierId)).thenThrow(new CustomException('test'));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockBusinessService);

        Test.startTest();
        AuraResponseWrapper wrapper = (AuraResponseWrapper)CompanyDetailsController.getVATDetails(dossierId);
        Test.stopTest();

        System.assert(wrapper.errorMsg == System.Label.Error);
        System.assert(wrapper.state == 'ERROR');
    }






}
    
