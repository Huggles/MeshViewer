public interface IBusinessDossierSelector extends fflib_ISObjectSelector {
    List<Business_Dossier__c> selectByDossierNumber(set<String> dossierNumSet);
    List<Business_Dossier__c> selectByDossierNumbers(set<String> dossierNumSet, set<String> establishmentNumSet);
    List<Business_Dossier__c> selectById(set<Id> dosserIdSet);
}