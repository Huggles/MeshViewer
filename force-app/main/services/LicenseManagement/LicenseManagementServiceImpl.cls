/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public with sharing class LicenseManagementServiceImpl implements ILicenseManagementService {

    private static final String NAMESPACE_PREFIX ='appsolutely';

    private static final Map<LicenseType, String> PERMISSION_GROUPS_BY_LICENSE_TYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_BUSINESS => 'Companyinfo_for_Business'
    };

    private static final Map<LicenseType, String> FEATURE_PARAM_NAMES_BY_LICENSETYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_BUSINESS => 'CompanyInfoForBusinessNrOfSeats'
    };

    private static PackageLicense packageLicense {
        get {
            if (packageLicense == null) {
                packageLicense = [SELECT Id, UsedLicenses, AllowedLicenses FROM PackageLicense WHERE NamespacePrefix = :NAMESPACE_PREFIX];
            }
            return packageLicense;
        }
        set;
    }

    private static Map<LicenseType, Id> permissionGroupIdsByLicenseTypes = new Map<LicenseType, Id>();

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType) {
        return UserSelector.newInstance().selectByPermissionSetGroup(PERMISSION_GROUPS_BY_LICENSE_TYPE.get(licenseType));
    }

    public void unassignLicenseType(LicenseType licenseType, User[] users) {
        // delete all relevant permission set assignments
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        Map<Id, User> usersByIds = new Map<Id, User>(users);
        PermissionSetAssignment[] permissionSetAssignments = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetGroupId = :getPermissionSetGroupIdForLicenseType(licenseType) AND AssigneeId IN :usersByIds.keySet()];
        unitOfWork.registerDeleted(permissionSetAssignments);
        // check if the user has other license types assigned
        Set<LicenseType> otherLicenseTypes = PERMISSION_GROUPS_BY_LICENSE_TYPE.keySet();
        otherLicenseTypes.remove(licenseType);
        for (LicenseType licenseType2 : otherLicenseTypes) {
            if (users.size() > 0) {
                users = filterUsersWithoutLicenseTypeAssignment(licenseType2, users);
            } else {
                break;
            }
        }

        // if no other license types, remove the LMA license
        usersByIds = new Map<Id, User>(users);
        UserPackageLicense[] userPackageLicenses = [SELECT Id FROM UserPackageLicense WHERE PackageLicenseId = :packageLicense.Id AND UserId IN :usersByIds.keySet()];
        unitOfWork.registerDeleted(userPackageLicenses);

        unitOfWork.commitWork();
    }

    public void assignLicenseType(LicenseType licenseType, User[] users) {
        // calculate if we have enough seats available
        users = filterUsersWithoutLicenseTypeAssignment(licenseType, users);
        if (users.size() > getNumberOfAvailableSeats(licenseType)) {
            throw new NotEnoughSeatsAvailableException('Not enough seats of license type ' + licenseType.name() + ' available');
        }
        // calculate if we have enough LMA licenses available
        User[] usersWithoutLMALicense = filterUsersWithoutLMALicense(users);
        if (usersWithoutLMALicense.size() > getNumberOfUnassignedLMALicenses()) {
            throw new NotEnoughLMALicensesException('Not enough LMA licenses available');
        }

        // assign the user a LMA license if he doesn't have one
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        UserPackageLicense[] userPackageLicenses = new List<UserPackageLicense>();
        for (User user : usersWithoutLMALicense) {
            userPackageLicenses.add(new UserPackageLicense(UserId = user.Id, PackageLicenseId = packageLicense.Id));
        }
        unitOfWork.registerNew(userPackageLicenses);
        // assign the permission set group
        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
        for (User user : users) {
            assignments.add(new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetGroupId = getPermissionSetGroupIdForLicenseType(licenseType)));
        }
        unitOfWork.registerNew(assignments);
        unitOfWork.commitWork();
    }

    public Integer getNumberOfAvailableSeats(LicenseType licenseType) {
        Integer numberOfSeatsBought = FeatureManagement.checkPackageIntegerValue(FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(licenseType));
        Integer numberOfSeatsAssigned = getAssignedUsersForLicenseType(licenseType).size();
        Integer numberOfAvailableSeats = numberOfSeatsBought - numberOfSeatsAssigned;
        return numberOfAvailableSeats;
    }

    /*****************************************
     * IMPLEMENTATION METHODS AFTER THIS POINT
    ******************************************/

    private Integer getNumberOfUnassignedLMALicenses() {
        Integer numberOfSeatsBought = packageLicense.AllowedLicenses;
        Integer numberOfSeatsAssigned = packageLicense.UsedLicenses;
        Integer numberOfAvailableSeats = numberOfSeatsBought - numberOfSeatsAssigned;
        return numberOfAvailableSeats;
    }

    private User[] filterUsersWithoutLicenseTypeAssignment(LicenseType licenseType, User[] users) {
        // get all the users who already have a License Type assigned
        Map<Id, User> usersByIds = new Map<Id, User>(users); // trick to quickly create a set from Ids
        PermissionSetAssignment[] permissionSetAssignments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN :usersByIds.keySet() AND PermissionSetGroupId = :getPermissionSetGroupIdForLicenseType(licenseType)];
        Set<Id> userIdsWithLicenseTypeAssignment = new Set<Id>();
        for (PermissionSetAssignment permissionSetAssignment : permissionSetAssignments) {
            userIdsWithLicenseTypeAssignment.add(permissionSetAssignment.AssigneeId);
        }
        // filter the users who don't have a license type assigned
        List<User> usersWithoutLicenseTypeAssigned = new List<User>();
        for (User user : users) {
            if(!userIdsWithLicenseTypeAssignment.contains(user.Id)) {
                usersWithoutLicenseTypeAssigned.add(user);
            }
        }
        return usersWithoutLicenseTypeAssigned;
    }


    private User[] filterUsersWithoutLMALicense(User[] users) {
        // get all the users who already have a LMA license assigned
        Map<Id, User> usersByIds = new Map<Id, User>(users); // trick to quickly create a set from Ids
        UserPackageLicense[] userPackageLicenses = [SELECT Id, UserId FROM UserPackageLicense WHERE PackageLicenseId = :packageLicense.Id AND UserId IN :usersByIds.keySet()];
        Set<Id> userIdsWithLMA = new Set<Id>();
        for (UserPackageLicense userPackageLicense : userPackageLicenses) {
            userIdsWithLMA.add(userPackageLicense.UserId);
        }
        // filter the users who don't have a license assigned
        List<User> usersWithoutLMA = new List<User>();
        for (User user : users) {
            if (!userIdsWithLMA.contains(user.Id)) {
                usersWithoutLMA.add(user);
            }
        }
        return usersWithoutLMA;
    }

    private Id getPermissionSetGroupIdForLicenseType(LicenseType licenseType) {
        Id permissionSetGroupId = permissionGroupIdsByLicenseTypes.get(licenseType);
        if (permissionSetGroupId == null) {
            PermissionSetGroup permissionSetGroup = [SELECT Id FROM PermissionSetGroup WHERE DeveloperName = :PERMISSION_GROUPS_BY_LICENSE_TYPE.get(licenseType) LIMIT 1];
            if (permissionSetGroup == null) {
                throw new CCInputException('License type without permission set group');
            }
            permissionSetGroupId = permissionSetGroup.Id;
            permissionGroupIdsByLicenseTypes.put(licenseType, permissionSetGroupId);
        }
        return permissionSetGroupId;
    }


}