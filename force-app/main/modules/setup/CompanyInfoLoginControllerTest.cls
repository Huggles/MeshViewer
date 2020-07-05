/**
 * Created by jaapbranderhorst on 04/07/2020.
 */

@IsTest
private class CompanyInfoLoginControllerTest {
    @IsTest
    static void testSaveUsernamePasswordHappyFlow() {
        //given

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessAccountingService businessService = (IBusinessAccountingService)mocks.mock(IBusinessAccountingService.class);

        Application.Service.setMock(IBusinessAccountingService.class, businessService);

        Test.startTest();
        {
            CompanyInfoLoginController.saveUsernamePassword('test', 'test');
        }
        Test.stopTest();
    }

    @IsTest
    static void testSaveUsernamePasswordError() {
        //given

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessAccountingService businessService = (IBusinessAccountingService)mocks.mock(IBusinessAccountingService.class);

        mocks.startStubbing();
        ((IBusinessAccountingService)mocks.doThrowWhen(new CCException('test'), businessService)).saveDataUserCredentials('test', 'test');
        mocks.stopStubbing();

        Application.Service.setMock(IBusinessAccountingService.class, businessService);
        Boolean exceptionThrown = false;

        Test.startTest();
        {
            try {
                CompanyInfoLoginController.saveUsernamePassword('test', 'test');
            } catch(AuraHandledException ex) {
                exceptionThrown = true;
            }
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    static void testGetCredentialsHappyFlow() {
        //given

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessAccountingService businessService = (IBusinessAccountingService)mocks.mock(IBusinessAccountingService.class);

        mocks.startStubbing();
        mocks.when(businessService.getCredentials()).thenReturn(new Credentials__c(Username__c = 'test', Password__c = 'test'));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessAccountingService.class, businessService);

        AuraResponseWrapper responseWrapper;
        Test.startTest();
        {
            responseWrapper = CompanyInfoLoginController.getCredentials();
        }
        Test.stopTest();

        System.assertEquals('SUCCESS', responseWrapper.state);
        System.assertEquals(true, responseWrapper.data instanceof CompanyInfoLoginController.Credentials);
        System.assertEquals('test', ((CompanyInfoLoginController.Credentials)responseWrapper.data).username);
        System.assertEquals('test', ((CompanyInfoLoginController.Credentials)responseWrapper.data).password);
    }

    @IsTest
    static void testGetCredentialsErrorFlow() {
        //given

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessAccountingService businessService = (IBusinessAccountingService)mocks.mock(IBusinessAccountingService.class);

        mocks.startStubbing();
        mocks.when(businessService.getCredentials()).thenThrow(new CustomException('test'));
        mocks.stopStubbing();
        Application.Service.setMock(IBusinessAccountingService.class, businessService);

        AuraResponseWrapper responseWrapper;
        Test.startTest();
        {
            responseWrapper = CompanyInfoLoginController.getCredentials();
        }
        Test.stopTest();

        System.assertEquals('ERROR', responseWrapper.state);
        System.assertEquals('test', responseWrapper.error.message);
    }




}