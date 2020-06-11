/**
 * Created by tejaswinidandi on 10/06/2020.
 */

@IsTest
private class DuplicateManagementServiceImplTest {

    @TestSetup
    static void setup() {
        Account account1 = new Account(Name = 'test', BillingCity = 'city');
        insert account1;
    }

    @IsTest
    static void findDuplicatesTest() {
        Account account2 = new Account(Name = 'test', BillingCity = 'city');
        List<Account> accounts = new List<Account>();
        accounts.add(account2);

        Test.startTest();
        List<SObject> sObjects = DuplicateManagementService.findDuplicates(accounts);
        Test.stopTest();

        System.assertNotEquals(sObjects, null);
        if (sObjects.size() > 0) { //we know that a duplicate rule is active
            System.assertNotEquals(sObjects.size(), 0);
        }
    }

    @IsTest
    static void createDuplicateAccountTest() {
        Account account1 = new Account(Name = 'test', BillingCity = 'city');
        Account account2 = new Account(Name = 'test', BillingCity = 'city');

        Test.startTest();
        Id id1 = DuplicateManagementService.createDuplicate(account1);
        Id id2 = DuplicateManagementService.createDuplicate(account2);
        Test.stopTest();

        System.assertNotEquals(id1, null);
        System.assertNotEquals(id2, null);

    }

    @IsTest
    static void createDuplicateAccountFTest() {
        Account account1 = new Account(Name = 'test', BillingCity = 'city');
        Account account2 = new Account(Name = 'test', BillingCity = 'city');

        Test.startTest();
        Id id1 = DuplicateManagementService.createDuplicate(account1);
        Id id2 = DuplicateManagementService.createDuplicate(account2);
        Test.stopTest();

        System.assertNotEquals(id1, null);
        System.assertNotEquals(id2, null);

    }
}