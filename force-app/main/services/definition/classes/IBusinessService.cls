public interface IBusinessService {

    /**
     * Deletes the dossier with the given id with all related objects
     *
     * @param dossierId
     *
     */
    void deleteDossier(Id dossierId);

}
