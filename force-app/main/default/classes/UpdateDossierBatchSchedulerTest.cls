/**
 * Created by tejaswinidandi on 2019-08-12.
 */

@IsTest
private class UpdateDossierBatchSchedulerTest {

    @TestSetup
    private static void setupData() {
        Credentials__c c = new Credentials__c();
        c.Username__c = 'test';
        c.Password__c = 'pas';
        c.CompanyInfo_Account_Id__c = '1';
        c.CompanyConnectUserId__c = 11;
        c.Last_Executed_Batch__c = Datetime.newInstance(2019, 7, 28);
        insert c;
    }

    @IsTest
    static void testBehavior() {
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

        test.startTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        UpdateDossierBatchScheduler sch = new UpdateDossierBatchScheduler();
        String jobId = System.schedule('Example Batch Schedule job', CRON_EXP, sch);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        test.stopTest();
    }
}