public with sharing class BusinessService {

    public static List<SearchForDossiersResultDto> searchForDossiers(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search) {
        return newInstance().searchForDossiers(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search);
    }

//    public static DutchBusinessWsdl.DutchBusinessGetDossierResponse getDossier(String dossierNumber, String establishmentNumber){
//        return newInstance().getDossier(dossierNumber, establishmentNumber);
//    }

//    public static List<InsertAccountResponseDTO> insertAccount(List<DutchBusinessWsdl.DutchBusinessGetDossierResponse> dataVendorDossiers) {
//        return newInstance().insertAccount(dataVendorDossiers);
//    }

    public static Boolean deleteDossier(Id accountId){
        return newInstance().deleteDossier(accountId);
    }

//    public static Business_Dossier__c selectDossier(Id dossierId){
//        return newInstance().selectDossier(dossierId);
//    }

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
