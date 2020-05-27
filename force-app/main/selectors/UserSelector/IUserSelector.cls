/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public interface IUserSelector extends fflib_ISObjectSelector {

    /**
     * Selects users that have a seat of the given license type assigned to them. Runs in system mode since this is used by the system admin
     *
     * @param licenseType the licensetype for which we search the users
     * @return the users who have the permission set belonging to the license type assigned to them
    */
    List<User> selectByLicenseType(LicenseType licenseType);

    /**
     * Selects users that have a seat of the given license type assigned to them. Returns them ordered and only the requested rows
     *
     * @param licenseType the licensetype for which we search the users
     * @param offSet the offset. Maximum of 2000 (limit Salesforce)
     * @param nrOfRows the number of rows to retrieve
     * @param ordering the ordering of the result set. By manipulating the ordering, it is possible to go around the offset limitation. See https://help.salesforce.com/articleView?id=000339353&type=1&mode=1
     * @return the users who have the permission set belonging to the license type assigned to them and adhere to the rest of the search criteria
     */
    List<User> selectByLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     * Selects users that do not have a seat of the given license type assigned to them. Returns them ordered and only the requested rows
     *
     * @param licenseType the licensetype for which we search the users
     * @param offSet the offset. Maximum of 2000 (limit Salesforce)
     * @param nrOfRows the number of rows to retrieve
     * @param ordering the ordering of the result set. By manipulating the ordering, it is possible to go around the offset limitation. See https://help.salesforce.com/articleView?id=000339353&type=1&mode=1
     * @return the users who do not have the permission set belonging to the license type assigned to them and adhere to the rest of the search criteria
     */
    List<User> selectUsersWithoutLicenseTypeSeat(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

}