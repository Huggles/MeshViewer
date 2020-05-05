/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

@IsTest
private class UserSelectorTest {

    @IsTest
    static void selectByPermissionSetGroupHappyFlow() {
        // given
        // 5 users without a permission set group and 5 with
        List<User> users = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            users.add(TestUtils.getUser('Standard User'));
        }
        System.runAs(TestUtils.getUser('System Administrator')) {
            insert users;
        }
        for (Integer i = 0; i < 5; i++) {
            TestUtils.giveUserPermissionSetGroup('Companyinfo_for_Business', users[i]);
        }

        // when

        Test.startTest();
        User[] usersToAssert = UserSelector.newInstance().selectByPermissionSetGroup('Companyinfo_for_Business');
        Test.stopTest();

        // then
        System.assertEquals(5, usersToAssert.size());
        System.assert(usersToAssert[0].Profile.Name == 'Standard User');

    }
}