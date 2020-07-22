/**
 * Created by Hugo on 22/07/2020.
 */

public with sharing class UpdateCronSettingsController {
    @AuraEnabled
    public static String getUpdateCronExpression(){
        try {
            return SettingUtils.getSetting(SetupServiceImpl.UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME);
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static CronTrigger getScheduledCronJob(){
        try {
            List<CronTrigger> scheduledCronJobs = SetupService.getScheduledCronJob(SetupServiceImpl.UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_MASTERLABEL);
            if(scheduledCronJobs.size() > 0){
                return scheduledCronJobs[0];
            }
            return null;
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id setUpdateCronExpression(String cronExpression){
        try {
            return SetupService.setUpdateTypeCron(cronExpression);
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}