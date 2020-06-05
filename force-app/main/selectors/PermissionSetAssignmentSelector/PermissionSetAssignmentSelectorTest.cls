/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

@IsTest
private class PermissionSetAssignmentSelectorTest {

    /***
     * ONLY REMOVED BECAUSE OF PACKAGING ISSUES
    */

    @IsTest
    static void testSelectByLicenseTypeAndUsersHappyFlow() {
        // given
        // 15 users
        // 5 with the license permission set we search for, 5 with another and 5 without
        List<User> users = new List<User>();
        for (Integer i = 0; i < 15; i++) {
            users.add(TestUtils.getUser('Standard User'));
        }
        insert users;

        Id permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id;

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        for (Integer i = 0; i < 5; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId = users.get(i).Id, PermissionSetId = permissionSetId));
        }

        permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_INTERNATIONAL_BUSINESS).Id;
        for (Integer i = 5; i < 10; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId = users.get(i).Id, PermissionSetId = permissionSetId));
        }
        insert permissionSetAssignments;

        // when
        Test.startTest();
        PermissionSetAssignment[] permissionSetAssignments2 = PermissionSetAssignmentSelector.newInstance().selectByLicenseTypeAndUsers(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, users);

        Test.stopTest();

        // then
        System.assertEquals(5, permissionSetAssignments2.size());
    }

    @IsTest
    static void testSelectByLicenseSetGroupWithConditions() {
        // given
        // 100 users
        // 95 with an assignment and 5 without
        List<User> users = new List<User>();
        for (Integer i = 100; i > 0; i--) {
            User u = TestUtils.getUser('Standard User');
            u.FirstName = 'first' + i;
            u.LastName = 'last' + i;
            users.add(u);
        }
        insert users;

        Id permissionSetId = PermissionSetSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS).Id;

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        for (Integer i = 0; i < 95; i++) {
            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId = users.get(i).Id, PermissionSetId = permissionSetId));
        }
        insert permissionSetAssignments;

        // order on first name and last name
        List<fflib_QueryFactory.Ordering> orderings = new List<fflib_QueryFactory.Ordering>{
                new fflib_QueryFactory.Ordering('Assignee.FirstName', fflib_QueryFactory.SortOrder.ASCENDING, true),
                new fflib_QueryFactory.Ordering('Assignee.LastName', fflib_QueryFactory.SortOrder.ASCENDING, true)
        };

        // when
        Test.startTest();
        PermissionSetAssignment[] permissionSetAssignments2 = PermissionSetAssignmentSelector.newInstance().selectByLicenseType(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS, 10, 10, orderings);

        Test.stopTest();

        // then
        System.assertEquals(10, permissionSetAssignments2.size());
        Set<Id> userIds = (new Map<Id, User>(users)).keySet();
        for (Integer i = 0; i < 10; i++) {
            System.assertEquals(true, userIds.contains(permissionSetAssignments2.get(i).AssigneeId));
        }
    }


}