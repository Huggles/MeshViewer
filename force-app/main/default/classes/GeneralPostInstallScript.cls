/**
 * Created by tejaswinidandi on 21/01/2020.
 */

public without sharing class GeneralPostInstallScript implements IInstallAction {
    private inherited sharing class BatchScheduler implements Schedulable {

        private Database.Batchable<Business_Dossier__c> batchable;
        private Integer batchSize;

        public BatchScheduler(Database.Batchable<Business_Dossier__c> batchable, Integer batchSize) {
            this.batchable = batchable;
            this.batchSize = batchSize;
        }

        public void execute(SchedulableContext sc) {
            Database.ExecuteBatch(batchable, batchSize);
        }
    }

    public void execute(InstallContext context) {
        //get the schedule for the update/remove batches for dutch dossier
        String updateCronExpression = SettingUtils.getProtectedSetting(SetupServiceImpl.UPDATE_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME);
        String removeBatchScheduleCronExpression = SettingUtils.getProtectedSetting(SetupServiceImpl.REMOVE_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME);
        // schedule the batches
        schedule(SetupServiceImpl.UPDATE_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME, new BatchScheduler(new UpdateDossiersBatch(), 99), updateCronExpression);
        schedule(SetupServiceImpl.REMOVE_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME, new BatchScheduler(new ProcessRemovedDutchDossiersBatch(), 200), removeBatchScheduleCronExpression);
    }

    private void schedule(String scheduleName, Schedulable schedulable, String cronExpression) {
        // check if there is an existing scheduled job, if so abort it and restart (to ensure no 'stale' jobs run)
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger
            WHERE CronJobDetail.Name =: scheduleName];
        for (CronTrigger cronTrigger : cronTriggers) {
            try {
                System.abortJob(cronTrigger.Id);
            } catch (Exception ex) { // sometimes this throws unexpected exceptions which can be ignored.

            }

        }
        try {
            System.schedule(scheduleName, cronExpression, schedulable);
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
        }

    }

}