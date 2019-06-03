@isTest
public with sharing class CompanyDetailsControllerTest {





    @isTest
    public static void searchTest(){

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IDutchBusinessService mockService = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);
        String searchParams = '{"street":"Utrecht, Van Alphenstraat 222, 2268NA","city":"VOORBURG","postcode":"2274NA","country":"Netherlands","province":"","name":"Appsolutely ","phone":"+31613341224","domain":"","dossier_number":"67511325"}';
        list<DutchBusinessDto.DutchBusinessReference> serviceResponse = new list<DutchBusinessDto.DutchBusinessReference>();
        AuraResponseWrapper output = new AuraResponseWrapper((Object)serviceResponse);
                
        mocks.startStubbing();
        mocks.when(mockService.searchForDossiers((DutchBusinessDto.dutchBusinessSearchParametersRequest)fflib_Match.anyObject())).thenReturn(output);
        
        mocks.stopStubbing();
        Application.Service.setMock(IDutchBusinessService.class, mockService);

        test.startTest();
        Object result = CompanyDetailsController.search(searchParams);
        //system.assertEquals('nulls', String.valueOf(result));
        ((IDutchBusinessService)mocks.verify(mockService, 1)).searchForDossiers((DutchBusinessDto.dutchBusinessSearchParametersRequest)fflib_Match.anyObject());
        test.stopTest();

    }
    @isTest
    public static void createDossierOneParamTest(){

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IDutchBusinessService mockService = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);
        
        // preparing service input data
        Account acc = new Account(Name = 'Test', Id=fflib_IDGenerator.generate(Account.SObjectType));
        String dossierNumber = '123456';
        Id accountId = acc.Id;
        // preparing service output data
        DutchBusinessDto.DutchBusinessGetDossierResponse serviceResponse = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        DutchBusinessDto.DutchBusinessGetDossierResponse outputDossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        AuraResponseWrapper output = new AuraResponseWrapper((Object)serviceResponse);
                
        mocks.startStubbing();
        mocks.when(mockService.getDossier(dossierNumber)).thenReturn(serviceResponse);
        mocks.when(mockService.upsertAccountAndDossier((DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject(), fflib_Match.anyId())).thenReturn(new list<object>());
        mocks.when(mockService.updateAccountDossier((DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject())).thenReturn('output');
        
        mocks.stopStubbing();
        Application.Service.setMock(IDutchBusinessService.class, mockService);

        test.startTest();
        Object result = CompanyDetailsController.createDossier(dossierNumber, accountId);
        //system.assertEquals('nulls', String.valueOf(result));
        ((IDutchBusinessService)mocks.verify(mockService, 1)).getDossier(dossierNumber);
        ((IDutchBusinessService)mocks.verify(mockService, 1)).upsertAccountAndDossier((DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject(), fflib_Match.anyId());
        ((IDutchBusinessService)mocks.verify(mockService, 1)).updateAccountDossier((DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject());
        test.stopTest();
    }

    @isTest
    public static void createDossierTwoParamTest(){

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IDutchBusinessService mockService = (IDutchBusinessService)mocks.mock(IDutchBusinessService.class);
        
        // preparing service input data
        Account acc = new Account(Name = 'Test', Id=fflib_IDGenerator.generate(Account.SObjectType));
        String dossierNumber = '123456';
        Id accountId = acc.Id;
        // preparing service output data
        DutchBusinessDto.DutchBusinessGetDossierResponse serviceResponse = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        serviceResponse.dossier_number = dossierNumber;
        //DutchBusinessDto.DutchBusinessGetDossierResponse outputDossier = new DutchBusinessDto.DutchBusinessGetDossierResponse();
        AuraResponseWrapper output = new AuraResponseWrapper((Object)serviceResponse);
                
        mocks.startStubbing();
        mocks.when(mockService.getDossier(dossierNumber)).thenReturn(serviceResponse);
        mocks.when(mockService.upsertAccountAndDossier((DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject(), fflib_Match.anyId())).thenReturn(new list<object>());
        mocks.when(mockService.updateAccountDossier((DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject())).thenReturn('output');
        mocks.when(mockService.getDossierAccount(dossierNumber)).thenReturn(acc);
        
        mocks.stopStubbing();
        Application.Service.setMock(IDutchBusinessService.class, mockService);

        test.startTest();
        Object result = CompanyDetailsController.createDossier(dossierNumber);

        ((IDutchBusinessService)mocks.verify(mockService, 1)).getDossier(dossierNumber);
        ((IDutchBusinessService)mocks.verify(mockService, 1)).getDossierAccount(dossierNumber);
        ((IDutchBusinessService)mocks.verify(mockService, 1)).upsertAccountAndDossier((DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject(), fflib_Match.anyId());
        ((IDutchBusinessService)mocks.verify(mockService, 1)).updateAccountDossier((DutchBusinessDto.DutchBusinessGetDossierResponse)fflib_Match.anyObject());
        
        test.stopTest();


    }




}
    