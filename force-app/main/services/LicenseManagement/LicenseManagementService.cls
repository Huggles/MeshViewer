/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public with sharing class LicenseManagementService {

    public static User[] getAssignedUsersForLicenseType(LicenseType licenseType) {
        return newInstance().getAssignedUsersForLicenseType(licenseType);
    }

    public static User[] getAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return newInstance().getAssignedUsersForLicenseType(licenseType, offSet, nrOfRows, ordering);
    }

    public static void unassignLicenseType(LicenseType licenseType, User[] users) {
        newInstance().unassignLicenseType(licenseType, users);
    }

    public static void assignLicenseType(LicenseType licenseType, User[] users) {
        newInstance().assignLicenseType(licenseType, users);
    }

    public static Integer getNumberOfAvailableSeats(LicenseType licenseType) {
        return newInstance().getNumberOfAvailableSeats(licenseType);
    }

    public static LicenseType getLicenseTypeByName(String name) {
        return newInstance().getLicenseTypeByName(name);
    }

    public static String getLicenseTypeName(LicenseType licenseType) {
        return newInstance().getLicenseTypeName(licenseType);
    }

    public static Integer getTotalNumberOfSeats(LicenseType licenseType) {
        return newInstance().getTotalNumberOfSeats(licenseType);
    }

    public static ILicenseManagementService newInstance() {
        return (ILicenseManagementService)Application.Service.newInstance(ILicenseManagementService.class);
    }

}