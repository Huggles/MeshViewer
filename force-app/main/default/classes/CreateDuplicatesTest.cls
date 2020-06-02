/**
 * Created by tejaswinidandi on 02/06/2020.
 */

@IsTest
private class CreateDuplicatesTest {

    @IsTest
    static void createDuplicateAccountTest() {
        Account account1 = new Account(Name = 'test', BillingCity = 'city');
        Account account2 = new Account(Name = 'test', BillingCity = 'city');

        Test.startTest();
        Id id1 = CreateDuplicates.createDuplicateAccount(account1);
        Id id2 = CreateDuplicates.createDuplicateAccount(account2);
        Test.stopTest();

        System.assertNotEquals(id1, null);
        System.assertNotEquals(id2, null);

    }
}