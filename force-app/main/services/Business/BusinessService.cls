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

    public static IBusinessService newInstance() {
        return (IBusinessService) Application.Service.newInstance(IBusinessService.class);
    }


}
