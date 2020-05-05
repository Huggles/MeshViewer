/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public with sharing class LicenseManagementService {

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType) {
        return newInstance().getAssignedUsersForLicenseType(licenseType);
    }

    public void unassignLicenseType(LicenseType licenseType, User[] users) {
        newInstance().unassignLicenseType(licenseType, users);
    }

    public void assignLicenseType(LicenseType licenseType, User[] users) {
        newInstance().assignLicenseType(licenseType, users);
    }

    public Integer getNumberOfAvailableSeats(LicenseType licenseType) {
        return newInstance().getNumberOfAvailableSeats(licenseType);
    }

    public static ILicenseManagementService newInstance() {
        return (ILicenseManagementService)Application.Service.newInstance(ILicenseManagementService.class);
    }

}