/**
 * Created by jaapbranderhorst on 2019-07-16.
 */

public without sharing class PostInstallScript implements InstallHandler {

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // the version is the NEW version (to which you upgrade). In your install action you have to determine what's the
    // OLD version (from which you are upgrading) to have the right behavior.

    private Map<Version, IInstallAction> upgradeActionsByVersions = new Map<Version, IInstallAction> {
            new Version(2,0) => new v20upgradeScript()
    };

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // the version is the version you install. Use upgradeActionsByVersions if this is an upgrade
    private Map<Version, IInstallAction> installActionsByVersions = new Map<Version, IInstallAction>();

    public void onInstall(InstallContext context) {
        PostInstallActionExecutor executor = null;
        if (context.isUpgrade()) {
             executor = new PostInstallActionExecutor(upgradeActionsByVersions, context);
        } else {
             executor = new PostInstallActionExecutor(installActionsByVersions, context);
        }
        executor.execute();

        //schedule an Update dossier scheduler, check if there is an existing scheduled job, else create one
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression
        FROM CronTrigger
        WHERE CronJobDetail.Name = 'Update dossiers' LIMIT 1];
        if (! (cronTriggers.size() > 0)) {
            List<Schedule_Update_Dossier__mdt> scheduleUpdateDossiers = [SELECT cust_connect__Hour__c, Label, MasterLabel, DeveloperName from cust_connect__Schedule_Update_Dossier__mdt LIMIT 1];
            if (scheduleUpdateDossiers.size() > 0) {
                String hour = String.valueOf(scheduleUpdateDossiers[0].Hour__c).substringBefore('.').substringBefore(',');
                String cronexpression = '0 0 '+ hour +' * * ?';
                if (!Test.isRunningTest()) {
                    System.Schedule('Update dossiers', cronexpression, new cust_connect.UpdateDossierBatchScheduler());
                }
            }
        }
    }

}