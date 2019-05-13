public interface IDutchBusinessService {
    Account getDossierAccount(String dossierNum);
    //Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork);
    Dutch_Business_Dossier__c saveDutchBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork);
    List<DutchBusinessDto.DutchBusinessReference> searchForDossiers(DutchBusinessDto.dutchBusinessSearchParametersRequest searchParams);
    DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber);
    String updateAccountDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier);
    boolean createUpdateAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId);
    
}