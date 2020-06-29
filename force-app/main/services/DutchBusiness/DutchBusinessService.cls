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

    public static List<Business_Dossier__c> searchForDutchDossiersSObject(String dossier_number, String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search) {
        return newInstance().searchForDutchDossiersSObject(dossier_number, trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search);
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

    /**
     * Reads the dossiers with the given ids from the DB
     *
     * @param ids
     *
     * @return
     */
    public static List<Business_Dossier__c> getDossiersById(Set<Id> ids) {
        return newInstance().getDossiersById(ids);
    }

    /**
     * Stores the given dossiers in the database. If no id is present inserts the dossiers, otherwise updates them.
     *
     * @param dossiers the dossiers to be stored
     * @param unitOfWork if null a new uow will be created and used to do the work
     */
    public static void storeDossiers(List<Business_Dossier__c> dossiers, fflib_ISObjectUnitOfWork unitOfWork) {
        newInstance().storeDossiers(dossiers, unitOfWork);
    }

    public static Object getExtractHistory(String dossier_number, Date start_date, Date end_date){
        //TODO: This function should not return the WSDL object, but a Salesforce sObject. The data model for this is NYI.
        DutchBusinessWsdl.DutchBusinessExtractHistory dutchBusinessExtractHistory = newInstance().getExtractHistory(dossier_number, start_date, end_date);
        return dutchBusinessExtractHistory;
    }

    public static  List<Business_Position__c> getPositions(String dossier_number, Id dossier_record_id){
        return newInstance().getPositions(dossier_number, dossier_record_id);
    }

    public static IDutchBusinessService newInstance() {
        return (IDutchBusinessService) Application.Service.newInstance(IDutchBusinessService.class);
    }
}