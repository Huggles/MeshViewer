public inherited sharing class BusinessService {

    /**
     * Deletes the dossier with the given id with all related objects
     *
     * @param dossierId
     *
     */
    public static Boolean deleteDossier(Id dossierId, Boolean checkPermissions) {
        return newInstance().deleteDossier(dossierId, checkPermissions);
    }

    public static IBusinessService newInstance() {
        return (IBusinessService) Application.Service.newInstance(IBusinessService.class);
    }


}
