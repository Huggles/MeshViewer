@isTest
public with sharing class CompanyDetailsControllerTest {

    @isTest
    public static void searchHappyScenarioTest(){

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        String searchParams = '{"street":"Utrecht, Van Alphenstraat 222, 2268NA","city":"VOORBURG","postcode":"2274NA","country":"Netherlands","province":"","name":"Appsolutely ","phone":"+31613341224","domain":"","dossier_number":"67511325"}';
        List<DutchBusinessDto.DutchBusinessReference> serviceResponse = new List<DutchBusinessDto.DutchBusinessReference>();
                
        mocks.startStubbing();
        mocks.when(mockService.searchForDossiers((DutchBusinessDto.dutchBusinessSearchParametersRequest)fflib_Match.anyObject())).thenReturn(serviceResponse);
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.search(searchParams);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.debug(wrapper);
        System.assert(wrapper.state == 'SUCCESS');
        System.assert(wrapper.response == serviceResponse);
    }

    @isTest
    public static void searchCCExceptionTest(){

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService mockService = (IBusinessService)mocks.mock(IBusinessService.class);
        String searchParams = '{"street":"Utrecht, Van Alphenstraat 222, 2268NA","city":"VOORBURG","postcode":"2274NA","country":"Netherlands","province":"","name":"Appsolutely ","phone":"+31613341224","domain":"","dossier_number":"67511325"}';

        mocks.startStubbing();
        mocks.when(mockService.searchForDossiers((DutchBusinessDto.dutchBusinessSearchParametersRequest)fflib_Match.anyObject())).thenThrow(new CCException('test'));
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
        String searchParams = '{"street":"Utrecht, Van Alphenstraat 222, 2268NA","city":"VOORBURG","postcode":"2274NA","country":"Netherlands","province":"","name":"Appsolutely ","phone":"+31613341224","domain":"","dossier_number":"67511325"}';

        mocks.startStubbing();
        mocks.when(mockService.searchForDossiers((DutchBusinessDto.dutchBusinessSearchParametersRequest)fflib_Match.anyObject())).thenThrow(new CustomException('test'));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessService.class, mockService);

        Test.startTest();
        Object result = CompanyDetailsController.search(searchParams);
        Test.stopTest();

        System.assert(result instanceof  AuraResponseWrapper);
        AuraResponseWrapper wrapper = (AuraResponseWrapper)result;
        System.assert(wrapper.errorMsg == System.Label.WSCall_Generic_UI_Exception);
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
        mocks.when(mockBusinessService.setVatNumber(dossierId)).thenThrow(new CCVatNotFoundException('test'));
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
        System.debug(wrapper);

        System.assert(wrapper.errorMsg == System.Label.WSCall_Generic_UI_Exception);
        System.assert(wrapper.state == 'ERROR');
    }






}
    
