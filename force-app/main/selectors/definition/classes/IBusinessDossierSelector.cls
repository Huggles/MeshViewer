public interface IBusinessDossierSelector extends fflib_ISObjectSelector {
    List<Dutch_Business_Dossier__c> selectByDossierNumber(set<String> dossierNumSet);
    List<Dutch_Business_Dossier__c> selectById(set<Id> dosserIdSet);
}
