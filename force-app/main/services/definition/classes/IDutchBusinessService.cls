/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

public interface IDutchBusinessService {

    /**
      * Retrieves all Dutch Business Dossiers that have been updated since a certain date. Paginated. Supply the right CI page nr. to get the right results
      *
      * @param pageNr
      * @param updateTypes
      * @param changedSince
      *
      * @return
      */
    List<UpdateDossierReferenceDTO> getDutchBusinessUpdatedDossiersSince(Integer pageNr, List<String> updateTypes, Date changedSince);

    /**
     * Updates every dossier given with the newest data from the CI backend.
     *
     * @param dossiersToUpdate the dossiers to update
     */
    void updateDossiersWithVendorData(List<Business_Dossier__c> dossiersToUpdate);

    /**
     * Processes the dutch business dossiers that have been removed from the CI backend
     *
     * @param removedDossiers
     */
    void processRemovedDutchDossiers(List<Business_Dossier__c> removedDossiers);

    /**
     * Searches for dutch dossiers using the given parameters.
     * TODO: replace with method that returns SObjects
     *
     * @param trade_name
     * @param city
     * @param street
     * @param postcode
     * @param house_number
     * @param house_number_addition
     * @param telephone_number
     * @param domain_name
     *
     * @return
     */
    List<SearchForDossiersResultDto> searchForDutchDossiers(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name);

    /**
     * Searches for dutch dossiers using the given parameters.
     * TODO: replace searchForDutchDossiers with this
     *
     * @param dossier_number
     * @param trade_name
     * @param city
     * @param street
     * @param postcode
     * @param house_number
     * @param house_number_addition
     * @param telephone_number
     * @param domain_name
     *
     * @return
     */
    List<Business_Dossier__c> searchForDutchDossiersSObject(String dossier_number, String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name);


    /**
     * Sets the vat number on the dutch business dossier with the given dossiernumber. Requests the vat number based on the dossier number. If a dossier in the database with the same dossier number but
     * with a different establishment number already has a Vat number that number is returned. Otherwise the backend will
     * be queried. If no vat number is found a CCNoVatException will be thrown. Else the vat number is set on the db and the record is updated.
     *
     * @param dossierId
     *
     * @return the updated dossier
     */
    Business_Dossier__c setVatNumber(Id dossierId);

    /**
     * Inserts a dutch dossier and relate it to the account id.
     *
     * @param dossierNumber
     * @param establishmentNumber
     * @param accountId
     * @param unitOfWork
     *
     * @return
     */
    InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromCompanyInfo(String dossierNumber, String establishmentNumber, Id accountId, fflib_ISObjectUnitOfWork unitOfWork );

    /**
     * Fetches the dutch business dossier with the given dossier number and establishment number and creates it in the database (incl. any related records)
     * If getVAT is true, also enriches the dossier with the VAT number (if available) before inserting it in the database.
     *
     * @param dossierNumber
     * @param establishmentNumber
     * @param getVAT
     *
     * @return the newly created dossier
     */
    Business_Dossier__c createDutchDossier(String dossierNumber, String establishmentNumber, Boolean getVAT);

    /**
     * Updates a given Dutch business dossier with the VAT number from the CI backend.
     * Sets the flag No_VAT__c to true if no VAT number is known in the backend.
     * Does not update it in the backend.
     *
     * @param dossier the dossier to be updated
     *
     * @return the updated dossier
     */
    Business_Dossier__c updateBusinessDossierWithVATNumber(Business_Dossier__c dossier);

    /**
     * Reads the dossiers with the given ids from the DB
     *
     * @param ids
     *
     * @return
     */
    List<Business_Dossier__c> getDossiersById(Set<Id> ids);

    /**
     * Stores the given dossiers in the database. If no id is present inserts the dossiers, otherwise updates them.
     *
     * @param dossiers the dossiers to be stored
     * @param unitOfWork if not present a new uow will be created and used to do the work
     */
    void storeDossiers(List<Business_Dossier__c> dossiers, fflib_ISObjectUnitOfWork unitOfWork);
}