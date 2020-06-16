/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

@IsTest
private class UserPackageSelectorTest {
    @IsTest
    static void testselectByPackageLicenseAndUsers() {
        // given
        // 10 users
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(TestUtils.getUser('Standard User'));
        }
        insert users;
        // we cannot insert a packagelicense so this is kind of a bogus test
        PackageLicenseWrapper packageLicense = new PackageLicenseWrapper(new PackageLicense(Id = fflib_IDGenerator.generate(PackageLicense.SObjectType)));

        // when
        Test.startTest();
        UserPackageLicense[] userPackageLicenses = UserPackageSelector.newInstance().selectByPackageLicenseAndUsers(packageLicense, users);
        Test.stopTest();

        // then
        System.assertEquals(0, userPackageLicenses.size());
    }
}