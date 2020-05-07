/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public interface IPermissionSetAssignmentSelector extends fflib_ISObjectSelector {

    /**
     * Selects all permission set assignments for the given permission set group and users.
     * @param permissionSetGroup the permission set group to search for
     * @param users the users to search for
     * @return the found permission set assignments
    */
    PermissionSetAssignment[] selectByPermissionSetGroupAndUsers(PermissionSetGroup permissionSetGroup, List<User> users);

    /**
     * Selects all permission set assignments for the given permission set group
     * @param permissionSetGroup the permission set group to search the assignments for
     * @return the permission set assignments related to the permission set group
    */
    PermissionSetAssignment[] selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup);

}