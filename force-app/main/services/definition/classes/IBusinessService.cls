public interface IBusinessService {
    // Account getDossierAccount(String dossierNum);
    //Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork);
    //Business_Dossier__c saveDutchBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork);

    // TODO: move the searchparams to its own DTO to remove the dependency between the datavendor and the frontend
    /**
     * Searches for dossiers based on the given params.
     *
     * @param searchParams
     *
     * @return
     */
    List<DutchBusinessDto.DutchBusinessReference> searchForDossiers(DutchBusinessDto.dutchBusinessSearchParametersRequest searchParams);

    /**
     * Retrieves the requested dossier from the backend.
     *
     * @param dossierNumber
     * @param establishmentNumber
     *
     * @return
     */
    DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber, String establishmentNumber);

//     String updateAccountDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier);
//    List<Object> upsertAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId);

    /**
     * Deletes the dossier related to the given account id
     *
     * @param accountId
     *
     * @return
     */
    Boolean deleteDossier(Id accountId);

    /**
     * Retrieves the dossier from the backend using the Salesforce Id of the dossier
     *
     * @param dossierId
     *
     * @return
     */
    Business_Dossier__c selectDossier(Id dossierId);

    /**
     * Updates a given set of dossiers with the data from the backend. Used in the nightly update function
     *
     * @param updateDossierRequestDTOS
     *
     * @return
     */
    List<Business_Dossier__c> updateDossiersWithDataVendorData(List<UpdateDossierRequestDTO> updateDossierRequestDTOS);

    // TODO: replace by update (we already have insert and upserting is difficult with the fflib framework)
    /**
     * Upserts a dossier
     *
     * @param dossier
     *
     * @return
     */
    List<Object> upsertDossier(Business_Dossier__c dossier);

    /**
     * Sets the vat number on the dossier with the given dossiernumber. Requests the vat number based on the dossier number. If a dossier in the database with the same dossier number but
     * with a different establishment number already has a Vat number that number is returned. Otherwise the backend will
     * be queried. If no vat number is found a CCNoVatException will be thrown. Else the vat number is set on the db and the record is updated.
     *
     * @param dossierId
     *
     * @return the updated dossier
     */
     Business_Dossier__c setVatNumber(Id dossierId);

    /**
     * Inserts data coming from the data vendor as new dossiers into the db
     *
     * @param InsertDossierRequestDTOS
     *
     * @return
     */
    List<Business_Dossier__c> insertDossier(List<InsertDossierRequestDTO> InsertDossierRequestDTOS);

    //Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork);
    //list<String> checkForAccountDuplicates(Account acc);

    /**
     * Creates new accounts and inserts them into the DB based on the given dossiers coming from the datavendor. Returns the created accounts.
     *
     * @param dataVendorDossiers
     *
     * @return
     */
    List<InsertAccountResponseDTO> insertAccount(List<DutchBusinessDto.DutchBusinessGetDossierResponse> dataVendorDossiers);
}
