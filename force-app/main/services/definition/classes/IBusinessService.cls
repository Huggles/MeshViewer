public interface IBusinessService {

    /**
     * Deletes the dossier with the given id with all related objects
     *
     * @param dossierId
     * @param checkPermissions true if permissions need to be checked
     *
     */
     void deleteDossier(Id dossierId, Boolean checkPermissions);

}
