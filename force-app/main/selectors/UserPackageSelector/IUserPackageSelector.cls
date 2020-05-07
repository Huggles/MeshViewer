/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public interface IUserPackageSelector extends fflib_ISObjectSelector {

    /**
     * Returns all user package licenses assigned to the given user for the given package license
     * @param packageLicense the package license to search for
     * @param users the users to search for
     * @return the user package licenses assigned to the users for this package license
    */
    UserPackageLicense[] selectByPackageLicenseAndUsers(PackageLicense packageLicense, User[] users);

}