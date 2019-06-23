public with sharing class BusinessService {

    public static List<DutchBusinessDto.DutchBusinessReference> searchForDossiers(DutchBusinessDto.dutchBusinessSearchParametersRequest searchParams){
        return newInstance().searchForDossiers(searchParams);
    }

    public static DutchBusinessDto.DutchBusinessGetDossierResponse getDossier(String dossierNumber, String establishmentNumber){
        return newInstance().getDossier(dossierNumber, establishmentNumber);
    }

    public static List<Business_Dossier__c> insertDossier(List<InsertDossierRequestDTO> insertDossierRequestDTOS) {
        return newInstance().insertDossier(insertDossierRequestDTOS);
    }

    public static List<InsertAccountResponseDTO> insertAccount(List<DutchBusinessDto.DutchBusinessGetDossierResponse> dataVendorDossiers) {
        return newInstance().insertAccount(dataVendorDossiers);
    }

    public static Boolean deleteDossier(Id accountId){
        return newInstance().deleteDossier(accountId);
    }

    public static List<Business_Dossier__c> updateDossiersWithDataVendorData(List<UpdateDossierRequestDTO> updateDossierRequestDTOS) {
        return newInstance().updateDossiersWithDataVendorData(updateDossierRequestDTOS);
    }

    public static Business_Dossier__c setVatNumber(String dossierNumber){
        return newInstance().setVatNumber(dossierNumber);
    }

    public static InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromDataVendorData(String dossierNumber, String establishmentNumber, Id accountId) {
        return newInstance().insertSingleDossierFromDataVendorData(dossierNumber, establishmentNumber, accountId);
    }

    public static IBusinessService newInstance() {
        return (IBusinessService) Application.Service.newInstance(IBusinessService.class);
    }


}
