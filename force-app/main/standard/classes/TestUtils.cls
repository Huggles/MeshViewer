/**
 * Created by jaapbranderhorst on 04/02/2018.
 * Class containing utility methods for testing
 */

@IsTest
public class TestUtils {

    private static final Integer SIZE = 900000000;

    private static Map<String, User> usersByProfileName = new Map<String, User>();

    private static Map<String, Id> permissionSetIdsByName = new Map<String, Id>();

    private static User AdminUser {
        get {
            if (AdminUser == null) {
                AdminUser = createUniqueUser('System Administrator');
                System.runAs(getSystemAdminUser()) {
                    insert AdminUser;
                    giveUserPermissionSet('Business_Data_For_Salesforce_User', AdminUser);
                }
            }
            return AdminUser;
        }
        set;
    }

    /**
     * Helper method to create a user (not insert it!) with the given profilename.
     *
     * @param profileName
     *
     * @return new User object
     */
    private static User createUser(String profileName) {
        User u = usersByProfileName.get(profileName);
        if (u == null) {
            u = createUniqueUser(profileName);
            usersByProfileName.put(profileName, u);
            System.runAs(getSystemAdminUserNotInserted()) {
                insert u;
                giveUserPermissionSet('Business_Data_For_Salesforce_User', AdminUser);
            }
        }
        return u;
    }

    private static User createUniqueUser(String profileName) {
        Double d = Math.random() * SIZE;
        Integer randomInt = d.intValue();
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='appsolutely' + randomInt + '@appsolutely.nl');
        return u;
    }

    /**
     * Assigns a permission set with the given name to the user. In Testvisible context so this is not used outside of test context
     *
     * @param user
     * @param permissionSetName
     */
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
     * Creates a user with the Standard User profile and gives BDS permission set profile
     *
     * @return
     */
    public static User getBDSUser() {
        return createUser('Standard User');
    }

    public static User getUniqueBDSUser() {
        return createUniqueUser('Standard User');
    }

    public static User getSystemAdminUser() {
        return createUser('System Administrator');
    }

    public static User getAdminUser() {
        return AdminUser;
    }

    private static User getSystemAdminUserNotInserted() {
        return createUniqueUser('System Administrator');
    }

}