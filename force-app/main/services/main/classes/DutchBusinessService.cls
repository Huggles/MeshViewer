public with sharing class DutchBusinessService {


    public static Account getDossierAccount(String dossierNum){
        return newInstance().getDossierAccount(dossierNum);
    }

    public static Dutch_Business_Dossier__c saveDutchBusinessDossierUow(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account acc, fflib_ISObjectUnitOfWork unitOfWork){
        return newInstance().saveDutchBusinessDossierUow(dossier, acc, unitOfWork);
    }

    public static List<DutchBusinessDto.DutchBusinessReference> searchForDossiers(DutchBusinessDto.dutchBusinessSearchParametersRequest searchParams){
        return newInstance().searchForDossiers(searchParams);
    }

    public static String updateAccountDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier){ // was void before. not tyoo logical to return dossier Id from this method. Cut the corner to both get dossierId for  controller and Not research how to handle void methods  with this framework
        return newInstance().updateAccountDossier(dossier);
    }

    public static DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber){
        return newInstance().getDossier(dossierNumber);
    }

    public static boolean createUpdateAccountAndDossier(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){
        return newInstance().createUpdateAccountAndDossier(dossier, accountId);
    }

    public static IDutchBusinessService newInstance() {
        return (IDutchBusinessService) Application.Service.newInstance(IDutchBusinessService.class);
    }
}
