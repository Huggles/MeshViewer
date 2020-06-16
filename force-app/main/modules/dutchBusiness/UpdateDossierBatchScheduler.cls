/**
 * Created by tejaswinidandi on 2019-08-12.
 */

public inherited sharing class UpdateDossierBatchScheduler implements Schedulable{
    //execute batchable
    public void execute(SchedulableContext sc) {
        Database.ExecuteBatch(new UpdateDossiersBatch(), 50);
    }
}