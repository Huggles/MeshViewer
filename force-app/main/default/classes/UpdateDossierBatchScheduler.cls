/**
 * Created by tejaswinidandi on 2019-08-12.
 */

global with sharing class UpdateDossierBatchScheduler implements Schedulable{
    //execute batchable
    public void execute(SchedulableContext sc) {
        Database.ExecuteBatch(new UpdateDossiersBatch(), 50);
    }
}