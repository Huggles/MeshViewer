/**
 * Created by jaapbranderhorst on 03/02/2020.
 */

/**
 * Batch class to remove dutch business dossiers.
 */
public without sharing class ProcessRemovedDutchDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts, Database.Stateful {

    public List<Exception> exceptions = new List<Exception>();

    @TestVisible
    private static final List<String> UPDATE_TYPES = new List<String>{'Removed'};

    public class RemovedDossiersIterable implements Iterable<Business_Dossier__c> {
        public ProcessRemovedDutchDossiersBatch processRemovedDutchDossiersBatchInstance;
        public RemovedDossiersIterable(ProcessRemovedDutchDossiersBatch processRemovedDutchDossiersBatch) {
            processRemovedDutchDossiersBatchInstance = processRemovedDutchDossiersBatch;
        }
        public Iterator<Business_Dossier__c> iterator() {
            return new UpdatedDossiersIterator(UPDATE_TYPES, null, processRemovedDutchDossiersBatchInstance);
        }
    }

    public Iterable<Business_Dossier__c> start(Database.BatchableContext context) {
        return new RemovedDossiersIterable(this);
    }

    public void execute(Database.BatchableContext context, List<Business_Dossier__c> dossiersRemoved) {
        try {
            DutchBusinessService.processRemovedDutchDossiers(dossiersRemoved);
        }
        catch(Exception e) {
            exceptions.add(e);
        }
    }

    public void finish(Database.BatchableContext context) {
        for (Exception e : exceptions) {
            ErrorLogUtil.logException(e, true);
        }
    }

}