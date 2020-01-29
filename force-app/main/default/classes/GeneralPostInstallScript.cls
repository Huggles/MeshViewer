/**
 * Created by tejaswinidandi on 21/01/2020.
 */

public without sharing class GeneralPostInstallScript implements IInstallAction {

    private final String UPDATE_DOSSIER_SCHEDULE_NAME = 'Update dossiers';

    public void execute(InstallContext context) {
        //schedule an Update dossier scheduler
        scheduleUpdateDossier();
    }

    private void scheduleUpdateDossier() {
        // check if there is an existing scheduled job, else create one
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger
            WHERE CronJobDetail.Name =: UPDATE_DOSSIER_SCHEDULE_NAME LIMIT 1];
        if (! (cronTriggers.size() > 0)) {
            List<Schedule_Update_Dossier__mdt> scheduleUpdateDossiers = [SELECT Hour__c, Label, MasterLabel, DeveloperName from Schedule_Update_Dossier__mdt LIMIT 1];
            if (scheduleUpdateDossiers.size() > 0) {
                String hour = String.valueOf(scheduleUpdateDossiers[0].Hour__c).substringBefore('.').substringBefore(',');
                String cronexpression = '0 0 '+ hour +' * * ?';
                System.Schedule(UPDATE_DOSSIER_SCHEDULE_NAME, cronexpression, new UpdateDossierBatchScheduler());
            }
        }
    }

}