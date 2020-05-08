/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

@IsTest
private class LicenseManagementServiceImplTest {

    @IsTest
    public static void testGetAssignedUsersForLicenseTypeHappyFlow() {
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
    public static void testGetNumberOfAvailableSeatsSeatsAvailable() {
        // given
        // 10 seats available
        // FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_BUSINESS), 20);
        // 5 seats already assigned
        User[] users = new List<User>();
        for (Integer i = 0; i < 5; i++) {
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
        System.assertEquals(5, numberOfSeatsAvailable);
    }

    @IsTest
    public static void testAssignLicenseTypeHappyFlow() {
        // happy flow is when there are enough LMA licenses and enough licensetype seats available

        // mock creation
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IPermissionSetAssignmentSelector  permissionSetAssignmentSelectorMock = (IPermissionSetAssignmentSelector)mocks.mock(IPermissionSetAssignmentSelector.class);
        IPackageLicenseSelector packageLicenseSelectorMock = (IPackageLicenseSelector)mocks.mock(IPackageLicenseSelector.class);
        IUserPackageSelector userPackageSelectorMock = (IUserPackageSelector)mocks.mock(IUserPackageSelector.class);
        IUserSelector userSelectorMock = (IUserSelector)mocks.mock(IUserSelector.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        // given
        // a fake PackageLicense with 10 total seats and 5 available
        mocks.startStubbing();
        mocks.when(permissionSetAssignmentSelectorMock.sObjectType()).thenReturn(PermissionSetAssignment.SObjectType);
        mocks.when(packageLicenseSelectorMock.sObjectType()).thenReturn(PackageLicense.SObjectType);
        mocks.when(userPackageSelectorMock.sObjectType()).thenReturn(UserPackageLicense.SObjectType);
        mocks.when(userSelectorMock.sObjectType()).thenReturn(User.SObjectType);

        List<PackageLicenseWrapper> packageLicenseWrappers = new List<PackageLicenseWrapper>{
                new PackageLicenseWrapper(fflib_IDGenerator.generate(PackageLicense.SObjectType), 5, 10, LicenseManagementServiceImpl.NAMESPACE_PREFIX)
        };
        mocks.when(packageLicenseSelectorMock.selectByNamespacePrefix(LicenseManagementServiceImpl.NAMESPACE_PREFIX)).thenReturn(packageLicenseWrappers);

        // 10 seats total
        // FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_BUSINESS), 20);

        // 5 new users and 5 existing
        User[] users = new List<User>();
        for (Integer i = 0; i <10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        // the first 5 of them already have a license (LMA and license seat)
        PermissionSetAssignment[] permissionSetAssignments = new List<PermissionSetAssignment>();
        UserPackageLicense[] userPackageLicenses = new List<UserPackageLicense>();
        List<User> usersWithPermissionsetGroup = new List<User>();
        List<User> usersWithoutPermissionSetGroup = new List<User>();
        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(Id = fflib_IDGenerator.generate(PermissionSetAssignment.SObjectType), AssigneeId = users.get(i).Id, PermissionSetGroupId = LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS).Id));
            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = packageLicenseWrappers.get(0).Id, UserId = users.get(i).Id));
            usersWithPermissionsetGroup.add(users.get(i));
            usersWithoutPermissionSetGroup.add(users.get(i+5));
        }
        mocks.when(permissionSetAssignmentSelectorMock.selectByPermissionSetGroupAndUsers(LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS), users)).thenReturn(permissionSetAssignments);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersWithPermissionsetGroup)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersWithoutPermissionSetGroup)).thenReturn(new List<UserPackageLicense>());
        mocks.when(userSelectorMock.selectByPermissionSetGroup(LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS))).thenReturn(usersWithPermissionsetGroup);
        mocks.stopStubbing();

        Application.Selector.setMock(permissionSetAssignmentSelectorMock);
        Application.Selector.setMock(packageLicenseSelectorMock);
        Application.Selector.setMock(userPackageSelectorMock);
        Application.Selector.setMock(userSelectorMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        // when
        Test.startTest();
        LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS, users);
        Test.stopTest();

        // then

        // we should have 10 new permission set assignments inserted
        List<Map<Schema.SObjectField, Object>> permissionSetAssignmentsToAssert = new List<Map<SObjectField, Object>>();
        for (Integer i = 5; i < 10; i++) {
            permissionSetAssignmentsToAssert.add(new Map<Schema.SObjectField, Object>{
                    PermissionSetAssignment.PermissionSetGroupId => LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS).Id,
                    PermissionSetAssignment.AssigneeId => users.get(i).Id
            });
        }
        ((fflib_ISObjectUnitOfWork)mocks.verify(unitOfWorkMock)).registerNew(fflib_Match.sObjectsWith(permissionSetAssignmentsToAssert, false));

        // and 10 user package licenses
        List<Map<Schema.SObjectField, Object>> userPackageLicensesToAssert = new List<Map<SObjectField, Object>>();
        for (Integer i = 5; i < 10; i++) {
            userPackageLicensesToAssert.add(new Map<Schema.SObjectField, Object>{
                    UserPackageLicense.PackageLicenseId => packageLicenseWrappers.get(0).Id,
                    UserPackageLicense.UserId => users.get(i).Id
            });
        }
        ((fflib_ISObjectUnitOfWork)mocks.verify(unitOfWorkMock)).registerNew(fflib_Match.sObjectsWith(userPackageLicensesToAssert, false));
    }

    @IsTest
    public static void testAssignLicenseTypeNotEnoughLicenseTypeSeats() {

        // mock creation
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IPermissionSetAssignmentSelector  permissionSetAssignmentSelectorMock = (IPermissionSetAssignmentSelector)mocks.mock(IPermissionSetAssignmentSelector.class);
        IPackageLicenseSelector packageLicenseSelectorMock = (IPackageLicenseSelector)mocks.mock(IPackageLicenseSelector.class);
        IUserPackageSelector userPackageSelectorMock = (IUserPackageSelector)mocks.mock(IUserPackageSelector.class);
        IUserSelector userSelectorMock = (IUserSelector)mocks.mock(IUserSelector.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        // given
        // a fake PackageLicense with 10 total seats and 5 available (so there are enough LMA licenses in this test case)
        mocks.startStubbing();
        mocks.when(permissionSetAssignmentSelectorMock.sObjectType()).thenReturn(PermissionSetAssignment.SObjectType);
        mocks.when(packageLicenseSelectorMock.sObjectType()).thenReturn(PackageLicense.SObjectType);
        mocks.when(userPackageSelectorMock.sObjectType()).thenReturn(UserPackageLicense.SObjectType);
        mocks.when(userSelectorMock.sObjectType()).thenReturn(User.SObjectType);

        List<PackageLicenseWrapper> packageLicenseWrappers = new List<PackageLicenseWrapper>{
                new PackageLicenseWrapper(fflib_IDGenerator.generate(PackageLicense.SObjectType), 5, 10, LicenseManagementServiceImpl.NAMESPACE_PREFIX)
        };
        mocks.when(packageLicenseSelectorMock.selectByNamespacePrefix(LicenseManagementServiceImpl.NAMESPACE_PREFIX)).thenReturn(packageLicenseWrappers);

        // 10 seats total
        // FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_BUSINESS), 20);

        // 10 new users and 5 existing
        User[] users = new List<User>();
        for (Integer i = 0; i < 15; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        // the first 5 of them already have a license (LMA and license seat)
        PermissionSetAssignment[] permissionSetAssignments = new List<PermissionSetAssignment>();
        UserPackageLicense[] userPackageLicenses = new List<UserPackageLicense>();
        List<User> usersWithPermissionsetGroup = new List<User>();

        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(Id = fflib_IDGenerator.generate(PermissionSetAssignment.SObjectType), AssigneeId = users.get(i).Id, PermissionSetGroupId = LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS).Id));
            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = packageLicenseWrappers.get(0).Id, UserId = users.get(i).Id));
            usersWithPermissionsetGroup.add(users.get(i));
        }

        // but the second 20 do not have an LMA and license seat
        List<User> usersWithoutPermissionSetGroup = new List<User>();
        for (Integer i = 5; i < 10; i++) {
            usersWithoutPermissionSetGroup.add(users.get(i));
        }

        mocks.when(permissionSetAssignmentSelectorMock.selectByPermissionSetGroupAndUsers(LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS), users)).thenReturn(permissionSetAssignments);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersWithPermissionsetGroup)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersWithoutPermissionSetGroup)).thenReturn(new List<UserPackageLicense>());
        mocks.when(userSelectorMock.selectByPermissionSetGroup(LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS))).thenReturn(usersWithPermissionsetGroup);
        mocks.stopStubbing();

        Application.Selector.setMock(permissionSetAssignmentSelectorMock);
        Application.Selector.setMock(packageLicenseSelectorMock);
        Application.Selector.setMock(userPackageSelectorMock);
        Application.Selector.setMock(userSelectorMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS, users);
        } catch(NotEnoughSeatsAvailableException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        // then

        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    public static void testAssignLicenseTypeNotEnoughLMASeats() {

        // mock creation
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IPermissionSetAssignmentSelector  permissionSetAssignmentSelectorMock = (IPermissionSetAssignmentSelector)mocks.mock(IPermissionSetAssignmentSelector.class);
        IPackageLicenseSelector packageLicenseSelectorMock = (IPackageLicenseSelector)mocks.mock(IPackageLicenseSelector.class);
        IUserPackageSelector userPackageSelectorMock = (IUserPackageSelector)mocks.mock(IUserPackageSelector.class);
        IUserSelector userSelectorMock = (IUserSelector)mocks.mock(IUserSelector.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        // given
        // a fake PackageLicense with 10 total seats and 0 available (so there are enough LMA licenses in this test case)
        mocks.startStubbing();
        mocks.when(permissionSetAssignmentSelectorMock.sObjectType()).thenReturn(PermissionSetAssignment.SObjectType);
        mocks.when(packageLicenseSelectorMock.sObjectType()).thenReturn(PackageLicense.SObjectType);
        mocks.when(userPackageSelectorMock.sObjectType()).thenReturn(UserPackageLicense.SObjectType);
        mocks.when(userSelectorMock.sObjectType()).thenReturn(User.SObjectType);

        List<PackageLicenseWrapper> packageLicenseWrappers = new List<PackageLicenseWrapper>{
                new PackageLicenseWrapper(fflib_IDGenerator.generate(PackageLicense.SObjectType), 10, 10, LicenseManagementServiceImpl.NAMESPACE_PREFIX)
        };
        mocks.when(packageLicenseSelectorMock.selectByNamespacePrefix(LicenseManagementServiceImpl.NAMESPACE_PREFIX)).thenReturn(packageLicenseWrappers);

        // 10 seats total
        // FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_BUSINESS), 30);

        // 5 new users and 5 existing
        User[] users = new List<User>();
        for (Integer i = 0; i <10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        // the first 10 of them already have a license (LMA and license seat)
        PermissionSetAssignment[] permissionSetAssignments = new List<PermissionSetAssignment>();
        UserPackageLicense[] userPackageLicenses = new List<UserPackageLicense>();
        List<User> usersWithPermissionsetGroup = new List<User>();

        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(Id = fflib_IDGenerator.generate(PermissionSetAssignment.SObjectType), AssigneeId = users.get(i).Id, PermissionSetGroupId = LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS).Id));
            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = packageLicenseWrappers.get(0).Id, UserId = users.get(i).Id));
            usersWithPermissionsetGroup.add(users.get(i));
        }

        // but the second 20 do not have an LMA and license seat
        List<User> usersWithoutPermissionSetGroup = new List<User>();
        for (Integer i = 5; i < 10; i++) {
            usersWithoutPermissionSetGroup.add(users.get(i));
        }

        mocks.when(permissionSetAssignmentSelectorMock.selectByPermissionSetGroupAndUsers(LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS), users)).thenReturn(permissionSetAssignments);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersWithPermissionsetGroup)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersWithoutPermissionSetGroup)).thenReturn(new List<UserPackageLicense>());
        mocks.when(userSelectorMock.selectByPermissionSetGroup(LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS))).thenReturn(usersWithPermissionsetGroup);
        mocks.stopStubbing();

        Application.Selector.setMock(permissionSetAssignmentSelectorMock);
        Application.Selector.setMock(packageLicenseSelectorMock);
        Application.Selector.setMock(userPackageSelectorMock);
        Application.Selector.setMock(userSelectorMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS, users);
        } catch(NotEnoughLMALicensesException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        // then

        System.assertEquals(true, exceptionThrown);
    }
}