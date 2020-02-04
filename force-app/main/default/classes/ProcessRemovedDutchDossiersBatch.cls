/**
 * Created by jaapbranderhorst on 03/02/2020.
 */

/**
 * Batch class to remove dutch business dossiers.
 */
public without sharing class ProcessRemovedDutchDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts, Database.Stateful {

    @TestVisible
    private static final List<String> UPDATE_TYPES = new List<String>{'Removed'};

    public class RemovedDossiersIterable implements Iterable<Business_Dossier__c> {
        public Iterator<Business_Dossier__c> iterator() {
            return new UpdatedDossiersIterator(UPDATE_TYPES);
        }
    }

    public Iterable<Business_Dossier__c> start(Database.BatchableContext context) {
        return new RemovedDossiersIterable();
    }

    public void execute(Database.BatchableContext context, List<Business_Dossier__c> dossiersRemoved) {
        BusinessService.processRemovedDutchDossiers(dossiersRemoved);
    }

    public void finish(Database.BatchableContext context) {
    }

}