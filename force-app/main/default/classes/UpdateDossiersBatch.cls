/**
 * Created by tejaswinidandi on 2019-07-19.
 */

public without sharing class UpdateDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts, Database.Stateful{

    private Integer pageNr = 1;
    private Integer numPages;

    @TestVisible
    private static final List<String> UPDATE_TYPES = new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress', 'Contact',
            'Activity', 'Personnel', 'FinancialStatus', 'Status', 'Branch', 'ImportExport', 'ContactPerson', 'Capital',
            'SubscriptionDates', 'New', 'Establishment', 'RSIN', 'Tradenames'};

    public class UpdatedDossiersIterable implements Iterable<Business_Dossier__c> {
        public Iterator<Business_Dossier__c> iterator() {
            return new UpdatedDossiersIterator(UPDATE_TYPES);
        }
    }

    /**
     * FIX: JB: why so much functionality in the start of the batch? This is at least double code
     * JB: this code is wrong. It goes over the first page of ALL the dossiers changed since yesterday in the Chamber of Commerce. Then it maps that to the dossiers in Salesforce
     * This will miss dossiers (because only the first page is hit)
     * It also fetches any and all dossiers that have changed. So not only the dossiers that have been requested by the user. --> apparently this is due to CI
     *
     * JB: the start method should return an iterator of changed dossiers that need to be processed OR a List of business dossiers (inside of Salesforce) that need to be updated.
     * The issue with the latter is that in large orgs we might hit the callout limit
     * (because we need to call dutchBusinessUpdateGetDossiers for every page and there can be more than 100 for large customers and)
     * Also we can run into heap size problems with a List.
     *
     * The fix here is:
     * Move this to a iterator. Split the batch for remove and update functionality.
     *
     *
     */

    public Iterable<Business_Dossier__c> start(Database.BatchableContext context) {
        return new UpdatedDossiersIterable();
    }

    public void execute(Database.BatchableContext context, List<Business_Dossier__c> dossiersToUpdate) {
        BusinessService.updateDossiersWithVendorData(dossiersToUpdate);
    }

    public void finish(Database.BatchableContext context) {
    }

}