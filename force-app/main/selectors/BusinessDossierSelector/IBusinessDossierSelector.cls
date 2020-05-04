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

    /**
     * Selects all dossiers with the same vat number
     *
     * @param vatNumber
     *
     * @return a list with the found dossiers (empty if none have been found)
     */
    List<Business_Dossier__c> selectByVatNumber(String vatNumber, Boolean enforceFLS);

    /**
     * Selects all dossiers with the same credit safe id
     *
     * @param creditSafeId
     *
     * @return a list with the found dossiers (empty if none have been found)
     */
    List<Business_Dossier__c> selectByCreditSafeId(String creditSafeId, Boolean enforceFLS);

    List<Business_Dossier__c> selectById(set<Id> dosserIdSet);

}
