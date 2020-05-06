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

        PermissionSetGroup permissionSetGroup = LicenseManagementServiceImpl.getPermissionSetGroupForLicenseType(LicenseType.COMPANY_INFO_FOR_BUSINESS);

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
}