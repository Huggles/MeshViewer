/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public interface IBusinessDuplicateService {

    /**
     * Checks if the dossier with the given dossier number and establishment number exists in the org. Returns true if it exists.
     * Does not take into account sharing to ensure no duplicates are created.
     *
     * @param dossierNumber
     * @param establishmentNumber
     *
     * @return
     */
    Boolean checkDossier(String dossierNumber, String establishmentNumber);

}