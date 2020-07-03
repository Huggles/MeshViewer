/**
 * Created by tejaswinidandi on 02/06/2020.
 */

@IsTest
private class FindDuplicatesInvocableTest {

    @TestSetup
    static void setup() {
        Account account1 = new Account(Name = 'test', BillingCity = 'city');
        insert account1;
    }

    @IsTest
    static void findDuplicatesTest() {
        Account account2 = new Account(Name = 'test', BillingCity = 'city');

        List<FindDuplicatesInvocable.FindDuplicatesArgument> findDuplicatesArguments = new List<FindDuplicatesInvocable.FindDuplicatesArgument>();
        FindDuplicatesInvocable.FindDuplicatesArgument findDuplicatesArgument = new FindDuplicatesInvocable.FindDuplicatesArgument();
        findDuplicatesArgument.sobj = account2;
        findDuplicatesArguments.add(findDuplicatesArgument);

        Test.startTest();
        List<List<SObject>> sObjects = FindDuplicatesInvocable.findDuplicates(findDuplicatesArguments);
        Test.stopTest();

        System.assertNotEquals(sObjects, null, 'There should be an instance of sObjects');
        if (sObjects.size() > 0) { //we know that a duplicate rule is active
            System.assertNotEquals(sObjects.size(), 0, 'There should be at least one object');
            System.assertNotEquals(sObjects[0].size(), 0, 'There should be at least one object');
        }
    }
}