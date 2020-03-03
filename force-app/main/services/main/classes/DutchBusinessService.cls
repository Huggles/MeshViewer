/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

public inherited sharing class DutchBusinessService {

    public static List<UpdateDossierReferenceDTO> getDutchBusinessUpdatedDossiersSince(Integer pageNr, List<String> updateTypes, Date changedSince) {
        return newInstance().getDutchBusinessUpdatedDossiersSince(pageNr, updateTypes, changedSince);
    }

    public static void updateDossiersWithVendorData(List<Business_Dossier__c> dossiersToUpdate) {
        newInstance().updateDossiersWithVendorData(dossiersToUpdate);
    }

    public static void processRemovedDutchDossiers(List<Business_Dossier__c> removedDossiers) {
        newInstance().processRemovedDutchDossiers(removedDossiers);
    }

    public static List<SearchForDossiersResultDto> searchForDutchDossiers(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name) {
        return newInstance().searchForDutchDossiers(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name);
    }

    public static List<Business_Dossier__c> searchForDutchDossiersSObject(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name) {
        return newInstance().searchForDutchDossiersSObject(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name);
    }

    public static Business_Dossier__c setVatNumber(Id dossierId) {
        return newInstance().setVatNumber(dossierId);
    }

    public static InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromCompanyInfo(String dossierNumber, String establishmentNumber, Id accountId, fflib_ISObjectUnitOfWork unitOfWork ) {
        return newInstance().insertSingleDossierFromCompanyInfo(dossierNumber, establishmentNumber, accountId, unitOfWork);
    }

    public static Business_Dossier__c createDutchDossier(String dossierNumber, String establishmentNumber, Boolean getVAT) {
        return newInstance().createDutchDossier(dossierNumber, establishmentNumber, getVAT);
    }

    /**
     * Updates a given Dutch business dossier with the VAT number from the CI backend. Does not update it in the backend.
     *
     * @param dossier the dossier to be updated
     *
     * @return the updated dossier
     */
    public static Business_Dossier__c updateBusinessDossierWithVATNumber(Business_Dossier__c dossier) {
        return newInstance().updateBusinessDossierWithVATNumber(dossier);
    }

    public static IDutchBusinessService newInstance() {
        return (IDutchBusinessService) Application.Service.newInstance(IDutchBusinessService.class);
    }
}