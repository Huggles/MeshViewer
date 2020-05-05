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


}