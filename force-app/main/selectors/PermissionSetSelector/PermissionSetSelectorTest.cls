/**
 * Created by jaapbranderhorst on 14/06/2020.
 */

@IsTest
private class PermissionSetSelectorTest {
    @IsTest
    static void testSelectByLicenseType() {
        List<LicenseType> licenseTypes = LicenseType.values();
        Test.startTest();
        for (LicenseType myLicenseType : licenseTypes) {
            if (myLicenseType != LicenseType.TEST_LICENSE_TYPE) { // filter
                System.assert(PermissionSetSelector.newInstance().selectByLicenseType(myLicenseType) != null);
            } else {
                System.assert(PermissionSetSelector.newInstance().selectByLicenseType(myLicenseType) == null);
            }
        }
    }
}