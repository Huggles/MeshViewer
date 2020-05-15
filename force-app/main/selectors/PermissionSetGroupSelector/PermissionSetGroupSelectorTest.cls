
/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

@IsTest
private class PermissionSetGroupSelectorTest {
    @IsTest
    static void testSelectByDeveloperName() {
        // given
        // a bogus developer name of a permission set group
        String bogusName = 'bogus';
        // a real develoepr name of a permission set group
        String developerName = LicenseManagementServiceImpl.PERMISSION_GROUPS_BY_LICENSE_TYPE.get(LicenseType.COMPANY_INFO_FOR_DUTCH_BUSINESS);

        // when
        Test.startTest();
        PermissionSetGroup[] bogusGroups = PermissionSetGroupSelector.newInstance().selectByDeveloperName(bogusName);
        PermissionSetGroup[] developePermissionSetGroups = PermissionSetGroupSelector.newInstance().selectByDeveloperName(developerName);
        Test.stopTest();

        // then
        System.assertEquals(0, bogusGroups.size());
        System.assertEquals(1, developePermissionSetGroups.size());
    }
}