public interface IBusinessService {
    Account getDossierAccount(String dossierNum);
    //Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork);
    //Business_Dossier__c saveDutchBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork);
    List<DutchBusinessDto.DutchBusinessReference> searchForDossiers(DutchBusinessDto.dutchBusinessSearchParametersRequest searchParams);
    DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber, String establishmentNumber);
    String updateAccountDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier);
    list<Object> upsertAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId);
    Boolean deleteDossier(Id accountId);
    Business_Dossier__c selectDossier(Id dossierId);
    List<Object> upsertDossier(Business_Dossier__c dossier);
    DutchBusinessDto.DutchBusinessVatNumber requestVAT(String dossierNumber);

    /**
     * Inserts a dossier in backend DTO format into the DB and returns the SOBject. Bulkified
     *
     * @param InsertDossierRequestDTOS
     *
     * @return
     */
    List<Business_Dossier__c> insertDossier(List<InsertDossierRequestDTO> InsertDossierRequestDTOS);

    //Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork);
    //list<String> checkForAccountDuplicates(Account acc);
}
