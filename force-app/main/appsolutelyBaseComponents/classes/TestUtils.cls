/**
 * Created by jaapbranderhorst on 04/02/2018.
 * Class containing utility methods for testing
 */

@IsTest
public inherited sharing class TestUtils {

    private static final Integer SIZE = 900000000;

    private static Map<String, User> usersByProfileName = new Map<String, User>();

    private static Map<String, Id> permissionSetIdsByName = new Map<String, Id>();

    private static Map<String, Profile> profilesByName = new Map<String, Profile>();

    static {
        Profile[] profiles = [SELECT Name, Id FROM Profile];
        for (Profile profile : profiles) {
            profilesByName.put(profile.Name, profile);
        }
    }

    /**
     * Returns a unique user with the given profile. For every profile there is one unique user.
     * If the user doesn't exist, a new user is created.
     * In Testvisible context so this is not used outside of test context
     *
     * @param profile
     *
     * @return new User object
     */
    @TestVisible
    private static User getUniqueUser(String profile) {
        User u = usersByProfileName.get(profile);
        if (u == null) {
            u = getUser(profile);
            usersByProfileName.put(profile, u);
            System.runAs(getUser('System Administrator')) {
                insert u;
            }
        }
        return u;
    }

    /**
     * Helper method to create a user with a user with a unique user id. Doesn't insert the user.
     * In Testvisible context so this is not used outside of test context
     *
     * @param profileName the name of the profile the user needs to have
     * @return the created user
    */
    @TestVisible
    private static User getUser(String profileName) {
        Double d = Math.random() * SIZE;
        Integer randomInt = d.intValue();
        Profile p = profilesByName.get(profileName);
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='appsolutely' + randomInt + '@appsolutely.nl');
        return u;
    }

    /**
     * Assigns a permission set with the given name to the user. The user must be inserted (exist).
     * In Testvisible context so this is not used outside of test context
     *
     * @param u the user who needs to get the permission set assigned.
     * @param permissionSetName the name of the permission set
     */
    @TestVisible
    private static void giveUserPermissionSet(String permissionSetName, User u) {
        Id permissionSetId = permissionSetIdsByName.get(permissionSetName);
        if (permissionSetId == null) {
            PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];
            permissionSetIdsByName.put(permissionSetName, permissionSet.Id);
            permissionSetId = permissionSet.Id;
        }
        PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = permissionSetId);
        insert permissionSetAssignment;
    }

    /**
    * returns a Standard User with the Company.info admin permissionset
    */
    @TestVisible
    private static User getCompanyInfoAdmin() {
        User testUser = TestUtils.getUniqueUser('Standard User');
        TestUtils.giveUserPermissionSet('Company_info_administrator', testUser);
        return testUser;
    }

    /**
    * returns a Standard User with the Company.info admin permissionset
    */
    @TestVisible
    private static User getCompanyInfoBusinessUser() {
        User testUser = TestUtils.getUniqueUser('Standard User');
        TestUtils.giveUserPermissionSet('Company_info_for_Dutch_Business', testUser);
        return testUser;
    }

}

