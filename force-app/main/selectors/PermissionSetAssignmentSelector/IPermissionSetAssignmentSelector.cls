/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public interface IPermissionSetAssignmentSelector {

    /**
     * Selects all permission set assignments for the given permission set group and users.
     * @param permissionSetGroup the permission set group to search for
     * @param users the users to search for
     * @return the found permission set assignments
    */
    PermissionSetAssignment[] selectByPermissionSetGroupAndUsers(PermissionSetGroup permissionSetGroup, List<User> users);

}