public interface IBusinessService {

    /**
     * Searches for dossiers with the given params
     *
     * @param country the country in ISO notation. Currently supports NL, GB, IE, DE, FR, SE, BE
     * @param trade_name the name of the company we are searching for
     * @param registration_number the number under which the company has been registered. Chamber of commerce number in the Netherlands
     * @param vat_number the vat number we search for
     * @param city
     * @param street
     * @param postcode
     * @param house_number
     * @param house_number_addition
     * @param province
     * @param telephone_number
     * @param domain_name
     *
     * @return
     */
    List<SearchForDossiersResultDto> searchForDossiers(String country, String trade_name, String registration_number, String vat_number, String city, String street, String postcode, Integer house_number, String house_number_addition, String province, String telephone_number, String domain_name);
//    /**
//     * Retrieves the requested dossier from the backend.
//     *
//     * @param dossierNumber
//     * @param establishmentNumber
//     *
//     * @return
//     */
//    DutchBusinessWsdl.DutchBusinessGetDossierResponse getDossier(String dossierNumber, String establishmentNumber);

//     String updateAccountDossier(DutchBusinessWsdl.DutchBusinessGetDossierResponse dossier);
//    List<Object> upsertAccountAndDossier(DutchBusinessWsdl.DutchBusinessGetDossierResponse dossier, String accountId);

    /**
     * Deletes the dossier related to the given account id
     *
     * @param accountId
     *
     * @return
     */
    Boolean deleteDossier(Id accountId);

//    /**
//     * Retrieves the dossier from the backend using the Salesforce Id of the dossier
//     *
//     * @param dossierId
//     *
//     * @return
//     */
//    Business_Dossier__c selectDossier(Id dossierId);

    /**
     * Updates a given set of dossiers with the data from the backend. Used in the nightly update function
     *
     * @param updateDossierRequestDTOS
     *
     * @return
     */
    List<Business_Dossier__c> updateDossiersWithDataVendorData(List<UpdateDossierRequestDTO> updateDossierRequestDTOS);

//    // TODO: replace by update (we already have insert and upserting is difficult with the fflib framework)
//    /**
//     * Upserts a dossier
//     *
//     * @param dossier
//     *
//     * @return
//     */
//    List<Object> upsertDossier(Business_Dossier__c dossier);

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

    //Account createAccountForDossier(String accountId, DutchBusinessWsdl.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork);
    //list<String> checkForAccountDuplicates(Account acc);

//    /**
//     * Creates new accounts and inserts them into the DB based on the given dossiers coming from the datavendor. Returns the created accounts.
//     *
//     * @param dataVendorDossiers
//     *
//     * @return
//     */
//    List<InsertAccountResponseDTO> insertAccount(List<DutchBusinessWsdl.DutchBusinessGetDossierResponse> dataVendorDossiers);

    /**
     * Inserts a single dossier + account into the DB found through the search function (so based on the dossier number and establishment number).
     * If the dossier is already there, just returns the dossier with a flag it already existed. If the account already exists, just reuses it.
     * If more than one duplicate account exist, throws a CCDuplicateException. This method is synchronous so only one dossier
     * can be created since the datavendor only allows one fetch per call
     *
     * @param dossierNumber
     * @param establishmentNumber
     * @param accountId
     *
     * @return
     */
    InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromDataVendorData(String dossierNumber, String establishmentNumber, Id accountId);
}
