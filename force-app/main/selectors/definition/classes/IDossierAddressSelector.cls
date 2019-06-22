public interface IDossierAddressSelector extends fflib_ISObjectSelector {
    List<Dossier_Address__c> selectByDossierId(set<Id> dossierIdSet);
}
