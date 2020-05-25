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

    /**
     * Selects users that have the given permission set group assigned. Returns them ordered and only the requested rows
     *
     * @param permissionSetGroup the permission set group
     * @param offSet the offset. Maximum of 2000 (limit Salesforce)
     * @param nrOfRows the number of rows to retrieve
     * @param ordering the ordering of the result set. By manipulating the ordering, it is possible to go around the offset limitation. See https://help.salesforce.com/articleView?id=000339353&type=1&mode=1
     * @return the users who have the permission set group assigned to them and adhere to the rest of the search criteria
     */
    List<User> selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     *  Selects users that do not have the given permission set group assigned.
     *
     * @param permissionSetGroup the permission set group
     * @param nrOfRows the number of rows to retrieve
     * @param ordering the ordering of the result set. By manipulating the ordering, it is possible to go around the offset limitation. See https://help.salesforce.com/articleView?id=000339353&type=1&mode=1
     * @return the users who do not have the permission set group assigned to them and adhere to the rest of the search criteria
    */
    List<User> selectUsersWithoutPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     * Selects users that do not have the license type. Returns the users ordered by the given ordering
     *
     * @param licenseType the license type to search for
     * @param offSet the starting row
     * @param nrOfRows the number of users (rows) to retrieve
     * @param orderings the orderings of the returned users
     *
     * @return the users who do not have the license type assigned to them and adhere to the rest of the search criteria
     */
    List<User> selectUsersWithoutLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings);


    /**
     * Selects users that have the license type assigned to them. Returns the users ordered by the given ordering
     *
     * @param licenseType the license type to search for
     * @param offSet the starting row
     * @param nrOfRows the number of users (rows) to retrieve
     * @param orderings the orderings of the returned users
     *
     * @return the users who have the license type assigned to them and adhere to the rest of the search criteria
     */
    List<User> selectByLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     * Selects users that have the license type assigned to them
     *
     * @param licenseType the license type to search for
     *
     * @return the users who have the license type assigned to them
     */
    List<User> selectByLicenseType(LicenseType licenseType);


}