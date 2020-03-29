/**
 * Created by tejaswinidandi on 21/01/2020.
 */

public without sharing class GeneralPostInstallScript implements IInstallAction {

    private final static String UPDATED_DOSSIER_SCHEDULE_CRON_SETTING_NAME = 'Update_Dutch_Dossier_Batch_Cron_Schedule';
    private final static String REMOVED_DOSSIER_SCHEDULE_CRON_SETTING_NAME = 'Remove_Dutch_Dossier_Batch_Cron_Schedule';

    @TestVisible
    private final static String PROCESS_UPDATED_DOSSIER_SCHEDULE_NAME = 'Process updated Dutch dossiers';
    @TestVisible
    private final static String PROCESS_REMOVED_DOSSIER_SCHEDULE_NAME = 'Process removed Dutch dossiers';

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
        //get the schedule
        String updateCronExpression = SettingUtils.getSubscriberSetting(UPDATED_DOSSIER_SCHEDULE_CRON_SETTING_NAME);
        String removeBatchScheduleCronExpression = SettingUtils.getSubscriberSetting(REMOVED_DOSSIER_SCHEDULE_CRON_SETTING_NAME);
        // schedule the batches
        scheduleBatch(PROCESS_UPDATED_DOSSIER_SCHEDULE_NAME, new BatchScheduler(new UpdateDossiersBatch(), 99), updateCronExpression);
        scheduleBatch(PROCESS_REMOVED_DOSSIER_SCHEDULE_NAME, new BatchScheduler(new ProcessRemovedDutchDossiersBatch(), 200), removeBatchScheduleCronExpression);
    }

    private void scheduleBatch(String scheduleName, Schedulable schedulable, String cronExpression) {
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