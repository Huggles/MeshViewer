public with sharing class BusinessService {

    public static List<SearchForDossiersResultDto> searchForDossiers(String country, String trade_name, String registration_number, String vat_number, String city, String street, String postcode, Integer house_number, String house_number_addition, String province, String telephone_number, String domain_name) {
        return newInstance().searchForDossiers(country, trade_name, registration_number, vat_number, city, street, postcode, house_number, house_number_addition, province, telephone_number, domain_name);
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
