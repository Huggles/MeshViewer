/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

@IsTest
private class LicenseManagementServiceImplTest {

    @IsTest
    static void testGetLicenseTypeNameHappyFlow() {
        // given
        // an existing LicenseType with a name defined

        // when
        Test.startTest();
        String name = LicenseManagementService.getLicenseTypeName(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);
        Test.stopTest();

        // then
        License_Type_Definition__mdt licenseTypeDefinition = [SELECT Title__c FROM License_Type_Definition__mdt WHERE Licence_Type_Name__c =: LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS.name()];
        System.assertEquals(licenseTypeDefinition.Title__c, name);
    }

    @IsTest
    static void testGetTotalNumberOfSeatsHappyFlow() {
        // given
        // an existing LicenseType with a feature param defined

        // when
        Test.startTest();
        Integer nrOfSeats = LicenseManagementService.getTotalNumberOfSeats(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);
        Test.stopTest();

        // then
        System.assertEquals(10, nrOfSeats);
    }

    @IsTest
    static void testGetTotalNumberOfSeatsNoFeatureParamNameDefined() {
        // given
        // an existing LicenseType with no feature param API name defined

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            Integer nrOfSeats = LicenseManagementService.getTotalNumberOfSeats(LicenseType.TEST_LICENSE_TYPE);
        } catch(NoFeatureParamForLicenseTypeException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

        // then
        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    static void testGetTotalNumberOfSeatsNoFeatureParamDefined() {
        // given
        // an existing LicenseType with no feature param API name defined

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            Integer nrOfSeats = LicenseManagementService.getTotalNumberOfSeats(LicenseType.TEST_LICENSE_TYPE);
        } catch(NoFeatureParamForLicenseTypeException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

        // then
        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    static void testGetLicenseTypeByNameHappyFlow() {
        // given
        // an existing license type name
        String name = LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS.name();

        // when
        Test.startTest();
        LicenseType type = LicenseManagementService.getLicenseTypeByName(name);
        Test.stopTest();

        // then
        System.assertEquals(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, type);
    }

    @IsTest
    static void testGetLicenseTypeByNameNoSuchLicenseType() {
        // given
        // a non-existing license type name
        String name = 'bogus';

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            LicenseType type = LicenseManagementService.getLicenseTypeByName(name);
        } catch(NoSuchLicenseTypeException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

        // then
        System.assertEquals(true, exceptionThrown);
    }



    @IsTest
    static void testUnassignLicenseTypeHappyFlow() {
        // happy flow: license seats have been assigned to users and the users only have this license type

        // given

        // 10 users with license assignments
        User[] users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        List<UserPackageLicense> userPackageLicenses = new List<UserPackageLicense>();
        Id permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id;
        for (Integer i = 0; i < 10; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(Id = fflib_IDGenerator.generate(PermissionSetAssignment.SObjectType), AssigneeId = users.get(i).Id, PermissionSetId = permissionSetId));
            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = LicenseManagementServiceImpl.packageLicense.id, UserId = users.get(i).Id));
        }

        // 5 who need to be unassigned
        User[] usersToUnassign = new List<User>();
        List<PermissionSetAssignment> permissionSetAssignmentsToRemove = new List<PermissionSetAssignment>();
        List<UserPackageLicense> userPackageLicensesToRemove = new List<UserPackageLicense>();
        for (Integer i = 0; i < 5; i++) {
            usersToUnassign.add(users.get(i));
            permissionSetAssignmentsToRemove.add(permissionSetAssignments.get(i));
            userPackageLicensesToRemove.add(userPackageLicenses.get(i));
        }

        // start stubbing
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IPermissionSetAssignmentSelector  permissionSetAssignmentSelectorMock = (IPermissionSetAssignmentSelector)mocks.mock(IPermissionSetAssignmentSelector.class);
        IPackageLicenseSelector packageLicenseSelectorMock = (IPackageLicenseSelector)mocks.mock(IPackageLicenseSelector.class);
        IUserPackageSelector userPackageSelectorMock = (IUserPackageSelector)mocks.mock(IUserPackageSelector.class);
        IUserSelector userSelectorMock = (IUserSelector)mocks.mock(IUserSelector.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        mocks.startStubbing();
        // sobject types for the selectors (otherwise the mock cannot be found by the Application.Selector factory)
        mocks.when(permissionSetAssignmentSelectorMock.sObjectType()).thenReturn(PermissionSetAssignment.SObjectType);
        mocks.when(packageLicenseSelectorMock.sObjectType()).thenReturn(PackageLicense.SObjectType);
        mocks.when(userPackageSelectorMock.sObjectType()).thenReturn(UserPackageLicense.SObjectType);
        mocks.when(userSelectorMock.sObjectType()).thenReturn(User.SObjectType);

        // ensure the right permission set assignments are returned
        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users)).thenReturn(permissionSetAssignments);
        Set<LicenseType> otherLicenseTypes = new Set<LicenseType>(LicenseType.values());
        otherLicenseTypes.remove(licenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);
        for (LicenseType licenseType : otherLicenseTypes) {
            mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(licenseType, usersToUnassign)).thenReturn(new List<PermissionSetAssignment>());
        }
        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersToUnassign)).thenReturn(permissionSetAssignmentsToRemove);

        // and the package licenses
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(LicenseManagementServiceImpl.packageLicense, users)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(LicenseManagementServiceImpl.packageLicense, usersToUnassign)).thenReturn(userPackageLicensesToRemove);

        // users
        mocks.when(userSelectorMock.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(userPackageLicensesToRemove); // need to check
        mocks.stopStubbing();

        Application.Selector.setMock(permissionSetAssignmentSelectorMock);
        Application.Selector.setMock(packageLicenseSelectorMock);
        Application.Selector.setMock(userPackageSelectorMock);
        Application.Selector.setMock(userSelectorMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        LicenseManagementServiceImpl.isTestingLicenseManagement = true;
        // when
        Test.startTest();
        LicenseManagementService.unassignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersToUnassign);
        Test.stopTest();

        // then
        // all permission set assignments should be deleted
        List<Map<Schema.SObjectField, Object>> permissionSetAssignmentsToAssert = new List<Map<SObjectField, Object>>();
        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignmentsToAssert.add(new Map<Schema.SObjectField, Object>{
                    PermissionSetAssignment.PermissionSetId => permissionSetId,
                    PermissionSetAssignment.AssigneeId => usersToUnassign.get(i).Id
            });
        }
        ((fflib_ISObjectUnitOfWork)mocks.verify(unitOfWorkMock)).registerDeleted(fflib_Match.sObjectsWith(permissionSetAssignmentsToAssert, false));

        // all user package licenses should be deleted
        List<Map<Schema.SObjectField, Object>> userPackageLicensesToAssert = new List<Map<SObjectField, Object>>();
        for (Integer i = 0; i < 5; i++) {
            userPackageLicensesToAssert.add(new Map<Schema.SObjectField, Object>{
                    UserPackageLicense.PackageLicenseId => LicenseManagementServiceImpl.packageLicense.id,
                    UserPackageLicense.UserId => usersToUnassign.get(i).Id
            });
        }
        ((fflib_ISObjectUnitOfWork)mocks.verify(unitOfWorkMock)).registerDeleted(fflib_Match.sObjectsWith(userPackageLicensesToAssert, false));

        // unit of work commit work should be called
        ((fflib_ISObjectUnitOfWork)mocks.verify(unitOfWorkMock)).commitWork();


    }

    @IsTest
    static void testUnassignLicenseTypeUsersNotAssigned() {
        // the users to remove do not have a license type assigned to them but do have package licenses

        // given
        // a fake packagelicense with 10 used licenses
        List<PackageLicenseWrapper> packageLicenseWrappers = new List<PackageLicenseWrapper>{
                new PackageLicenseWrapper(fflib_IDGenerator.generate(PackageLicense.SObjectType), 10, 10, LicenseManagementServiceImpl.NAMESPACE_PREFIX)
        };

        // 10 users without license assignments
        User[] users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        List<UserPackageLicense> userPackageLicenses = new List<UserPackageLicense>();
        for (Integer i = 0; i < 10; i++) {
            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = packageLicenseWrappers.get(0).Id, UserId = users.get(i).Id));
        }

        // 5 who need to be unassigned
        User[] usersToUnassign = new List<User>();
        List<PermissionSetAssignment> permissionSetAssignmentsToRemove = new List<PermissionSetAssignment>();
        List<UserPackageLicense> userPackageLicensesToRemove = new List<UserPackageLicense>();
        for (Integer i = 0; i < 5; i++) {
            usersToUnassign.add(users.get(i));
            userPackageLicensesToRemove.add(userPackageLicenses.get(i));
        }

        // start stubbing
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IPermissionSetAssignmentSelector  permissionSetAssignmentSelectorMock = (IPermissionSetAssignmentSelector)mocks.mock(IPermissionSetAssignmentSelector.class);
        IPackageLicenseSelector packageLicenseSelectorMock = (IPackageLicenseSelector)mocks.mock(IPackageLicenseSelector.class);
        IUserPackageSelector userPackageSelectorMock = (IUserPackageSelector)mocks.mock(IUserPackageSelector.class);
        IUserSelector userSelectorMock = (IUserSelector)mocks.mock(IUserSelector.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        mocks.startStubbing();
        // sobject types for the selectors (otherwise the mock cannot be found by the Application.Selector factory)
        mocks.when(permissionSetAssignmentSelectorMock.sObjectType()).thenReturn(PermissionSetAssignment.SObjectType);
        mocks.when(packageLicenseSelectorMock.sObjectType()).thenReturn(PackageLicense.SObjectType);
        mocks.when(userPackageSelectorMock.sObjectType()).thenReturn(UserPackageLicense.SObjectType);
        mocks.when(userSelectorMock.sObjectType()).thenReturn(User.SObjectType);

        // ensure the fake package license wrapper is used
        mocks.when(packageLicenseSelectorMock.selectById(null)).thenReturn(packageLicenseWrappers);

        // ensure the right permission set assignments are returned
        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users)).thenReturn(permissionSetAssignments);
        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersToUnassign)).thenReturn(permissionSetAssignmentsToRemove);

        // and the package licenses
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), users)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersToUnassign)).thenReturn(userPackageLicensesToRemove);

        // users
        mocks.when(userSelectorMock.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(userPackageLicensesToRemove);
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
            LicenseManagementService.unassignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersToUnassign);
        } catch (NoSeatAssignedException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    static void testUnassignNoLMALicensesAssigned() {
        // the users to remove do not have a LMA license assigned to them but do have license type licenses assigned

        // given

        // 10 users without license assignments
        User[] users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        List<UserPackageLicense> userPackageLicenses = new List<UserPackageLicense>();
        Id permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id;
        for (Integer i = 0; i < 10; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(Id = fflib_IDGenerator.generate(PermissionSetAssignment.SObjectType), AssigneeId = users.get(i).Id, PermissionSetId = permissionSetId));
//            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = packageLicenseWrappers.get(0).Id, UserId = users.get(i).Id));
        }

        // 5 who need to be unassigned
        User[] usersToUnassign = new List<User>();
        List<PermissionSetAssignment> permissionSetAssignmentsToRemove = new List<PermissionSetAssignment>();
        List<UserPackageLicense> userPackageLicensesToRemove = new List<UserPackageLicense>();
        for (Integer i = 0; i < 5; i++) {
            usersToUnassign.add(users.get(i));
            permissionSetAssignmentsToRemove.add(permissionSetAssignments.get(i));
        }

        // start stubbing
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IPermissionSetAssignmentSelector  permissionSetAssignmentSelectorMock = (IPermissionSetAssignmentSelector)mocks.mock(IPermissionSetAssignmentSelector.class);
        IUserPackageSelector userPackageSelectorMock = (IUserPackageSelector)mocks.mock(IUserPackageSelector.class);
        IUserSelector userSelectorMock = (IUserSelector)mocks.mock(IUserSelector.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        mocks.startStubbing();
        // sobject types for the selectors (otherwise the mock cannot be found by the Application.Selector factory)
        mocks.when(permissionSetAssignmentSelectorMock.sObjectType()).thenReturn(PermissionSetAssignment.SObjectType);
        mocks.when(userPackageSelectorMock.sObjectType()).thenReturn(UserPackageLicense.SObjectType);
        mocks.when(userSelectorMock.sObjectType()).thenReturn(User.SObjectType);

        // ensure the right permission set assignments are returned
        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users)).thenReturn(permissionSetAssignments);
        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersToUnassign)).thenReturn(permissionSetAssignmentsToRemove);

        // and the package licenses
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(LicenseManagementServiceImpl.packageLicense, users)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(LicenseManagementServiceImpl.packageLicense, usersToUnassign)).thenReturn(userPackageLicensesToRemove);

        // users
        mocks.when(userSelectorMock.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(userPackageLicensesToRemove);
        mocks.stopStubbing();

        Application.Selector.setMock(permissionSetAssignmentSelectorMock);
        Application.Selector.setMock(userPackageSelectorMock);
        Application.Selector.setMock(userSelectorMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        LicenseManagementServiceImpl.isTestingLicenseManagement = true;

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            LicenseManagementService.unassignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersToUnassign);
        } catch (NoLMALicenseAssignedException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    public static void testGetAssignedUsersForLicenseTypeHappyFlow() {
        // given
        User[] users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IUserSelector userSelector = (IUserSelector)mocks.mock(IUserSelector.class);

        mocks.startStubbing();
        mocks.when(userSelector.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(users);
        mocks.when(userSelector.sObjectType()).thenReturn(User.SObjectType);
        mocks.stopStubbing();

        Application.Selector.setMock(userSelector);

        // when
        Test.startTest();
        User[] usersToAssess = LicenseManagementService.getAssignedUsersForLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);
        Test.stopTest();

        // then
        System.assertEquals(10, usersToAssess.size());
    }

    @IsTest
    public static void testGetUnAssignedUsersForLicenseTypeHappyFlow() {
        // given
        User[] users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IUserSelector userSelector = (IUserSelector)mocks.mock(IUserSelector.class);

        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering(User.FirstName, fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering(User.LastName, fflib_QueryFactory.SortOrder.ASCENDING, true)
        };

        mocks.startStubbing();
        mocks.when(userSelector.selectUsersAvailableForLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, 0, 100, orderings)).thenReturn(users);
        mocks.when(userSelector.sObjectType()).thenReturn(User.SObjectType);
        mocks.stopStubbing();

        Application.Selector.setMock(userSelector);

        // when
        Test.startTest();
        User[] usersToAssess = LicenseManagementService.getUnAssignedUsersForLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, 0, 100, orderings);
        Test.stopTest();

        // then
        System.assertEquals(10, usersToAssess.size());
    }

    @IsTest
    public static void testGetAssignedUsersForLicenseTypeWithConditionsHappyFlow() {

        // given
        // 10 users
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            User u = TestUtils.getUser('Standard User');
            u.FirstName = 'first' + i;
            u.LastName = 'last' + i;
            u.Id = fflib_IDGenerator.generate(User.SObjectType);
            users.add(u);
        }

        // order on first name and last name
        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering(User.FirstName, fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering(User.LastName, fflib_QueryFactory.SortOrder.ASCENDING, true)
        };

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IUserSelector userSelector = (IUserSelector)mocks.mock(IUserSelector.class);

        mocks.startStubbing();
        mocks.when(userSelector.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, 10, 10, orderings)).thenReturn(users);
        mocks.when(userSelector.sObjectType()).thenReturn(User.SObjectType);
        mocks.stopStubbing();

        Application.Selector.setMock(userSelector);

        // when
        Test.startTest();
        User[] usersToAssess = LicenseManagementService.getAssignedUsersForLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, 10, 10, orderings);
        Test.stopTest();

        // then
        System.assertEquals(10, usersToAssess.size());
    }

    @IsTest
    public static void testGetNumberOfAvailableSeatsSeatsAvailable() {
        // given
        // 10 seats available
        // FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS), 20);
        // 5 seats already assigned
        User[] users = new List<User>();
        for (Integer i = 0; i < 5; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IUserSelector userSelector = (IUserSelector)mocks.mock(IUserSelector.class);

        mocks.startStubbing();
        mocks.when(userSelector.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(users);
        mocks.when(userSelector.sObjectType()).thenReturn(User.SObjectType);
        mocks.stopStubbing();

        Application.Selector.setMock(userSelector);


        // when
        Test.startTest();
        Integer numberOfSeatsAvailable = LicenseManagementService.getNumberOfAvailableSeats(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);
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

//        List<PackageLicenseWrapper> packageLicenseWrappers = new List<PackageLicenseWrapper>{
//                new PackageLicenseWrapper(fflib_IDGenerator.generate(PackageLicense.SObjectType), 5, 10, LicenseManagementServiceImpl.NAMESPACE_PREFIX)
//        };
        // mocks.when(packageLicenseSelectorMock.selectById(null)).thenReturn(packageLicenseWrappers);

        // 10 seats total
        // FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS), 20);

        // 5 new users and 5 existing
        User[] users = new List<User>();
        for (Integer i = 0; i <10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        // the first 5 of them already have a license (LMA and license seat)
        PermissionSetAssignment[] permissionSetAssignments = new List<PermissionSetAssignment>();
        UserPackageLicense[] userPackageLicenses = new List<UserPackageLicense>();
        List<User> usersWithPermissionSet = new List<User>();
        List<User> usersWithoutPermissionSet = new List<User>();
        Id permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id;
        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(Id = fflib_IDGenerator.generate(PermissionSetAssignment.SObjectType), AssigneeId = users.get(i).Id, PermissionSetId = permissionSetId));
            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = LicenseManagementServiceImpl.packageLicense.id, UserId = users.get(i).Id));
            usersWithPermissionSet.add(users.get(i));
            usersWithoutPermissionSet.add(users.get(i+5));
        }
        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users)).thenReturn(permissionSetAssignments);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(LicenseManagementServiceImpl.packageLicense, usersWithPermissionSet)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(LicenseManagementServiceImpl.packageLicense, usersWithoutPermissionSet)).thenReturn(new List<UserPackageLicense>());
        mocks.when(userSelectorMock.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(usersWithPermissionSet);
        mocks.stopStubbing();

        Application.Selector.setMock(permissionSetAssignmentSelectorMock);
        Application.Selector.setMock(packageLicenseSelectorMock);
        Application.Selector.setMock(userPackageSelectorMock);
        Application.Selector.setMock(userSelectorMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        // we want to test the user license assignment
        LicenseManagementServiceImpl.isTestingLicenseManagement = true;
        // when
        Test.startTest();
        LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users);
        Test.stopTest();

        // then

        // we should have 10 new permission set assignments inserted
        List<Map<Schema.SObjectField, Object>> permissionSetAssignmentsToAssert = new List<Map<SObjectField, Object>>();
        for (Integer i = 5; i < 10; i++) {
            permissionSetAssignmentsToAssert.add(new Map<Schema.SObjectField, Object>{
                    PermissionSetAssignment.PermissionSetId => PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id,
                    PermissionSetAssignment.AssigneeId => users.get(i).Id
            });
        }
        ((fflib_ISObjectUnitOfWork)mocks.verify(unitOfWorkMock)).registerNew(fflib_Match.sObjectsWith(permissionSetAssignmentsToAssert, false));

        // and 10 user package licenses
        List<Map<Schema.SObjectField, Object>> userPackageLicensesToAssert = new List<Map<SObjectField, Object>>();
        for (Integer i = 5; i < 10; i++) {
            userPackageLicensesToAssert.add(new Map<Schema.SObjectField, Object>{
                    UserPackageLicense.PackageLicenseId => LicenseManagementServiceImpl.packageLicense.id,
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
        mocks.when(packageLicenseSelectorMock.selectById(null)).thenReturn(packageLicenseWrappers);

        // 10 seats total
        // FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS), 20);

        // 10 new users and 5 existing
        User[] users = new List<User>();
        for (Integer i = 0; i < 15; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        // the first 5 of them already have a license (LMA and license seat)
        PermissionSetAssignment[] permissionSetAssignments = new List<PermissionSetAssignment>();
        UserPackageLicense[] userPackageLicenses = new List<UserPackageLicense>();
        List<User> usersWithPermissionSet = new List<User>();

        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(Id = fflib_IDGenerator.generate(PermissionSetAssignment.SObjectType), AssigneeId = users.get(i).Id, PermissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id));
            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = packageLicenseWrappers.get(0).Id, UserId = users.get(i).Id));
            usersWithPermissionSet.add(users.get(i));
        }

        // but the second 20 do not have an LMA and license seat
        List<User> usersWithoutPermissionSet = new List<User>();
        for (Integer i = 5; i < 10; i++) {
            usersWithoutPermissionSet.add(users.get(i));
        }

        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users)).thenReturn(permissionSetAssignments);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersWithPermissionSet)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(packageLicenseWrappers.get(0), usersWithoutPermissionSet)).thenReturn(new List<UserPackageLicense>());
        mocks.when(userSelectorMock.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(usersWithPermissionSet);
        mocks.stopStubbing();

        Application.Selector.setMock(permissionSetAssignmentSelectorMock);
        Application.Selector.setMock(packageLicenseSelectorMock);
        Application.Selector.setMock(userPackageSelectorMock);
        Application.Selector.setMock(userSelectorMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        LicenseManagementServiceImpl.isTestingLicenseManagement = true;

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users);
        } catch(NotEnoughSeatsAvailableException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        // then

        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    public static void testUserHasNoAccess() {
        // given
        // an existing feature
        Feature feature = Feature.DUTCH_BUSINESS_GET_DOSSIER;
        // a new user
        User user = TestUtils.getUser('Standard User');
        System.runAs(TestUtils.getUser('System Administrator')) {
            insert user;
        }

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        System.runAs(user) {
            try {
                LicenseManagementService.userHasAccess(feature);
            } catch (NoAccessToFeatureException ex) {
                exceptionThrown = true;
            }
        }
        Test.stopTest();

        // then
        // the user should have access to the feature
        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    public static void testUserHasAccess() {
        // given
        // an existing feature
        Feature feature = Feature.DUTCH_BUSINESS_GET_DOSSIER;
        // a new user
        User user = TestUtils.getUser('Standard User');
        System.runAs(TestUtils.getUser('System Administrator')) {
            insert user;
        }
        // with the feature assigned (is part of the given permission set group)
        PermissionSet permissionSet = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);
        PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permissionSet.Id);
        System.runAs(TestUtils.getUser('System Administrator')) {
            insert permissionSetAssignment;
        }

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        System.runAs(user) {
            try {
                LicenseManagementService.userHasAccess(feature);
            } catch (NoAccessToFeatureException ex) {
                exceptionThrown = true;
            }

        }
        Test.stopTest();

        // then
        // the user should have access to the feature
        System.assertEquals(false, exceptionThrown);
    }

    @IsTest
    public static void testAssignLicenseTypeNotEnoughLMASeats() {

        // mock creation
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IPermissionSetAssignmentSelector  permissionSetAssignmentSelectorMock = (IPermissionSetAssignmentSelector)mocks.mock(IPermissionSetAssignmentSelector.class);
        IUserPackageSelector userPackageSelectorMock = (IUserPackageSelector)mocks.mock(IUserPackageSelector.class);
        IUserSelector userSelectorMock = (IUserSelector)mocks.mock(IUserSelector.class);
        fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);

        // given
        // a fake PackageLicense with 10 total seats and 0 available (so there are enough LMA licenses in this test case)
        mocks.startStubbing();
        mocks.when(permissionSetAssignmentSelectorMock.sObjectType()).thenReturn(PermissionSetAssignment.SObjectType);
        mocks.when(userPackageSelectorMock.sObjectType()).thenReturn(UserPackageLicense.SObjectType);
        mocks.when(userSelectorMock.sObjectType()).thenReturn(User.SObjectType);

        // 10 seats total
        // FeatureManagement.setPackageIntegerValue(LicenseManagementServiceImpl.FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS), 30);

        // 5 new users and 5 existing
        User[] users = new List<User>();
        for (Integer i = 0; i <10; i++) {
            users.add(new User(Id = fflib_IDGenerator.generate(User.SObjectType)));
        }

        // the first 10 of them already have a license (LMA and license seat)
        LicenseManagementServiceImpl.packageLicense.usedLicenses = 10;
        LicenseManagementServiceImpl.packageLicense.allowedLicenses = 10;

        PermissionSetAssignment[] permissionSetAssignments = new List<PermissionSetAssignment>();
        UserPackageLicense[] userPackageLicenses = new List<UserPackageLicense>();
        List<User> usersWithPermissionSet = new List<User>();
        Id permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id;

        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(Id = fflib_IDGenerator.generate(PermissionSetAssignment.SObjectType), AssigneeId = users.get(i).Id, PermissionSetId = permissionSetId));
            userPackageLicenses.add(new UserPackageLicense(Id = fflib_IDGenerator.generate(UserPackageLicense.SObjectType), PackageLicenseId = LicenseManagementServiceImpl.packageLicense.id, UserId = users.get(i).Id));
            usersWithPermissionSet.add(users.get(i));
        }

        // but the second 20 do not have an LMA and license seat
        List<User> usersWithoutPermissionSet = new List<User>();
        for (Integer i = 5; i < 10; i++) {
            usersWithoutPermissionSet.add(users.get(i));
        }

        mocks.when(permissionSetAssignmentSelectorMock.selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users)).thenReturn(permissionSetAssignments);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(LicenseManagementServiceImpl.packageLicense, usersWithPermissionSet)).thenReturn(userPackageLicenses);
        mocks.when(userPackageSelectorMock.selectByPackageLicenseAndUsers(LicenseManagementServiceImpl.packageLicense, usersWithoutPermissionSet)).thenReturn(new List<UserPackageLicense>());
        mocks.when(userSelectorMock.selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS)).thenReturn(usersWithPermissionSet);
        mocks.stopStubbing();

        Application.Selector.setMock(permissionSetAssignmentSelectorMock);
        Application.Selector.setMock(userPackageSelectorMock);
        Application.Selector.setMock(userSelectorMock);
        Application.UnitOfWork.setMock(unitOfWorkMock);

        LicenseManagementServiceImpl.isTestingLicenseManagement = true;

        // when
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users);
        } catch(NotEnoughLMALicensesException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        // then

        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    public static void testGetAllowedLicenseKeys() {
        // given
        LicenseType licenseType = LicenseType.COMPANY_INFO_API_USER;

        // when
        Test.startTest();
        Set<String> licenseKeys = LicenseManagementService.getAllowedLicenseDefinitionKeysForLicenseType(licenseType);
        Test.stopTest();

        // then
        System.assertEquals(6, licenseKeys.size());
    }

    @IsTest
    public static void testSelectAvailableUsersForDutchBusinessLicenseType() {
        // given

        // the license type to test
        LicenseType licenseType = LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS;

        // the current users (users are kind of metadata so you will get users created outside of your test in your result)
        Id permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(licenseType).Id;
        Integer currentNrOfUsers = ([SELECT Id FROM User WHERE
        Profile.UserLicense.LicenseDefinitionKey IN :LicenseManagementService.getAllowedLicenseDefinitionKeysForLicenseType(licenseType)
        AND Id NOT IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :permissionSetId)]).size();

        // users
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            User u = TestUtils.getUser('Standard User'); // the Dutch business user can have this profile
            u.FirstName = 'first' + i;
            u.LastName = 'last' + i;
            users.add(u);
        }
        insert users;

        // 5 of the users have the perm set, the rest does not.
        // work with true assigning

        List<User> usersWithLicenseType = new List<User>();
        for (Integer i = 0; i < 5; i++) {
            usersWithLicenseType.add(users.get(i));
        }
        LicenseManagementService.assignLicenseType(licenseType, usersWithLicenseType);

        // when
        Test.startTest();
        // order on first name and last name
        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering(User.FirstName, fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering(User.LastName, fflib_QueryFactory.SortOrder.ASCENDING, true)
        };
        List<User> usersToAssert = LicenseManagementService.getUnAssignedUsersForLicenseType(licenseType, 0, 100, orderings);
        Test.stopTest();

        // then
        System.assertEquals(currentNrOfUsers + 5, usersToAssert.size());

    }
}