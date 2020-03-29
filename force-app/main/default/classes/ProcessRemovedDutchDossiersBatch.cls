/**
 * Created by jaapbranderhorst on 03/02/2020.
 */

/**
 * Batch class to remove dutch business dossiers.
 */
public without sharing class ProcessRemovedDutchDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts  {

    @TestVisible
    private static final List<String> UPDATE_TYPES = new List<String>{'Removed'};

    public class RemovedDossiersIterable implements Iterable<Business_Dossier__c> {

        public Iterator<Business_Dossier__c> iterator() {
            return new UpdatedDossiersIterator(UPDATE_TYPES);
        }
    }

    public Iterable<Business_Dossier__c> start(Database.BatchableContext context) {
        RemovedDossiersIterable iter = null;
        try {
            iter = new RemovedDossiersIterable();
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            if (!Test.isRunningTest()) // since it is in a third asynchronous thread the Apex testing framework is not able to handle the transactions correct when testing, so not throwing it in test situations
                throw ex;
        }
        return iter;
    }

    public void execute(Database.BatchableContext context, List<Business_Dossier__c> dossiersRemoved) {
        try {
            DutchBusinessService.processRemovedDutchDossiers(dossiersRemoved);
        }
        catch(Exception ex) {
            ErrorLogUtil.logException(ex, true);
            if (!Test.isRunningTest()) // since it is in a third asynchronous thread the Apex testing framework is not able to handle the transactions correct when testing, so not throwing it in test situations
                throw ex;
        }
    }

    public void finish(Database.BatchableContext context) {
    }

}