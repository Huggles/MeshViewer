/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

/**
 * Services to assign and remove licenses
*/
public interface ILicenseManagementService {

    /**
     * Returns a list of users who have the given license type assigned.
     *
     * @param licenseType the name of the license type to check
     * @return the users who have the license type assigned
    */
    User[] getAssignedUsersForLicenseType(LicenseType licenseType);

    /**
     * Returns a list of users who have the given license type assigned.
     *
     * @param licenseType the name of the license type to check
     * @param offSet from which row number onwards to fetch the data
     * @return the users who have the license type assigned
    */
    User[] getAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     * Returns a list of users who have not been assigned the license type and not to another license type.
     *
     * @param licenseType the name of the license type to check
     * @param offSet from which row number onwards to fetch the data
     * @return the users who have don't have the license type assigned
    */
    User[] getUnAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     * Returns a list of all users who have not been assigned a seat at all
     *
     * @param licenseType the name of the license type to check
     * @param offSet from which row number onwards to fetch the data
     * @return the users who have don't have a seat
    */
    User[] getUsersWithoutSeat(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering);

    /**
     * Returns the total number of users that do not have the license type given assigned
     * @param licenseType the license type for which we want to get the number of unassigned users
     * @return the number of unassigned users
    */
    Integer getUnAssignedUsersForLicenseTypeCount(LicenseType licenseType);

    /**
     *  Unassigns the given license type of the given users. If the license type is not assigned to the user, fails silently.
     *
     *  @param licenseType the name of the license type
     *  @param users the list of users to remove the license type assignment from
    */
    void unassignLicenseType(LicenseType licenseType, User[] users);

    /**
     * Assigns the given license type to the given users.
     *
     * @param licenseType the name of the license type
     * @param users the list of users to assign the license type to
    */
    void assignLicenseType(LicenseType licenseType, User[] users);

    /**
     * Returns the number of seats still available for the given license type
     *
     * @param licenseType the License Type for which the number of available seats should be determined
     * @return the number of available seats
    */
    Integer getNumberOfAvailableSeats(LicenseType licenseType);

    /**
     * Fetches the right LicenseType enum by its API name
    */
    LicenseType getLicenseTypeByName(String name);

    /**
     * Fetches the name/title of the license type given. This is the human readable name and not the API name. Can be used in the UI.
     * @param licenseType the license type for which we want the title
     * @return the title/name of the License Type
    */
    String getLicenseTypename(LicenseType licenseType);

    /**
     * Fetches the total number of seats available for this license type in the subscriber org.
     * @param licenseType the license type for which we want to know the total number of seats
     * @return the total number of seats for this License type
    */
    Integer getTotalNumberOfSeats(LicenseType licenseType);

    /**
     * Checks if the current user has access to the given feature. Throws
     * @param feature the feature to check
     * @return true if the user has access otherwise false
     */
    Boolean userHasAccess(Feature feature);

    /**
     * Returns the allowed Salesforce License Definition Key
     * (see https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_userlicense.htm)
     * for the given Licensetype. Only to users with these Salesforce Licenses a seat of the given Company.info license type can be assigned.
     * @param licenseType the licensetype for which the user wants to retrieve the allowed Salesforce License Definition Keys
     *
     * @return a Set of the allowed Salesforce License Definition Keys
     */
    Set<String> getAllowedLicenseDefinitionKeysForLicenseType(LicenseType licenseType);

    /**
     * Returns a set of profile ids for which it is allowed to assign the license type
     * @param licenseType the license type for which we want to find the set of allowed profile ids
     *
     * @return a set of profile ids to which the given license type can be assigned
     */
    Set<Id> getAllowedProfileIdsForLicenseType(LicenseType licenseType);




}