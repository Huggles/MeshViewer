/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

@IsTest
private class PermissionSetAssignmentSelectorTest {
    @IsTest
    static void testSelectByPermissionSetGroupAndUsers() {
        // given
        // 10 users
        // 5 with a permission set group assignment and 5 without
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(TestUtils.getUser('Standard User'));
        }
        insert users;

        PermissionSetGroup permissionSetGroup = LicenseManagementService.getPermissionSetGroupByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId = users.get(i).Id, PermissionSetGroupId = permissionSetGroup.Id));
        }
        insert permissionSetAssignments;

        // when
        Test.startTest();
        PermissionSetAssignment[] permissionSetAssignments2 = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroupAndUsers(permissionSetGroup, users);

        Test.stopTest();

        // then
        System.assertEquals(5, permissionSetAssignments2.size());

    }

    @IsTest
    static void testSelectByPermissionSetGroup() {

        // given
        // 10 users
        // 5 with a permission set group assignment and 5 without
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(TestUtils.getUser('Standard User'));
        }
        insert users;

        PermissionSetGroup permissionSetGroup = LicenseManagementService.getPermissionSetGroupByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);

        // since permission set groups don't stick to the encapsulations of the test context (they act like SeeAllData=true) we need to take into account existing assignments
        Integer nrOfPermissionSetsAssignedBefore = [SELECT Count() FROM PermissionSetAssignment WHERE PermissionSetGroupId = :permissionSetGroup.Id];

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId = users.get(i).Id, PermissionSetGroupId = permissionSetGroup.Id));
        }
        insert permissionSetAssignments;

        // when
        Test.startTest();
        PermissionSetAssignment[] permissionSetAssignments2 = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroup(permissionSetGroup);

        Test.stopTest();

        // then
        System.assertEquals(5 + nrOfPermissionSetsAssignedBefore, permissionSetAssignments2.size());
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

        PermissionSetGroup permissionSetGroup = LicenseManagementService.getPermissionSetGroupByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        for (Integer i = 0; i < 95; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId = users.get(i).Id, PermissionSetGroupId = permissionSetGroup.Id));
        }
        insert permissionSetAssignments;

        // order on first name and last name
        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering('Assignee.FirstName', fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering('Assignee.LastName', fflib_QueryFactory.SortOrder.ASCENDING, true)
        };

        // when
        Test.startTest();
        PermissionSetAssignment[] permissionSetAssignments2 = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroup(permissionSetGroup, 10, 10, orderings);

        Test.stopTest();

        // then
        System.assertEquals(10, permissionSetAssignments2.size());
        Set<Id> userIds = (new Map<Id, User>(users)).keySet();
        for (Integer i = 0; i < 10; i++) {
            System.assertEquals(true, userIds.contains(permissionSetAssignments2.get(i).AssigneeId));
        }
    }


}