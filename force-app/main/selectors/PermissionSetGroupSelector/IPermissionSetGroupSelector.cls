/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public interface IPermissionSetGroupSelector {

    /**
     * Returns the permission set group with the given developer name
     * @param developerName the developer name of the sought for permission set group
     * @return the permission set group found (in a list) or an empty list if none was found
    */
    PermissionSetGroup[] selectByDeveloperName(String developerName);

}