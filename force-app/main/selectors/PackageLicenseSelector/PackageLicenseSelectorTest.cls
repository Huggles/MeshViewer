/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

@IsTest
public with sharing class PackageLicenseSelectorTest {

    @isTest
    static void testSelectById() {
        // given
        // an existing namespace
        Id packageId = null;
        try {
            packageId = Packaging.getCurrentPackageId();
        } catch (NoDataFoundException ex) {
            // just ignore, this runs in non-packaged code
        }


        // when
        Test.startTest();
        PackageLicenseWrapper[] packageLicenses = PackageLicenseSelector.newInstance().selectById(packageId);
        Test.stopTest();

        // then
        if (packageId == null) { // scratch org
            System.assertEquals(0, packageLicenses.size());
        } else { // managed package
            System.assertEquals(1, packageLicenses.size());
        }

    }

}