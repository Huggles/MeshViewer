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

    /**
     * Deletes the dossier with the given id with all related objects
     *
     * @param dossierId
     *
     */
    void deleteDossier(Id dossierId);

    /**
     * Inserts a single dossier + account into the DB found through the search function (so based on the dossier number and establishment number).
     * If the dossier is already there, just returns the dossier with a flag it already existed. If the account already exists, just reuses it.
     * If more than one duplicate account exist, throws a CCDuplicateException. This method is synchronous so only one dossier
     * can be created since the datavendor only allows one fetch per call
     *
     * @param creditSafeId The unique id of the record in credit safe
     * @param dossierNumber The Chamber of Commerce number in the Netherlands. Used for Company INfo
     * @param establishmentNumber The establishment number used for Company.info. Unique combined with dossier number
     * @param accountId The id of the account this should be related to
     *
     * @return
     */
    InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromDataVendorData(String creditSafeId, String dossierNumber, String establishmentNumber, String vendor, Id accountId);







}
