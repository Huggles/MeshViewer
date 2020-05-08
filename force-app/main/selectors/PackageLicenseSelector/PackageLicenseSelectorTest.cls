/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

@IsTest
public with sharing class PackageLicenseSelectorTest {

    @isTest
    static void testSelectByNamespacePrefix() {
        // given
        // an existing namespace
        String namespace = LicenseManagementServiceImpl.NAMESPACE_PREFIX;

        // when
        Test.startTest();
        PackageLicenseWrapper[] packageLicenses = PackageLicenseSelector.newInstance().selectByNamespacePrefix(namespace);
        Test.stopTest();

        // then
        // since we are in a scratch org without installed app, nothing should be returned
        System.assertEquals(0, packageLicenses.size());
    }

}