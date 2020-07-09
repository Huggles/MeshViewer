public inherited sharing class BusinessService {

    /**
     * Deletes the dossier with the given id with all related objects
     *
     * @param dossierId
     *
     */
    public static void deleteDossier(Id dossierId, Boolean checkPermissions) {
        newInstance().deleteDossier(dossierId, checkPermissions);
    }

    public static Map<String, String> getCountryOptionsForBusinessSearch() {
        return newInstance().getCountryOptionsForBusinessSearch();
    }

    public static List<Business_Dossier__c> findDuplicateDossiersByDossierAndEstablishmentNumber(List<String> dossierNumbers, List<String> establishmentNumbers){
        return newInstance().findDuplicateDossiersByDossierAndEstablishmentNumber(dossierNumbers, establishmentNumbers);
    }

    public static IBusinessService newInstance() {
        return (IBusinessService) Application.Service.newInstance(IBusinessService.class);
    }




}
