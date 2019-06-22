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

    // TODO: can potentially be removed
    /**
     * Retrieves the dossier from the backend using the Salesforce Id of the dossier
     *
     * @param dossierId
     *
     * @return
     */
    Business_Dossier__c selectDossier(Id dossierId);

    // TODO: replace by update (we already have insert and upserting is difficult with the fflib framework)
    /**
     * Inserts a dossier in backend DTO format into the DB and returns the SOBject. Bulkified
     *
     * @param InsertDossierRequestDTOS
     *
     * @return
     */
    List<Object> upsertDossier(Business_Dossier__c dossier);

    /**
     * Requests the VAT number
     *
     * @param dossierNumber
     *
     * @return
     */
    DutchBusinessDto.DutchBusinessVatNumber requestVAT(String dossierNumber);


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
