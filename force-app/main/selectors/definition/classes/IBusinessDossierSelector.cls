public interface IBusinessDossierSelector extends fflib_ISObjectSelector {
    List<Dutch_Business_Dossier__c> selectByDossierNumber(set<String> dossierNumSet);
}
