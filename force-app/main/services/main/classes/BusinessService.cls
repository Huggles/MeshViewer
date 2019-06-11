public with sharing class BusinessService {

    public static List<DutchBusinessDto.DutchBusinessReference> searchForDossiers(DutchBusinessDto.dutchBusinessSearchParametersRequest searchParams){
        return newInstance().searchForDossiers(searchParams);
    }

    public static String updateAccountDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier){ // was void before. not tyoo logical to return dossier Id from this method. Cut the corner to both get dossierId for  controller and Not research how to handle void methods  with this framework
        return newInstance().updateAccountDossier(dossier);
    }

    public static DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber){
        return newInstance().getDossier(dossierNumber);
    }

    public static list<Object> upsertAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){
        return newInstance().upsertAccountAndDossier(dossier, accountId);
    }
    public static Account getDossierAccount(String dossierNum){
        return newInstance().getDossierAccount(dossierNum);
    }
    public static Boolean deleteDossier(Id accountId){
        return newInstance().deleteDossier(accountId);
    }
    
    public static Business_Dossier__c selectDossier(Id dossierId){
        return newInstance().selectDossier(dossierId);
    }

    public static List<Object> upsertDossier(Business_Dossier__c dossier){
        return newInstance().upsertDossier(dossier);
    }

    public static DutchBusinessDto.DutchBusinessVatNumber requestVat(String dossierNumber){
        return newInstance().requestVat(dossierNumber);
    }
    /*
    public static Account createAccountForDossier(String accountId, DutchBusinessDto.DutchBusinessGetDossierResponse dossier, fflib_ISObjectUnitOfWork unitOfWork){
        return newInstance().createAccountForDossier(accountId, dossier, unitOfWork);
    }
    public static Business_Dossier__c saveDutchBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork){
        return newInstance().saveDutchBusinessDossierUow(dossier, acc, unitOfWork);
    }
    
    public static list<String> checkForAccountDuplicates(Account acc){
        return newInstance().checkForAccountDuplicates(acc);
    }*/
    public static IBusinessService newInstance() {
        return (IBusinessService) Application.Service.newInstance(IBusinessService.class);
    }
}
