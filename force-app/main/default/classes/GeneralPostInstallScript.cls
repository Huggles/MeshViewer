/**
 * Created by tejaswinidandi on 21/01/2020.
 */

public without sharing class GeneralPostInstallScript implements IInstallAction {

    private final static String UPDATED_DOSSIER_SCHEDULE_CRON_SETTING_NAME = '';
    private final static String REMOVED_DOSSIER_SCHEDULE_CRON_SETTING_NAME = '';

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
        //get the time
        String updateCronExpression = SettingUtils.getSetting(UPDATED_DOSSIER_SCHEDULE_CRON_SETTING_NAME);
        String removeBatchScheduleCronExpression = SettingUtils.getSetting(REMOVED_DOSSIER_SCHEDULE_CRON_SETTING_NAME);
        List<Schedule_Update_Dossier__mdt> scheduleUpdateDossiers = [SELECT Hour__c, Label, MasterLabel, DeveloperName FROM Schedule_Update_Dossier__mdt LIMIT 1];
        String hour = String.valueOf(scheduleUpdateDossiers[0].Hour__c).substringBefore('.').substringBefore(',');
        String cronexpression = '0 0 '+ hour +' * * ?';
        // schedule the batches
        scheduleBatch(PROCESS_UPDATED_DOSSIER_SCHEDULE_NAME, new BatchScheduler(new UpdateDossiersBatch(), 99), cronexpression);
        cronexpression = '0 0 '+ hour + 1 +' * * ?'; // offset of 1h
        scheduleBatch(PROCESS_REMOVED_DOSSIER_SCHEDULE_NAME, new BatchScheduler(new ProcessRemovedDutchDossiersBatch(), 200), cronexpression);
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
        System.schedule(scheduleName, cronexpression, schedulable);
    }

}