/**
 * Created by jaapbranderhorst on 04/02/2020.
 */

@IsTest
private class CustConnectV20UpgradeScriptTest {
    @IsTest
    static void testNoScheduledJob() {
        // given
        // no scheduled job (it failed earlier for example and thus has not been rescheduled)

        // when
        // the script is executed
        IInstallAction action = new CustConnectV20UpgradeScript();
        InstallActionTestHelper script = new InstallActionTestHelper(action);
        Test.startTest();
        Test.testInstall(script, new Version(2,0));
        Test.stopTest();

        // then
        // well...nothing
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger
                WHERE CronJobDetail.Name =: CustConnectV20UpgradeScript.UPDATE_DOSSIER_SCHEDULE_NAME LIMIT 1];
        System.assert(cronTriggers.size() == 0);
    }

    @IsTest
    static void testAlreadyScheduledJob() {
        // given
        // a scheduled job
        String cronexpression = '0 0 '+ '0' +' * * ?';
        System.Schedule(CustConnectV20UpgradeScript.UPDATE_DOSSIER_SCHEDULE_NAME, cronexpression, new UpdateDossierBatchScheduler());
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger
            WHERE CronJobDetail.Name =: CustConnectV20UpgradeScript.UPDATE_DOSSIER_SCHEDULE_NAME LIMIT 1];
        System.assert(cronTriggers.size() == 1);

        // when
        // the script is executed
        IInstallAction action = new CustConnectV20UpgradeScript();
        InstallActionTestHelper script = new InstallActionTestHelper(action);
        Test.startTest();
        Test.testInstall(script, new Version(2,0));
        Test.stopTest();

        // then
        // no more scheduled jobs
        cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger
            WHERE CronJobDetail.Name =: CustConnectV20UpgradeScript.UPDATE_DOSSIER_SCHEDULE_NAME LIMIT 1];
        System.assert(cronTriggers.size() == 0);
    }
}