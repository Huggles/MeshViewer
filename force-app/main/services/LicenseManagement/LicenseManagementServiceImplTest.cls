/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

@IsTest
private class LicenseManagementServiceImplTest {

    @IsTest
    static void getAssignedUsersForLicenseTypeHappyFlow() {
        // given
        User[] users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IUserSelector userSelector = (IUserSelector)mocks.mock(IUserSelector.class);
        PermissionSetGroup permissionSetGroup = LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS);

        mocks.startStubbing();
        mocks.when(userSelector.selectByPermissionSetGroup(permissionSetGroup)).thenReturn(users);
        mocks.when(userSelector.sObjectType()).thenReturn(User.SObjectType);
        mocks.stopStubbing();

        Application.Selector.setMock(userSelector);

        // when
        Test.startTest();
        User[] usersToAssess = LicenseManagementService.getAssignedUsersForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS);
        Test.stopTest();

        // then
        System.assertEquals(10, usersToAssess.size());
    }

    @IsTest
    static void getNumberOfAvailableSeatsSeatsAvailable() {
        // given
        // 20 seats available
        FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_BUSINESS), 20);
        // 10 seats already assigned
        User[] users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IUserSelector userSelector = (IUserSelector)mocks.mock(IUserSelector.class);
        PermissionSetGroup permissionSetGroup = LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS);

        mocks.startStubbing();
        mocks.when(userSelector.selectByPermissionSetGroup(permissionSetGroup)).thenReturn(users);
        mocks.when(userSelector.sObjectType()).thenReturn(User.SObjectType);
        mocks.stopStubbing();

        Application.Selector.setMock(userSelector);


        // when
        Test.startTest();
        Integer numberOfSeatsAvailable = LicenseManagementService.getNumberOfAvailableSeats(LicenseType.COMPANY_INFO_FOR_BUSINESS);
        Test.stopTest();

        // then
        System.assertEquals(10, numberOfSeatsAvailable);

    }
}