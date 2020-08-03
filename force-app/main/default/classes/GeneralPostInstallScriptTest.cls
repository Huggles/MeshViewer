/**
 * Created by tejaswinidandi on 21/01/2020.
 */

@IsTest
public with sharing class GeneralPostInstallScriptTest {

    @IsTest
    private static void testNothingScheduled() {
        // given
        // no batches scheduled

        // when
        // the postinstallscript runs
        Test.startTest();
        InstallActionTestHelper helperScript = new InstallActionTestHelper(new GeneralPostInstallScript());
        Test.testInstall(helperScript, null);
        Test.stopTest();

        // then
        // the batches should be scheduled
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger WHERE
            CronJobDetail.Name =: GeneralPostInstallScript.PROCESS_REMOVED_DOSSIER_SCHEDULE_NAME OR
            CronJobDetail.Name =: GeneralPostInstallScript.PROCESS_UPDATED_DOSSIER_SCHEDULE_NAME];
        System.assert(cronTriggers.size() == 3);
    }

    @IsTest
    private static void testBatchesAlreadyScheduled() {
        // given
        // batches already run
        (new GeneralPostInstallScript().execute(null));
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger WHERE
            CronJobDetail.Name =: GeneralPostInstallScript.PROCESS_REMOVED_DOSSIER_SCHEDULE_NAME OR
            CronJobDetail.Name =: GeneralPostInstallScript.PROCESS_UPDATED_DOSSIER_SCHEDULE_NAME ];
        System.assert(cronTriggers.size() == 3);

        // when
        // the postinstallscript runs
        Test.startTest();
        InstallActionTestHelper helperScript = new InstallActionTestHelper(new GeneralPostInstallScript());
        Test.testInstall(helperScript, null);
        Test.stopTest();

        // then
        // new batches should be scheduled
        Map<Id, CronTrigger> cronTriggersToAssertById = new Map<Id, CronTrigger>([SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger WHERE
            CronJobDetail.Name =: GeneralPostInstallScript.PROCESS_REMOVED_DOSSIER_SCHEDULE_NAME OR
            CronJobDetail.Name =: GeneralPostInstallScript.PROCESS_UPDATED_DOSSIER_SCHEDULE_NAME]);
        System.assert(cronTriggersToAssertById.size() == 3);
        for (CronTrigger cronTrigger : cronTriggers) {
            System.assert(cronTriggersToAssertById.get(cronTrigger.Id) == null);
        }
    }


//    @TestSetup
//    private static void setupData() {
//        Credentials__c c = new Credentials__c();
//        c.Username__c = 'test';
//        c.Password__c = 'pas';
//        c.CompanyInfo_Account_Id__c = '1';
//        c.CompanyConnectUserId__c = 11;
//        c.Last_Executed_Batch__c = Datetime.newInstance(2019, 7, 28);
//        insert c;
//    }
//
//    @IsTest
//    static void testBehavior() {
//        fflib_ApexMocks mocks = new fflib_ApexMocks();
//        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
//        Integer pageNR = 1;
//
//        mocks.startStubbing();
//
//        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();
//        output.paging = new DutchBusinessWsdl.ResultInfo();
//        output.paging.numpages = 1;
//        output.results = new DutchBusinessWsdl.DutchBusinessUpdateReferenceArray();
//        output.results.item = new List<DutchBusinessWsdl.DutchBusinessUpdateReference>();
//        DutchBusinessWsdl.DutchBusinessUpdateReference a1 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
//        a1.dossier_number = '1';
//        a1.establishment_number = '2';
//        a1.update_types = new DutchBusinessWsdl.stringArray();
//        a1.update_types.item = new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress'};
//        output.results.item.add(a1);
//
//        DutchBusinessWsdl.DutchBusinessUpdateReference a2 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
//        a2.dossier_number = '11';
//        a2.establishment_number = '12';
//        a2.update_types = new DutchBusinessWsdl.stringArray();
//        a2.update_types.item = new List<String>{'Removed'};
//        output.results.item.add(a2);
//        Credentials__c c = Credentials__c.getOrgDefaults();
//
//        DutchBusinessWsdl.DutchBusinessDossierV3 output1 = new DutchBusinessWsdl.DutchBusinessDossierV3();
//
//        mocks.when(mockWS.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray) fflib_Match.anyObject(), fflib_Match.anyInteger())).thenReturn(output);
//        mocks.when(mockWS.dutchBusinessGetDossierV3(a1.dossier_number, a1.establishment_number)).thenReturn(output1);
//
//        mocks.stopStubbing();
//        Application.Service.setMock(IWsDutchBusiness.class, mockWS);
//
//        test.startTest();
//            GeneralPostInstallScript generalPostInstallScript = new GeneralPostInstallScript();
//            generalPostInstallScript.execute(null);
//        test.stopTest();
//        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Update dossiers' LIMIT 1];
//        System.assertNotEquals(ct, null);
//    }

}