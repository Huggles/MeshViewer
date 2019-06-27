/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public interface IBusinessDuplicateService {

    /**
     * Checks if the the dossier with the given dossier number and establishment number exists in the org. Returns the dossier in the DB if it exists otherwise null. Bulkified
     *
     * @param requests
     *
     * @return
     */
    List<CheckDuplicateDossierResponse> checkForDuplicateDossiers(List<CheckDuplicateDossierRequest> requests);



    /**
     * checks for account duplicates. Return a List with the duplicate accounts if duplicates for the given account exist.
     *
     * @param acc
     *
     * @return
     */
    List<Account> checkForAccountDuplicates(Account acc);

    /**
     * checks if there is a vat number related to dossiers with the given dossiernumber in the database. A dossier number
     *
     * @param dossierNumber
     *
     * @return
     */
    String checkForExistingVatNumberInDB(String dossierNumber);



}