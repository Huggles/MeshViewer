/**
 * Created by jaapbranderhorst on 04/07/2020.
 */

@IsTest
private class FeatureAccessControlControllerTest {
    @IsTest
    static void testCheckAccessHappyFlow() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ILicenseManagementService licenseManagementService = (ILicenseManagementService)mocks.mock(ILicenseManagementService.class);

        mocks.startStubbing();
        mocks.when(licenseManagementService.userHasAccess(Feature.INTERNATIONAL_BUSINESS_SEARCH)).thenReturn(true);
        mocks.stopStubbing();

        Application.Service.setMock(ILicenseManagementService.class, licenseManagementService);

        //when
        Boolean returnValue;
        Test.startTest();
        {
            returnValue = (Boolean)FeatureAccessControlController.checkAccess(Feature.INTERNATIONAL_BUSINESS_SEARCH.name()).data;
        }
        Test.stopTest();
        System.assertEquals(true, returnValue);
    }

    @IsTest
    static void testCheckAccessErrorThrown() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ILicenseManagementService licenseManagementService = (ILicenseManagementService)mocks.mock(ILicenseManagementService.class);

        mocks.startStubbing();
        mocks.when(licenseManagementService.userHasAccess(Feature.INTERNATIONAL_BUSINESS_SEARCH)).thenThrow(new CustomException('test'));
        mocks.stopStubbing();

        Application.Service.setMock(ILicenseManagementService.class, licenseManagementService);

        //when
        AuraResponseWrapper returnValue;
        Test.startTest();
        {
            returnValue = FeatureAccessControlController.checkAccess(Feature.INTERNATIONAL_BUSINESS_SEARCH.name());
        }
        Test.stopTest();
        System.assert(returnValue.state == 'ERROR');
        System.assert(returnValue.error.message == 'test');
    }
}