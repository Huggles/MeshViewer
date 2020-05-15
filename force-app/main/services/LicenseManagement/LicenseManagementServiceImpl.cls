/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public with sharing class LicenseManagementServiceImpl implements ILicenseManagementService {

    /**
     * The list of Salesforce license definition keys that can be used to provision a license type to
    */
    public static final Set<String> ALLOWED_LICENCE_DEFINITION_KEYS = new Set<String>{
            'SFDC',
            'PID_COMPANY_COMMUNITIES',
            'AUL',
            'PID_Customer_Community_Login',
            'PID_Customer_Community_Plus',
            'FDC_SUB',
            'PID_Customer_Community_Plus_Login',
            'FDC_ISV_SUB',
            'PID_Partner_Community',
            'PID_Partner_Community_Login',
            'PID_Customer_Community',
            'PID_FDC_FREE'
    };

    public static Set<Id> allowedUserLicenseIds {
        get {
            if (allowedUserLicenseIds == null) {
                allowedUserLicenseIds = (new Map<Id, UserLicense>([SELECT Id FROM UserLicense WHERE LicenseDefinitionKey IN :ALLOWED_LICENCE_DEFINITION_KEYS])).keySet();
            }
            return allowedUserLicenseIds;
        }
        set;
    }

    @TestVisible
    private static final String NAMESPACE_PREFIX ='appsolutely';

    @TestVisible
    private static final Map<LicenseType, String> PERMISSION_GROUPS_BY_LICENSE_TYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS => 'Companyinfo_for_Dutch_Business',
            LicenseType.COMPANY_INFO_FOR_INTERNATIONAL_BUSINESS => 'Companyinfo_for_international_business',
            LicenseType.COMPANY_INFO_FOR_SALES => 'Companyinfo_for_sales'
    };

    @TestVisible
    private static final Map<LicenseType, String> FEATURE_PARAM_NAMES_BY_LICENSETYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS => 'CompanyInfoForDutchBusinessNrOfSeats',
            LicenseType.COMPANY_INFO_FOR_INTERNATIONAL_BUSINESS => 'CompanyInfoForInternationalBusinessNrOfSeats',
            LicenseType.COMPANY_INFO_FOR_SALES => 'CompanyInfoForSalesNrOfSeats',
            LicenseType.TEST_NO_FEATURE_PARAM => 'bogus' // TODO: refactor so no test code in implementation code
    };

    /**
     * The title/name definition of the license modules
    */
    @TestVisible
    private static final Map<LicenseType, String> LICENCE_TYPE_NAMES_BY_LICENSETYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS => 'Company.info for Dutch Business',
            LicenseType.COMPANY_INFO_FOR_INTERNATIONAL_BUSINESS => 'Company.info for International Business',
            LicenseType.COMPANY_INFO_FOR_SALES => 'Company.info for Sales'
    };

    private static Map<LicenseType, PermissionSetGroup> permissionGroupsByLicenseTypes = new Map<LicenseType, PermissionSetGroup>();

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType) {
        return UserSelector.newInstance().selectByPermissionSetGroup(getPermissionSetGroupByLicenseType(licenseType));
    }

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return UserSelector.newInstance().selectByPermissionSetGroup(getPermissionSetGroupByLicenseType(licenseType), offSet, nrOfRows, ordering);
    }

    public User[] getUnAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return UserSelector.newInstance().selectUsersWithoutPermissionSetGroup(getPermissionSetGroupByLicenseType(licenseType), offSet, nrOfRows, ordering);
    }

    public Integer getUnAssignedUsersForLicenseTypeCount(LicenseType licenseType) {
        Integer numberOfSeatsAssigned = getAssignedUsersForLicenseType(licenseType).size();
        Integer totalNumberOfUsers = [SELECT Count() FROM User];
        return totalNumberOfUsers - numberOfSeatsAssigned;
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
        if (!isScratchOrg() || Test.isRunningTest()) { // in a scratch org outside a unit test the feature param is not available
            List<User> usersWithoutLMALicense = filterUsersWithoutLMALicense(users);
            if (usersWithoutLMALicense.size() > 0) {
                throw new NoLMALicenseAssignedException('No LMA License has been assigned to the given users');
            }
        }

        // delete all relevant permission set assignments
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroupAndUsers(getPermissionSetGroupByLicenseType(licenseType), users);
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
        PermissionSetGroup permissionSetGroup = getPermissionSetGroupByLicenseType(licenseType);
        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
        for (User user : users) {
            PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(PermissionSetGroupId = permissionSetGroup.Id, AssigneeId = user.Id);
            assignments.add(permissionSetAssignment);
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

    public PermissionSetGroup getPermissionSetGroupByLicenseType(LicenseType licenseType) {
        PermissionSetGroup permissionSetGroup = permissionGroupsByLicenseTypes.get(licenseType);
        if (permissionSetGroup == null) {
            PermissionSetGroup[] groups = PermissionSetGroupSelector.newInstance().selectByDeveloperName(PERMISSION_GROUPS_BY_LICENSE_TYPE.get(licenseType));
            if (groups.size() == 0) {
                throw new NoPermSetGroupForLicenseTypeException('No permission set group defined for license type ' + licenseType.name());
            }
            permissionSetGroup = groups.get(0);
            permissionGroupsByLicenseTypes.put(licenseType, permissionSetGroup);
        }
        return permissionSetGroup;
    }

    public String getLicenseTypeName(LicenseType licenseType) {
        String returnValue = LICENCE_TYPE_NAMES_BY_LICENSETYPE.get(licenseType);
        if (returnValue == null) {
            throw new NoNameDefinedForLicenseTypeException('No name defined for ' + licenseType.name());
        }
        return returnValue; // this is the human readable name, not the API name
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
        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroupAndUsers(getPermissionSetGroupByLicenseType(licenseType), users);
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
        System.debug('organization: ' + org);
        Boolean isScratchOrg = org.IsSandbox && org.TrialExpirationDate != null;
        return isScratchOrg;
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