/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public interface IUserSelector extends fflib_ISObjectSelector {

    /**
     * Selects users that have the given permission set group assigned. Runs in system mode since this is used by the system admin
     *
     * @param permissionSetGroup the permission set group
     * @return the users who have the permission set group assigned to them
    */
    List<User> selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup);
}