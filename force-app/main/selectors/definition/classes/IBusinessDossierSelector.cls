public interface IBusinessDossierSelector extends fflib_ISObjectSelector {

    List<Business_Dossier__c> selectByDossierNumber(set<String> dossierNumSet, Boolean enforceFLS);
    /**
     * Queries the database based on the given dossierQueryDTOs which combine the dossier number (chamber of commerce) and the establishment number
     *
     * @param dossierQueryDTOS
     *
     * @return
     */
    List<Business_Dossier__c> selectByDossierNumbers(Set<DossierQueryDTO> dossierQueryDTOS, Boolean enforceFLS);
    List<Business_Dossier__c> selectById(set<Id> dosserIdSet);

}
