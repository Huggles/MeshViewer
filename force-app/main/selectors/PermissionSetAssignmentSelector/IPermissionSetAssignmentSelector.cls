/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public interface IPermissionSetAssignmentSelector extends fflib_ISObjectSelector {

    /**
     * Selects all permission set assignments that relate the given users with the given license type. If more than 50k permission set assignments exist, this will fail due to governor limits.
     * @param licenseType the license type to search for
     * @param users the users to search for
     * @return the found permission set assignments
    */
    PermissionSetAssignment[] selectByLicenseTypeAndUsers(LicenseType licenseType, List<User> users);

    /**
     * Selects all permission set assignments for the given license type. Returns them ordered according to the given ordering and only the requested rows
     * @param licenseType the license type to search for
     * @param offSet the offset. Maximum of 2000 (limit Salesforce)
     * @param nrOfRows the number of rows to retrieve
     * @param ordering the ordering of the result set. By manipulating the ordering, it is possible to go around the offset limitation. See https://help.salesforce.com/articleView?id=000339353&type=1&mode=1
     * @return the permission set assignments that adhere to the rest of the search criteria
     */
    PermissionSetAssignment[] selectByLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     * Selects all permission set assignments for the given license type. Returns them ordered according to the given ordering and only the requested rows
     * @param licenseType the license type to search for
     * @param offSet the offset. Maximum of 2000 (limit Salesforce)
     * @param nrOfRows the number of rows to retrieve
     * @param ordering the ordering of the result set. By manipulating the ordering, it is possible to go around the offset limitation. See https://help.salesforce.com/articleView?id=000339353&type=1&mode=1
     * @return the permission set assignments that adhere to the rest of the search criteria
     */
    PermissionSetAssignment[] selectExcludingLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     * Selects all permission set assignments for the given license type. If more than 50k permission set assignments exist, this will fail due to governor limits.
     * @param licenseType the license type to search for
     *
     * @return the permission set assignments for the license type
     */
    PermissionSetAssignment[] selectByLicenseType(LicenseType licenseType);


}