public interface IBusinessService {

    /**
     * Deletes the dossier with the given id with all related objects
     *
     * @param dossierId
     * @param checkPermissions true if permissions need to be checked
     *
     */
     void deleteDossier(Id dossierId, Boolean checkPermissions);

    /**
     * Gets a map with all possible country names/country codes the user has access to to search for organisations
     * @return a map with as key the name of the country as defined in ISO 3166 translated to the users language and as value the alpha 2 country code
     */
    Map<String, String> getCountryOptionsForBusinessSearch();


    /**
     * Gets a list of all duplicate business dossiers, based on dossier number and establishment number.
     * @return a list of all duplicate business dossiers.
     */
    List<Business_Dossier__c> findDuplicateDossiersByDossierAndEstablishmentNumber(List<String> dossierNumbers, List<String> establishmentNumbers);


}
