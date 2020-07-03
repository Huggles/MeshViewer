/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public with sharing class LicenseManagementServiceImpl implements ILicenseManagementService {

    @TestVisible
    private static Boolean isTestingLicenseManagement = false;

    @TestVisible
    private static String NAMESPACE_PREFIX = 'appsolutely'; // default to ensure this works in non-packaged code as well

    static {
        try {
            NAMESPACE_PREFIX = ([SELECT NamespacePrefix FROM PackageLicense WHERE Id =:Packaging.getCurrentPackageId() LIMIT 1]).NamespacePrefix;
        } catch (NoDataFoundException ex) {
            // just ignore, this runs in non-packaged code
        }
    }

    /**
     * True if for the namespace appsolutely a user based LMA license model instead of an org wide model is used
     */
    private static Boolean userBasedLmaLicenseModel {
        get {
            if (userBasedLmaLicenseModel == null) {
                userBasedLmaLicenseModel = false;
                try {
                    PackageLicense[] packageLicenses = [SELECT AllowedLicenses FROM PackageLicense WHERE Id =:Packaging.getCurrentPackageId() LIMIT 1];
                    if (packageLicenses != null && packageLicenses.size() == 1 && packageLicenses.get(0).AllowedLicenses >=0) { // in scratch orgs/development situations there is no package license, in sandboxes an org wide model is used so the allowedlicense = -1
                        userBasedLmaLicenseModel = true;
                    }
                } catch (NoDataFoundException ex) {
                    // just ignore, this runs in non-packaged code
                }
            }
            return userBasedLmaLicenseModel;
        }
        set;
    }

    private static Map<Feature, Map<Id, Boolean>> userHasAccessPerFeature = new Map<Feature, Map<Id, Boolean>>();

    private static Map<String, CustomPermission> customPermissionByDeveloperName {
        get {
            if (customPermissionByDeveloperName == null) {
                customPermissionByDeveloperName = new Map<String, CustomPermission>();
                List<CustomPermission> customPermissions = [SELECT Id, DeveloperName FROM CustomPermission];
                for (CustomPermission customPermission : customPermissions) {
                    customPermissionByDeveloperName.put(customPermission.DeveloperName, customPermission);
                }
            }
            return customPermissionByDeveloperName;
        }
        set;
    }

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType) {
        return UserSelector.newInstance().selectByLicenseType(licenseType);
    }

    public User[] getAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return UserSelector.newInstance().selectByLicenseType(licenseType, offSet, nrOfRows, ordering);
    }

    public User[] getUnAssignedUsersForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return UserSelector.newInstance().selectUsersAvailableForLicenseType(licenseType, offSet, nrOfRows, ordering);
    }

    public User[] getUsersWithoutSeat(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> ordering) {
        return UserSelector.newInstance().selectUsersAvailableForLicenseType(licenseType, offSet, nrOfRows, ordering);
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


    public void unassignLicenseType(LicenseType license, User[] users) {
        // check if the users have a license and throw an exception if they don't
        List<User> usersWithoutLicenseTypes = filterUsersWithoutLicenseTypeAssignment(license, users);
        if (usersWithoutLicenseTypes.size() > 0) {
            throw new NoSeatAssignedException('No seats of license type ' + license.name() + ' have been assigned to the given users');
        }
        if (userBasedLmaLicenseModel || isTestingLicenseManagement) { // in a scratch org outside a unit test the feature param is not available
            List<User> usersWithoutLMALicense = filterUsersWithoutLMALicense(users);
            if (usersWithoutLMALicense.size() > 0) {
                throw new NoLMALicenseAssignedException('No LMA License has been assigned to the given users');
            }
        }

        // delete all relevant permission set assignments
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByLicenseTypeAndUsers(license, users);
        unitOfWork.registerDeleted(permissionSetAssignments);

        // remove the user LMA license if needed
        if (userBasedLmaLicenseModel || isTestingLicenseManagement) {
            // check if the user has other license types assigned
            Set<LicenseType> otherLicenseTypes = new Set<LicenseType>(LicenseType.values());
            otherLicenseTypes.remove(license);
            for (LicenseType otherLicenseType : otherLicenseTypes) {
                if (users.size() > 0) {
                    // if there are users that do NOT have the license type assigned, filter them out
                    users = filterUsersWithoutLicenseTypeAssignment(otherLicenseType, users);
                } else {
                    break;
                }
            }
            // check if the current user is in the set. If so remove him from the set since he is the one removing the LMA licenses and should keep a license.
            Id currentUserId = UserInfo.getUserId();
            Map<Id, User> usersByIds = new Map<Id, User>(users);
            if (usersByIds.get(currentUserId) != null) {
                usersByIds.remove(currentUserId);
                users = usersByIds.values();
            }
            // select the user package licenses to delete
            UserPackageLicense[] userPackageLicenses = UserPackageSelector.newInstance().selectByPackageLicenseAndUsers(packageLicense, users);
            unitOfWork.registerDeleted(userPackageLicenses);
        }
        unitOfWork.commitWork();
    }

    public void assignLicenseType(LicenseType licenseType, User[] users) {
        // calculate if we have enough seats available
        users = filterUsersWithoutLicenseTypeAssignment(licenseType, users);
        if (users.size() > getNumberOfAvailableSeats(licenseType)) {
            throw new NotEnoughSeatsAvailableException('Not enough seats of license type ' + licenseType.name() + ' available');
        }
        PermissionSet permissionSet = PermissionSetSelector.newInstance().selectByLicenseType(licenseType);
        if (permissionSet == null) {
            throw new InputException('No permission set for ' + licenseType.name());
        }

        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();

        if (userBasedLmaLicenseModel || isTestingLicenseManagement) {
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

        // assign the permission set(s)
        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
        for (User user : users) {
            PermissionSetAssignment permAssignment = new PermissionSetAssignment(PermissionSetId = permissionSet.Id, AssigneeId = user.Id);
            assignments.add(permAssignment);
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

    public String getLicenseTypeName(LicenseType licenseType) {
        License_Type_Definition__mdt licenseTypeDefinition = getLicenseTypeDefinition(licenseType);
        return licenseTypeDefinition.Title__c; // this is the human readable name, not the API name
    }

    public Boolean userHasAccess(Feature feature) {
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
            CustomPermission customPermission = customPermissionByDeveloperName.get(featureDefinition.DeveloperName); // a get is case sensitive so we need the Feature_Definition_mdt here
            Set<Id> permissionSetIds = (new Map<Id, PermissionSet>(PermissionSetSelector.newInstance().selectPermissionSetsByCustomPermission(new List<CustomPermission>{customPermission}))).keySet();
            PermissionSetAssignment[] permissionSetAssignments = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :userId AND (PermissionSetId IN:permissionSetIds)];
            hasAccessToThisFeature = permissionSetAssignments.size() > 0;
            userHasAccess.put(userId, hasAccessToThisFeature);
        }
        return hasAccessToThisFeature;
    }

    public Set<String> getAllowedLicenseDefinitionKeysForLicenseType(LicenseType licenseType) {
        License_Type_Definition__mdt licenseTypeDefinition = getLicenseTypeDefinition(licenseType);
        List<Allowed_Salesforce_License_Type__mdt> allowedSalesforceLicenseTypess = [SELECT License_Definition_Key__c FROM Allowed_Salesforce_License_Type__mdt WHERE License_Type_Definition__c = :licenseTypeDefinition.Id];
        Set<String> returnValue = new Set<String>();
        for (Allowed_Salesforce_License_Type__mdt allowedSalesforceLicenseType : allowedSalesforceLicenseTypess) {
            returnValue.add(allowedSalesforceLicenseType.License_Definition_Key__c);
        }
        return returnValue;
    }

    public Set<Id> getAllowedProfileIdsForLicenseType(LicenseType licenseType) {
        Set<String> licenseKeys = LicenseManagementService.getAllowedLicenseDefinitionKeysForLicenseType(licenseType);
        List<Profile> allowedProfiles = [SELECT Id FROM Profile WHERE UserLicense.LicenseDefinitionKey IN :licenseKeys];
        Set<Id> profileIds = (new Map<Id, Profile>(allowedProfiles)).keySet();
        return profileIds;
    }

    /*****************************************
     * IMPLEMENTATION METHODS AFTER THIS POINT
    ******************************************/

    private PermissionSet getPermissionSets(LicenseType licenseType) {
        License_Type_Definition__mdt licenseTypeDefinition = getLicenseTypeDefinition(licenseType);
        PermissionSet result = [SELECT Id FROM PermissionSet WHERE Name =: licenseTypeDefinition.Permission_Set_API_Name__c LIMIT 1];
        return result;
    }

    private License_Type_Definition__mdt getLicenseTypeDefinition(LicenseType licenseTp) {
        String licenseTypeName = licenseTp.name();
        License_Type_Definition__mdt[] licenseTypeDefinitions = [
                SELECT
                        Nr_Of_Seats_Feature_Param_API_Name__c,
                        Licence_Type_Name__c,
                        Title__c,
                        DeveloperName,
                        Id,
                        Label,
                        Language,
                        MasterLabel,
                        NamespacePrefix,
                        QualifiedApiName
                FROM License_Type_Definition__mdt WHERE Licence_Type_Name__c =:licenseTypeName LIMIT 1];
        if (licenseTypeDefinitions == null || licenseTypeDefinitions.size() == 0) {
            throw new NoLicenseDefinitionException('No License Definition for LicenseType ' +licenseTp.name());
        }
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
        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByLicenseTypeAndUsers(licenseType, users);
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

    @TestVisible
    private static PackageLicenseWrapper packageLicense {
        get {
            if (packageLicense == null) {
                try {
                    List<PackageLicenseWrapper> packageLicenseWrappers = PackageLicenseSelector.newInstance().selectById(Packaging.getCurrentPackageId());
                    packageLicense = packageLicenseWrappers.get(0);
                } catch (NoDataFoundException ex) {
                    // runs in non-packaged mode, we need to stub the packageLicense
                    packageLicense = new PackageLicenseWrapper(fflib_IDGenerator.generate(Schema.PackageLicense.SObjectType), 0, 20, LicenseManagementServiceImpl.NAMESPACE_PREFIX);
                }
            }
            return packageLicense;
        }
        set;
    }

}