/**
 * Created by jaapbranderhorst on 04/07/2020.
 */

@IsTest
private class BusinessSearchFormControllerTest {
    @IsTest
    static void testGetCountryOptionsHappyFlow() {
        //given

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService businessService = (IBusinessService)mocks.mock(IBusinessService.class);

        mocks.startStubbing();
        mocks.when(businessService.getCountryOptionsForBusinessSearch()).thenReturn(new Map<String, String>{'test' => 'test', 'test2' => 'test2'});
        mocks.stopStubbing();

        Application.Service.setMock(IBusinessService.class, businessService);

        AuraResponseWrapper responseWrapper;
        Test.startTest();
        {
            responseWrapper = BusinessSearchFormController.getCountryOptions();
        }
        Test.stopTest();

        System.assertEquals('SUCCESS', responseWrapper.state);
        System.assertEquals(2, ((List<BusinessSearchFormController.CountryOption>)responseWrapper.data).size());
        List<BusinessSearchFormController.CountryOption> countryOptions = (List<BusinessSearchFormController.CountryOption>)responseWrapper.data;
        for (BusinessSearchFormController.CountryOption countryOption : countryOptions) {
            System.assertEquals(true, countryOption.label.startsWith('test'));
            System.assertEquals(true, countryOption.value.startsWith('test'));
        }
    }

    @IsTest
    static void testGetCountryOptionsErrorFlow() {
        //given

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService businessService = (IBusinessService)mocks.mock(IBusinessService.class);

        mocks.startStubbing();
        mocks.when(businessService.getCountryOptionsForBusinessSearch()).thenThrow(new CustomException('test'));
        mocks.stopStubbing();

        Application.Service.setMock(IBusinessService.class, businessService);

        AuraResponseWrapper responseWrapper;
        Test.startTest();
        {
            responseWrapper = BusinessSearchFormController.getCountryOptions();
        }
        Test.stopTest();

        System.assertEquals('ERROR', responseWrapper.state);
        System.assertEquals('test', responseWrapper.error.message);
    }

    @IsTest
    static void testGetSelectedDataSourceErrorFlow() {
        //given

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ISetupService setupService = (ISetupService)mocks.mock(ISetupService.class);

        mocks.startStubbing();
        mocks.when(setupService.getSelectedDataSource('NLD')).thenThrow(new CustomException('test'));
        mocks.stopStubbing();

        Application.Service.setMock(ISetupService.class, setupService);

        AuraResponseWrapper responseWrapper;
        Test.startTest();
        {
            responseWrapper = BusinessSearchFormController.getSelectedDataSource('NLD');
        }
        Test.stopTest();

        System.assertEquals('ERROR', responseWrapper.state);
        System.assertEquals('test', responseWrapper.error.message);
    }

    @IsTest
    static void testGetSelectedDataSourceHappyFlow() {
        //given

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ISetupService setupService = (ISetupService)mocks.mock(ISetupService.class);

        mocks.startStubbing();
        mocks.when(setupService.getSelectedDataSource('NLD')).thenReturn(new Data_source__mdt(Id = fflib_IDGenerator.generate(Data_source__mdt.SObjectType), DeveloperName = 'test'));
        mocks.stopStubbing();

        Application.Service.setMock(ISetupService.class, setupService);

        AuraResponseWrapper responseWrapper;
        Test.startTest();
        {
            responseWrapper = BusinessSearchFormController.getSelectedDataSource('NLD');
        }
        Test.stopTest();

        System.assertEquals('SUCCESS', responseWrapper.state);
        System.assertEquals('test', (String)responseWrapper.data);
    }


}