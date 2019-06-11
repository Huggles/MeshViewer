public interface IDossierAddressSelector extends fflib_ISObjectSelector {
    List<Dossier_Address__c> selectByDossierNumber(set<String> dossierNumSet);
    List<Dossier_Address__c> selectById(set<Id> addressIdSet);
}
