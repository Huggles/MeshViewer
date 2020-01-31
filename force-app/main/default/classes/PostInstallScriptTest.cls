/**
 * Created by jaapbranderhorst on 2019-07-17.
 */

@IsTest
private class PostInstallScriptTest {
    
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
    
    @IsTest
    static void testV20Upgrade() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        Integer pageNR = 1;

        mocks.startStubbing();

        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();
        output.paging = new DutchBusinessWsdl.ResultInfo();
        output.paging.numpages = 1;
        output.results = new DutchBusinessWsdl.DutchBusinessUpdateReferenceArray();
        output.results.item = new List<DutchBusinessWsdl.DutchBusinessUpdateReference>();
        DutchBusinessWsdl.DutchBusinessUpdateReference a1 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a1.dossier_number = '1';
        a1.establishment_number = '2';
        a1.update_types = UpdateDossiersBatchTest.stringArray(new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress'});
        output.results.item.add(a1);

        DutchBusinessWsdl.DutchBusinessUpdateReference a2 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a2.dossier_number = '11';
        a2.establishment_number = '12';
        a2.update_types = UpdateDossiersBatchTest.stringArray(new List<String>{'Removed'});
        output.results.item.add(a2);
        Credentials__c c = Credentials__c.getOrgDefaults();

        DutchBusinessWsdl.DutchBusinessDossierV3 output1 = new DutchBusinessWsdl.DutchBusinessDossierV3();

        mocks.when(mockWS.dutchBusinessUpdateGetChangedDossiers(c.Last_Executed_Batch__c.date(), BusinessServiceImpl.updateTypesArray, pageNR)).thenReturn(output);
        mocks.when(mockWS.dutchBusinessGetDossierV3(a1.dossier_number, a1.establishment_number)).thenReturn(output1);

        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, mockWS);

        List<Account> accounts = [SELECT Id, Name FROM Account];
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (Account account : accounts) {
            dossiers.add(new Business_Dossier__c(Name = account.Name, Account__c = account.Id));
        }
        insert dossiers;
        // Test.testInstall(new PostInstallScript(), new Version(1,0)); // simulate an installed version since this is an upgrade test.
        Test.startTest();
        {
            Test.testInstall(new PostInstallScript(), null);
            Test.testInstall(new PostInstallScript(), new Version(1, 7));
        }
        Test.stopTest();
        dossiers = [SELECT Id FROM Business_Dossier__c WHERE RecordTypeId = :Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByName().get('Dutch Business').getRecordTypeId()];
        System.assert(dossiers.size() == 20);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Update dossiers' LIMIT 1];
        System.assertNotEquals(ct, null);
    }


}