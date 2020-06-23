/**
 * Created by tejaswinidandi on 02/06/2020.
 */

@IsTest
private class CreateDuplicatesControllerTest {

    @TestSetup
    static void setup() {
        Account account1 = new Account(Name = 'test', BillingCity = 'city');
        insert account1;
    }

    @IsTest
    static void createDuplicateAccountTest() {
        Account account1 = new Account(Name = 'test', BillingCity = 'city');
        Account account2 = new Account(Name = 'test', BillingCity = 'city');

        Test.startTest();
        Id id1 = CreateDuplicatesController.createDuplicateAccount(account1);
        Id id2 = CreateDuplicatesController.createDuplicateAccount(account2);
        Test.stopTest();

        System.assertNotEquals(id1, null, 'An id should be filled');
        System.assertNotEquals(id2, null, 'An id should be filled');

    }
}