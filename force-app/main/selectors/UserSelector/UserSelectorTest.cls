/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

@IsTest
private class UserSelectorTest {

    @IsTest
    static void testSelectByPermissionSetGroupHappyFlow() {
        // given
        // 5 users without a permission set group and 5 with
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(TestUtils.getUser('Standard User'));
        }
        System.runAs(TestUtils.getUser('System Administrator')) {
            insert users;
        }
        for (Integer i = 0; i < 5; i++) {
            TestUtils.giveUserPermissionSetGroup('Companyinfo_for_Business', users[i]);
        }
        PermissionSetGroup permissionSetGroup = LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS);

        // when

        Test.startTest();
        User[] usersToAssert = UserSelector.newInstance().selectByPermissionSetGroup(permissionSetGroup);
        Test.stopTest();

        // then
        System.assertEquals(5, usersToAssert.size());
        System.assert(usersToAssert[0].Profile.Name == 'Standard User');

    }

    @IsTest
    static void testSelectByPermissionSetGroupWithConditions() {
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

        PermissionSetGroup permissionSetGroup = LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS);

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        for (Integer i = 0; i < 95; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId = users.get(i).Id, PermissionSetGroupId = permissionSetGroup.Id));
        }
        insert permissionSetAssignments;

        // order on first name and last name
        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering(User.FirstName, fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering(User.LastName, fflib_QueryFactory.SortOrder.ASCENDING, true)
        };

        // when
        Test.startTest();
        User[] usersToAssert = UserSelector.newInstance().selectByPermissionSetGroup(permissionSetGroup, 10, 10, orderings);
        Test.stopTest();

        // then
        System.assertEquals(10, usersToAssert.size());
        for (Integer i = 0; i < 10; i++) {
            System.assertEquals('first' + (10 + i), usersToAssert.get(i).FirstName);
            System.assertEquals('last' + (10 + i), usersToAssert.get(i).LastName);
        }
    }
}