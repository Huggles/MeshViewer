/**
 * Created by tejaswinidandi on 2019-07-19.
 */

public without sharing class UpdateDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts {

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
            return new UpdatedDossiersIterator(UPDATE_TYPES);
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
            ErrorLogUtil.logException(e, true);
        }
    }

    public void finish(Database.BatchableContext context) {
    }

}