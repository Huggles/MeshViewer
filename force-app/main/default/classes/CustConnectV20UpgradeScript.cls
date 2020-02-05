/**
 * Created by jaapbranderhorst on 04/02/2020.
 */

public without sharing class CustConnectV20UpgradeScript implements IInstallAction {

    @TestVisible
    private final static String UPDATE_DOSSIER_SCHEDULE_NAME = 'Update dossiers';

    public void execute(InstallContext context) {
        // stop the scheduled batch if there is one
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetailId, CronJobDetail.Name, CronExpression FROM CronTrigger WHERE CronJobDetail.Name =: UPDATE_DOSSIER_SCHEDULE_NAME LIMIT 1];
        if (cronTriggers.size() > 0) {
            try {
                System.abortJob(cronTriggers[0].Id);
            } catch (Exception ex) { // silent failure of edge cases where the execution just started or finished and thus the job cannot be aborted any more

            }

        }
    }


}