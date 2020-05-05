/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public with sharing class LicenseManagementService {

    public User[] getAssignedUsersForLicenseType(String licenseType) {
        return newInstance().getAssignedUsersForLicenseType(licenseType);
    }

    public void unassignLicenseType(String licenseType, User[] users) {
        newInstance().unassignLicenseType(licenseType, users);
    }

    public void assignLicenseType(String licenseType, User[] users) {
        newInstance().assignLicenseType(licenseType, users);
    }

    public static ILicenseManagementService newInstance() {
        return (ILicenseManagementService)Application.Service.newInstance(ILicenseManagementService.class);
    }

}