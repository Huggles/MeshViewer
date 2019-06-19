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
    //Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork);
    //list<String> checkForAccountDuplicates(Account acc);

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
