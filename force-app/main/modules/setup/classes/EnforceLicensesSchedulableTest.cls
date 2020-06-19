/**
 * Created by jaapbranderhorst on 17/05/2020.
 */

@IsTest
private class EnforceLicensesSchedulableTest {

    @IsTest
    static void testDoWork() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);
        ILicenseManagementService licenseManagementServiceMock = (ILicenseManagementService)mocks.mock(ILicenseManagementService.class);

        User[] users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        // users that breach contract
        User[] nonCompliantUsers = new List<User>();
        for (Integer i2 = 0; i2 < 12; i2++) {
            nonCompliantUsers.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }


        mocks.startStubbing();
        LicenseType[] licenseTypes = LicenseType.values();
        for (LicenseType licenseTp : licenseTypes) {
            mocks.when(licenseManagementServiceMock.getTotalNumberOfSeats(licenseTp)).thenReturn(10);
            if (licenseTp != LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS) {
                mocks.when(licenseManagementServiceMock.getAssignedUsersForLicenseType(licenseTp)).thenReturn(users);
            }
        }
        // company info for dutch business breaches the contract
        mocks.when(licenseManagementServiceMock.getAssignedUsersForLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(nonCompliantUsers);
        mocks.stopStubbing();

        Application.Service.setMock(ILicenseManagementService.class, licenseManagementServiceMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        // when
        Test.startTest();
        EnforceLicensesSchedulable enforceLicensesSchedulable = new EnforceLicensesSchedulable();
        enforceLicensesSchedulable.doWork();
        Test.stopTest();

        // then
        // an email should be send
        ((fflib_ISObjectUnitOfWork)mocks.verify(unitOfWorkMock)).registerEmail((Messaging.Email)fflib_Match.anyObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(unitOfWorkMock)).commitWork();
    }
}