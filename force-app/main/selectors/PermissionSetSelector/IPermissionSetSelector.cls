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
    PermissionSet[] selectLicenseTypePermissionSetsExcludingLicenseType(LicenseType licenseType);

    /**
     * Gets all permission sets related to all license types
     * @return all permission sets that are related to the license types
     */
    PermissionSet[] selectAllLicenseTypePermissionSets();

    /**
     * Returns all permission sets that contain all of the given custom permissions
     * @param customPermissions the custom permissions
     *
     * @return the permission sets that contain all of the given custom permissions
     */
    PermissionSet[] selectPermissionSetsByCustomPermission(List<CustomPermission> customPermissions);


}