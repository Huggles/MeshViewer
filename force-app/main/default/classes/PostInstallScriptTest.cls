/**
 * Created by jaapbranderhorst on 2019-07-17.
 */

@IsTest
private class PostInstallScriptTest {

    public inherited sharing class TestNameSpaceInstallAction implements IInstallAction {
        public void execute(InstallContext context) {
            throw new CCException('');
        }
    }

    @IsTest
    private static void testNameSpaceSwitchAppsolutely() {
        // given
        // a postinstall script for the namespace cust_connect with a test installaction that throws an error
        PostInstallScript script = new PostInstallScript();
        script.installAction = new TestNameSpaceInstallAction();

        // when
        // running the postinstall script
        Boolean errorThrown = false;
        Test.startTest();
        try {
            Test.testInstall(script, null);
        } catch (CCException e) {
            errorThrown = true;
        }

        // then
        // an error is thrown
        System.assert(errorThrown);
    }
    
    @TestSetup
    static void testSetup() {
        Integer nrOfAccountsWithoutRecordTypeId = 20;
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < nrOfAccountsWithoutRecordTypeId; i++) {
            accounts.add(new Account(Name = '' + i));
        }
        insert accounts;

        Credentials__c c = new Credentials__c();
        c.Username__c = 'test';
        c.Password__c = 'pas';
        c.CompanyInfo_Account_Id__c = '1';
        c.CompanyConnectUserId__c = 11;
        c.Last_Executed_Batch__c = Datetime.newInstance(2019, 7, 28);
        insert c;
    }


}