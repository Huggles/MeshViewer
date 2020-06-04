/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

@IsTest
private class UserSelectorTest {

    @IsTest
    static void testselectByLicenseTypeHappyFlow() {
        // given
        // 5 users without a license type seat and 5 with
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(TestUtils.getUser('Standard User'));
        }
        System.runAs(TestUtils.getUser('System Administrator')) {
            insert users;
        }
        List<User> usersWithLicenseType = new List<User>();
        for (Integer i = 0; i < 5; i++) {
            usersWithLicenseType.add(users.get(i));
        }
        LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersWithLicenseType);

        // when
        Test.startTest();
        User[] usersToAssert = UserSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);
        Test.stopTest();

        // then
        System.assertEquals(5, usersToAssert.size());
        System.assert(usersToAssert[0].Profile.Name == 'Standard User');

    }

    @IsTest
    static void testSelectUsersWithoutLicenseTypeGroupHappyFlow() {
        // given
        // 5 users without a permission set group and 5 with
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(TestUtils.getUser('Standard User'));
        }
        System.runAs(TestUtils.getUser('System Administrator')) {
            insert users;
        }
        List<User> usersWithLicenseType = new List<User>();
        for (Integer i = 0; i < 4; i++) {
            usersWithLicenseType.add(users.get(i));
        }
        LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersWithLicenseType);

        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);

        System.assertEquals(4, permissionSetAssignments.size());

        // order on first name and last name
        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering(User.FirstName, fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering(User.LastName, fflib_QueryFactory.SortOrder.ASCENDING, true)
        };

        // when

        Test.startTest();
        System.assertEquals(4, PermissionSetAssignmentSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).size());
        User[] usersToAssert = UserSelector.newInstance().selectUsersWithoutLicenseTypeSeat(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, 0, 30, orderings);
        Test.stopTest();
        // then
        Integer currentNrOfUsers = ([SELECT Id FROM User WHERE Profile.UserLicense.LicenseDefinitionKey IN :LicenseManagementServiceImpl.ALLOWED_LICENCE_DEFINITION_KEYS]).size(); // the user object is strange since it doesn't respect the test boundary (acts like SeeAllData is true)
        System.assertEquals(currentNrOfUsers - 4, usersToAssert.size());

    }

    @IsTest
    static void testSelectByLicenseTypeWithConditions() {
        // given
        // 100 users
        // 95 with a permission set group assignment and 5 without
        List<User> users = new List<User>();
        for (Integer i = 0; i < 100; i++) {
            User u = TestUtils.getUser('Standard User');
            u.FirstName = 'first' + i;
            u.LastName = 'last' + i;
            users.add(u);
        }
        insert users;

        List<User> usersWithLicenseType = new List<User>();
        for (Integer i = 0; i < 95; i++) {
            usersWithLicenseType.add(users.get(i));
        }
        // cannot assign users for real because the default number of seats available is 10 and this will throw exceptions
        // LicenseManagementService.assignLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, usersWithLicenseType);

        // alternative: just assign the right permissions
        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        Id permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id;
        for (User user : usersWithLicenseType) {
            permissionSetAssignments.add(new PermissionSetAssignment(PermissionSetId = permissionSetId, AssigneeId = user.Id));
        }
        insert permissionSetAssignments;

        // when
        Test.startTest();
        // order on first name and last name
        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering(User.FirstName, fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering(User.LastName, fflib_QueryFactory.SortOrder.ASCENDING, true)
        };

        User[] usersToAssert = UserSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, 10, 10, orderings);
        Test.stopTest();

        // then
        System.assertEquals(10, usersToAssert.size());
        for (Integer i = 0; i < 10; i++) {
            System.assertEquals('Standard User', usersToAssert.get(i).Profile.Name);
        }
    }

    @IsTest
    public static void testSelectUsersWithoutSeat() {
        // given

        // users
        List<PermissionSet> permissionSets = new List<PermissionSet>();
        permissionSets = PermissionSetSelector.newInstance().selectAllLicenseTypePermissionSets();
        Set<Id> permissionSetIds = (new Map<Id, PermissionSet>(permissionSets)).keySet();
        Integer currentNrOfUsers = ([SELECT Id FROM User WHERE
            Profile.UserLicense.LicenseDefinitionKey IN :LicenseManagementServiceImpl.ALLOWED_LICENCE_DEFINITION_KEYS
            AND Id NOT IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId IN :permissionSetIds)]).size();

        List<User> users = new List<User>();
        for (Integer i = 0; i < 10 * permissionSets.size(); i++) {
            User u = TestUtils.getUser('Standard User');
            u.FirstName = 'first' + i;
            u.LastName = 'last' + i;
            users.add(u);
        }
        insert users;

        // assign the permissionsets
        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        Integer userCounter = 0;
        for (PermissionSet permissionSet : permissionSets) {
            List<User> usersWithLicenseType = new List<User>();
            for (Integer i = userCounter * 5; i < (userCounter * 5 + 5); i++) {
                usersWithLicenseType.add(users.get(i));
            }
            Id permissionSetId = permissionSet.Id;
            for (User user : usersWithLicenseType) {
                permissionSetAssignments.add(new PermissionSetAssignment(PermissionSetId = permissionSetId, AssigneeId = user.Id));
            }
            userCounter++;
        }
        insert permissionSetAssignments;


        // when
        Test.startTest();
        // order on first name and last name
        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering(User.FirstName, fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering(User.LastName, fflib_QueryFactory.SortOrder.ASCENDING, true)
        };
        User[] usersToAssert = UserSelector.newInstance().selectUsersWithoutSeat(0, permissionSets.size() * 10, orderings);
        for (User user : usersToAssert) {
            System.debug('Profile: ' + user.Profile.Name);
        }
        Test.stopTest();

        // then

        System.assertEquals(currentNrOfUsers + permissionSets.size() * 5, usersToAssert.size());
    }

}