/**
 * Created by tejaswinidandi on 2019-07-19.
 */

public without sharing class UpdateDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts {

    @TestVisible
    private static final List<String> UPDATE_TYPES{
        get {
            List<String> updateTypes = new List<String>();
            List<UpdateSettingSelector.UpdateSettingsWrapper> updateSettingsWrappers = UpdateSettingSelector.getUpdateSettings();
            for(UpdateSettingSelector.UpdateSettingsWrapper usw : updateSettingsWrappers){
                updateTypes.add(usw.label);
            }
            return updateTypes;
        }
    }

    public class UpdatedDossiersIterable implements Iterable<Business_Dossier__c> {
        public Iterator<Business_Dossier__c> iterator() {
            return new UpdatedDossiersIterator(UPDATE_TYPES);
        }

    }

    public Iterable<Business_Dossier__c> start(Database.BatchableContext context) {
        UpdatedDossiersIterable iter = null;
        try {
            iter = new UpdatedDossiersIterable();
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            if (!Test.isRunningTest()) // since it is in a third asynchronous thread the Apex testing framework is not able to handle the transactions correct when testing, so not throwing it in test situations
                throw ex;
        }
        return iter;
    }

    public void execute(Database.BatchableContext context, List<Business_Dossier__c> dossiersToUpdate) {
        try {
            DutchBusinessService.updateDossiersWithVendorData(dossiersToUpdate);
        }
        catch(Exception e) {
            ErrorLogUtil.logException(e, true);
            if (!Test.isRunningTest()) // since it is in a third asynchronous thread the Apex testing framework is not able to handle the transactions correct when testing, so not throwing it in test situations
                throw e;
        }
    }

    public void finish(Database.BatchableContext context) {
    }

}