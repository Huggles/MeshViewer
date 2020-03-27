/**
 * Created by tejaswinidandi on 2019-07-19.
 */

public without sharing class UpdateDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts, Database.Stateful {

    public List<Exception> exceptions = new List<Exception>();

    @TestVisible
    private static final List<String> UPDATE_TYPES = new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress', 'Contact',
            'Activity', 'Personnel', 'FinancialStatus', 'Status', 'Branch', 'ImportExport', 'ContactPerson', 'Capital',
            'SubscriptionDates', 'New', 'Establishment', 'RSIN', 'Tradenames'};

    public class UpdatedDossiersIterable implements Iterable<Business_Dossier__c> {
        UpdateDossiersBatch updateDossiersBatchInstance;
        public UpdatedDossiersIterable(UpdateDossiersBatch updateDossiersBatch){
            updateDossiersBatchInstance = updateDossiersBatch;
        }
        public Iterator<Business_Dossier__c> iterator() {
            return new UpdatedDossiersIterator(UPDATE_TYPES, updateDossiersBatchInstance, null);
        }
    }

    public Iterable<Business_Dossier__c> start(Database.BatchableContext context) {
        return new UpdatedDossiersIterable(this);
    }

    public void execute(Database.BatchableContext context, List<Business_Dossier__c> dossiersToUpdate) {
        try {
            DutchBusinessService.updateDossiersWithVendorData(dossiersToUpdate);
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