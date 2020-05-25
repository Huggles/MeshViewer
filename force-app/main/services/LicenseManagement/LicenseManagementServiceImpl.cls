/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public with sharing class LicenseManagementServiceImpl implements ILicenseManagementService {

    @TestVisible
    private static final String NAMESPACE_PREFIX ='appsolutely';

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
            'PID_FDC_FREE',
            'PID_Guest_User' // so guest users can get a license too
    };

    @TestVisible
    // TODO: to be refactored so no more permission set groups
    private static final Map<LicenseType, String> PERMISSION_GROUPS_BY_LICENSE_TYPE = new Map<LicenseType, String>{
            LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS => 'Companyinfo_for_Dutch_Business',
            LicenseType.COMPANY_INFO_FOR_INTERNATIONAL_BUSINESS => 'Companyinfo_for_international_business',
            LicenseType.COMPANY_INFO_FOR_SALES => 'Companyinfo_for_sales'
    };

    /**
     * The Ids of all Salesforce licenses that can receive a license
     */
    // TODO: why public?
    public static Set<Id> allowedUserLicenseIds {
        get {
            if (allowedUserLicenseIds == null) {
                allowedUserLicenseIds = (new Map<Id, UserLicense>([SELECT Id FROM UserLicense WHERE LicenseDefinitionKey IN :ALLOWED_LICENCE_DEFINITION_KEYS])).keySet();
            }
            return allowedUserLicenseIds;
        }
        set;
    }

    // TODO: to be refactored so no more permission set groups
    private static Map<LicenseType, PermissionSetGroup> permissionGroupsByLicenseTypes = new Map<LicenseType, PermissionSetGroup>();

    /**
     * True if for the namespace appsolutely a user based LMA license model instead of an org wide model is used
     */
    private static Boolean userBasedLmaLicenseModel {
        get {
            if (userBasedLmaLicenseModel == null) {
                PackageLicense packageLicense = [SELECT AllowedLicenses FROM PackageLicense WHERE NamespacePrefix =:NAMESPACE_PREFIX LIMIT 1];
                if (packageLicense != null && packageLicense.AllowedLicenses >=0) { // in scratch orgs/development situations there is no package license, in sandboxes an org wide model is used so the allowedlicense = -1
                    userBasedLmaLicenseModel = true;
                } else {
                    userBasedLmaLicenseModel = false;
                }
            }
            return userBasedLmaLicenseModel;
        }
        set;
    }

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType) {
        return UserSelector.newInstance().selectByPermissionSetGroup(getPermissionSetGroupByLicenseType(licenseType));
    }

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return UserSelector.newInstance().selectByLicenseType(licenseType, offSet, nrOfRows, ordering);
    }

    public User[] getUnAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return UserSelector.newInstance().selectUsersWithoutLicenseType(licenseType, offSet, nrOfRows, ordering);
    }

    public Integer getUnAssignedUsersForLicenseTypeCount(LicenseType licenseType) {
        Integer numberOfSeatsAssigned = getAssignedUsersForLicenseType(licenseType).size();
        Integer totalNumberOfUsers = [SELECT Count() FROM User];
        return totalNumberOfUsers - numberOfSeatsAssigned;
    }

    public Integer getTotalNumberOfSeats(LicenseType licenseType) {
        License_Type_Definition__mdt licenseTypeDefinition = getLicenseTypeDefinition(licenseType);
        Integer returnValue = null;
        try {
            returnValue = FeatureManagement.checkPackageIntegerValue(licenseTypeDefinition.Nr_Of_Seats_Feature_Param_API_Name__c);
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

        if (userBasedLmaLicenseModel) {
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
        License_Type_Definition__mdt licenseTypeDefinition = getLicenseTypeDefinition(licenseType);
        Integer numberOfSeatsBought = FeatureManagement.checkPackageIntegerValue(licenseTypeDefinition.Nr_Of_Seats_Feature_Param_API_Name__c);
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
        License_Type_Definition__mdt licenseTypeDefinition = getLicenseTypeDefinition(licenseType);
        return licenseTypeDefinition.Title__c; // this is the human readable name, not the API name
    }

    private static Map<Feature, Map<Id, Boolean>> userHasAccessPerFeature = new Map<Feature, Map<Id, Boolean>>();

    private static Map<String, Id> customPermissionIdsByDeveloperName {
        get {
            if (customPermissionIdsByDeveloperName == null) {
                customPermissionIdsByDeveloperName = new Map<String, Id>();
                List<CustomPermission> customPermissions = [SELECT Id, DeveloperName FROM CustomPermission];
                for (CustomPermission customPermission : customPermissions) {
                    customPermissionIdsByDeveloperName.put(customPermission.DeveloperName, customPermission.Id);
                }
            }
            return customPermissionIdsByDeveloperName;
        }
        set;
    }

    private static Map<Id, Set<Id>> permissionSetGroupAndSetIdsByCustomPermissionId = new Map<Id, Set<Id>>();

    private static Set<Id> getPermissionSetGroupAndSetIds(Id customPermissionId) {
        Set<Id> returnValue = permissionSetGroupAndSetIdsByCustomPermissionId.get(customPermissionId);
        if (returnValue == null) {
            returnValue = new Set<Id>();
            SetupEntityAccess[] setupEntityAccesses = [SELECT ParentId FROM SetupEntityAccess WHERE SetupEntityType = 'CustomPermission' AND SetupEntityId =:customPermissionId];
            for (SetupEntityAccess setupEntityAccess : setupEntityAccesses) {
                returnValue.add(setupEntityAccess.ParentId);
            }
            permissionSetGroupAndSetIdsByCustomPermissionId.put(customPermissionId, returnValue);
        }
        return returnValue;
    }


    public void userHasAccess(Feature feature) {
        Map<Id, Boolean> userHasAccess = userHasAccessPerFeature.get(feature);
        if (userHasAccess == null) {
            userHasAccess = new Map<Id, Boolean>();
            userHasAccessPerFeature.put(feature, userHasAccess);
        }
        Id userId = UserInfo.getUserId();
        Boolean hasAccessToThisFeature = userHasAccess.get(userId);
        if (hasAccessToThisFeature == null) {
            String featureName = feature.name();
            Feature_Definition__mdt featureDefinition = [SELECT DeveloperName FROM Feature_Definition__mdt WHERE DeveloperName = : featureName LIMIT 1]; // featureName is in capitals but a SOQL search is case insensitive so this returns the right mdt
            Id customPermissionId = customPermissionIdsByDeveloperName.get(featureDefinition.DeveloperName); // a get is case sensitive so we need the Feature_Definition_mdt here
            //System.debug('customPermissionIdsByDeveloperName: ' + JSON.serializePretty(customPermissionIdsByDeveloperName));
            //System.debug('featureName ' + featureName);
            System.debug('customPermissionId ' + customPermissionId);
            Set<Id> permissionSetGroupAndSetIds = getPermissionSetGroupAndSetIds(customPermissionId);
            PermissionSetAssignment[] permissionSetAssignments = [SELECT PermissionSetGroupId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :userId AND (PermissionSetGroupId IN :permissionSetGroupAndSetIds OR PermissionSetId IN:permissionSetGroupAndSetIds)];
            hasAccessToThisFeature = permissionSetAssignments.size() > 0;
            userHasAccess.put(userId, hasAccessToThisFeature);
        }
        if (!hasAccessToThisFeature) {
            throw new NoAccessToFeatureException('User ' + UserInfo.getUserId() + ' does not have access to ' + feature.name());
        }
    }

    /*****************************************
     * IMPLEMENTATION METHODS AFTER THIS POINT
    ******************************************/

    private PermissionSet[] getPermissionSets(LicenseType licenseType) {
//        // first get the license type definition
//        License_Type_Definition__mdt licenseTypeDefinition = getLicenseTypeDefinition(licenseType);
//
//        // then get the license type permission set definitions
//        License_Type_Permission_Set__mdt[] licenseTypePermissionSets = [
//                SELECT
//                        License_Type_Definition__c,
//                        Permission_Set_API_Name__c,
//                        DeveloperName,
//                        Id,
//                        Label,
//                        Language,
//                        MasterLabel,
//                        NamespacePrefix,
//                        QualifiedApiName
//                FROM License_Type_Permission_Set__mdt WHERE License_Type_Definition__c = :licenseTypeDefinition.Id];
//
//        // query the permission sets
//        Set<String> permissionSetApiNames = new Set<String>();
//        for (License_Type_Permission_Set__mdt licenseTypePermissionSet : licenseTypePermissionSets) {
//            permissionSetApiNames.add(licenseTypePermissionSet.Permission_Set_API_Name__c);
//        }
//        PermissionSet[] result = [
//                SELECT
//                        Id
//                FROM PermissionSet WHERE Name IN :permissionSetApiNames];
//
//        // return them
//        return result;
        // TODO: implement this
        return null;
    }

    private License_Type_Definition__mdt getLicenseTypeDefinition(LicenseType licenseType) {
        License_Type_Definition__mdt[] licenseTypeDefinitions = [
                SELECT
                        Nr_Of_Seats_Feature_Param_API_Name__c,
                        Title__c,
                        DeveloperName,
                        Id,
                        Label,
                        Language,
                        MasterLabel,
                        NamespacePrefix,
                        QualifiedApiName
                FROM License_Type_Definition__mdt WHERE DeveloperName =:licenseType.name()];
        return licenseTypeDefinitions.get(0);
    }

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