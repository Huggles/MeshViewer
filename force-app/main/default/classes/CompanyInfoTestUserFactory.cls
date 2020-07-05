/**
 * Created by jaapbranderhorst on 02/07/2020.
 */

public with sharing class CompanyInfoTestUserFactory {

    /**
    * returns a Standard User with the Company.info Admin permissionset
    */
    @TestVisible
    private static User getAdminUser() {
        User testUser = TestUtils.getUniqueUser('System Administrator');
        TestUtils.giveUserPermissionSet('Company_info_administrator', testUser);
        return testUser;
    }

    /**
    * returns a Standard User with the Company.info Dutch Business User permissionset
    */
    @TestVisible
    private static User getDutchBusinessUser() {
        User testUser = TestUtils.getUniqueUser('Standard User');
        TestUtils.giveUserPermissionSet('Company_info_for_Dutch_Business', testUser);
        return testUser;
    }

}