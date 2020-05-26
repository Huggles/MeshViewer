/**
 * Created by jaapbranderhorst on 26/05/2020.
 */

public interface IPermissionSetSelector {

    /**
     * Returns the permission set that gives access to the license type
     * @param licenseType the license type for which we want the permission set
     *
     * @return the permission set related to the license type
     */
    PermissionSet selectByLicenseType(LicenseType licenseType);

    /**
     * Returns all permission sets that have another license type related to them then the given license type
     * @param licenseType the license type for which we don't ;-) want the permission set
     *
     * @return the permission sets that have another license type related to them then the given one
     */
    PermissionSet[] selectPermissionSetsExcludingLicenseType(LicenseType licenseType);

}