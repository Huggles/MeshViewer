/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public with sharing class LicenseManagementServiceImpl implements ILicenseManagementService {

    @TestVisible
    private static final String NAMESPACE_PREFIX ='appsolutely';

    @TestVisible
    private static final Map<LicenseType, String> PERMISSION_GROUPS_BY_LICENSE_TYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_BUSINESS => 'Companyinfo_for_Business'
    };

    @TestVisible
    private static final Map<LicenseType, String> FEATURE_PARAM_NAMES_BY_LICENSETYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_BUSINESS => 'CompanyInfoForBusinessNrOfSeats',
            LicenseType.TEST_NO_FEATURE_PARAM => 'bogus' // TODO: refactor so no test code in implementation code
    };

    /**
     * The title/name definition of the license modules
    */
    @TestVisible
    private static final Map<LicenseType, String> LICENCE_TYPE_NAMES_BY_LICENSETYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_BUSINESS => 'Company.info for Business'
    };

    private static Map<LicenseType, PermissionSetGroup> permissionGroupsByLicenseTypes = new Map<LicenseType, PermissionSetGroup>();

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType) {
        return UserSelector.newInstance().selectByPermissionSetGroup(getPermissionSetGroupForLicenseType(licenseType));
    }

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return UserSelector.newInstance().selectByPermissionSetGroup(getPermissionSetGroupForLicenseType(licenseType), offSet, nrOfRows, ordering);
    }

    public String getLicenseTypeName(LicenseType licenseType) {
        String returnValue = LICENCE_TYPE_NAMES_BY_LICENSETYPE.get(licenseType);
        if (returnValue == null) {
            throw new NoNameDefinedForLicenseTypeException('No name/title defined for ' + LicenseType.name());
        }
        return returnValue;
    }

    public Integer getTotalNumberOfSeats(LicenseType licenseType) {
        String featureParamName = FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(licenseType);
        if (featureParamName == null) {
            throw new NoFeatureParamForLicenseTypeException('No feature parameter name defined for ' + licenseType.name());
        }
        Integer returnValue = null;
        try {
            returnValue = FeatureManagement.checkPackageIntegerValue(featureParamName);
        } catch (NoDataFoundException ex) {
            throw new NoFeatureParamForLicenseTypeException('No feature parameter defined for ' + licenseType.name());
        }
        return returnValue;
    }


    public LicenseType getLicenseTypeByName(String name) {
        LicenseType[] licenseTypes = LicenseType.values();
        LicenseType returnValue = null;
        for (LicenseType licenseType : licenseTypes) {
            if (name == licenseType.name()) {
                returnValue = licenseType;
                break;
            }
        }
        if (returnValue == null) {
            throw new NoSuchLicenseTypeException('No license type with name ' + name);
        }
        return returnValue;
    }


    public void unassignLicenseType(LicenseType licenseType, User[] users) {
        // check if the users have a license and throw an exception if they don't
        List<User> usersWithoutLicenseTypes = filterUsersWithoutLicenseTypeAssignment(licenseType, users);
        if (usersWithoutLicenseTypes.size() > 0) {
            throw new NoSeatAssignedException('No seats of license type ' + licenseType.name() + ' have been assigned to the given users');
        }
        List<User> usersWithoutLMALicense = filterUsersWithoutLMALicense(users);
        if (usersWithoutLMALicense.size() > 0) {
            throw new NoLMALicenseAssignedException('No LMA License has been assigned to the given users');
        }

        // delete all relevant permission set assignments
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroupAndUsers(getPermissionSetGroupForLicenseType(licenseType), users);
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
        // if we are in a scratch org, there is no real packagelicense which is not a problem since this call won't return any userPackageLicenses in that case
        UserPackageLicense[] userPackageLicenses = UserPackageSelector.newInstance().selectByPackageLicenseAndUsers(packageLicense, users);
        unitOfWork.registerDeleted(userPackageLicenses);

        unitOfWork.commitWork();
    }

    public void assignLicenseType(LicenseType licenseType, User[] users) {
        // calculate if we have enough seats available
        users = filterUsersWithoutLicenseTypeAssignment(licenseType, users);
        if (users.size() > getNumberOfAvailableSeats(licenseType)) {
            throw new NotEnoughSeatsAvailableException('Not enough seats of license type ' + licenseType.name() + ' available');
        }

        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();

        if (!isScratchOrg() || Test.isRunningTest()) { // in a scratch org we don't have a package installed so this doesn't work outside a unit test
            // calculate if we have enough LMA licenses available
            User[] usersWithoutLMALicense = filterUsersWithoutLMALicense(users);
            if (usersWithoutLMALicense.size() > getNumberOfUnassignedLMALicenses()) {
                throw new NotEnoughLMALicensesException('Not enough LMA licenses available');
            }
            // assign the user a LMA license if he doesn't have one
            UserPackageLicense[] userPackageLicenses = new List<UserPackageLicense>();
            for (User user : usersWithoutLMALicense) {
                userPackageLicenses.add(new UserPackageLicense(UserId = user.Id, PackageLicenseId = packageLicense.Id));
            }
            unitOfWork.registerNew(userPackageLicenses);
        }

        // assign the permission set group
        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
        for (User user : users) {
            assignments.add(new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetGroupId = getPermissionSetGroupForLicenseType(licenseType).Id));
        }
        unitOfWork.registerNew(assignments);
        unitOfWork.commitWork();
    }

    public Integer getNumberOfAvailableSeats(LicenseType licenseType) {
//        Integer numberOfSeatsBought = 20;
//        if (!isScratchOrg() || Test.isRunningTest()) { // in a scratch org outside a unit test the feature param is not available
        Integer numberOfSeatsBought = FeatureManagement.checkPackageIntegerValue(FEATURE_PARAM_NAMES_BY_LICENSETYPE.get(licenseType));
        // }
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
        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroupAndUsers(getPermissionSetGroupForLicenseType(licenseType), users);
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
        PackageLicenseWrapper pl = packageLicense;
        UserPackageLicense[] userPackageLicenses = UserPackageSelector.newInstance().selectByPackageLicenseAndUsers(pl, users);
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

    private Boolean isScratchOrg() {
        Organization org = [SELECT IsSandbox, TrialExpirationDate FROM Organization];
        Boolean isScratchOrg = org.IsSandbox && org.TrialExpirationDate != null;
        return isScratchOrg;
    }

    @TestVisible
    private static PermissionSetGroup getPermissionSetGroupForLicenseType(LicenseType licenseType) {
        PermissionSetGroup permissionSetGroup = permissionGroupsByLicenseTypes.get(licenseType);
        if (permissionSetGroup == null) {
            PermissionSetGroup[] groups = PermissionSetGroupSelector.newInstance().selectByDeveloperName(PERMISSION_GROUPS_BY_LICENSE_TYPE.get(licenseType));
            if (groups.size() == 0) {
                throw new CCInputException('License type ' + LicenseType.name() + ' without permission set group');
            }
            permissionSetGroup = groups.get(0);
            permissionGroupsByLicenseTypes.put(licenseType, permissionSetGroup);
        }
        return permissionSetGroup;
    }

    private PackageLicenseWrapper packageLicense {
        get {
            if (packageLicense == null) {
                // TODO: we assume there is only one package with this namespace installed. Should be fixed
                List<PackageLicenseWrapper> packageLicenseWrappers = PackageLicenseSelector.newInstance().selectByNamespacePrefix(NAMESPACE_PREFIX);
                if (packageLicenseWrappers.size() == 0) { // we are in a scratch org otherwise we would have had the package license
                    packageLicenseWrappers = new List<PackageLicenseWrapper>{
                            new PackageLicenseWrapper(fflib_IDGenerator.generate(Schema.PackageLicense.SObjectType), 0, 20, LicenseManagementServiceImpl.NAMESPACE_PREFIX)
                    };
                }
                packageLicense = packageLicenseWrappers.get(0);
            }
            return packageLicense;
        }
        set;
    }


}