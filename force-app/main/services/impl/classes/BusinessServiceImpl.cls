/****************************************************************************************
Author          : Jaap Branderhorst
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/

public inherited sharing class BusinessServiceImpl implements IBusinessService {

    public static final Integer MAX_SEARCH_RESULTS = 1000;

    /**
     * Deletes the dossier with the given id with all related objects
     *
     * @param dossierId
     *
     */
    public Boolean deleteDossier(Id dossierId, Boolean checkPermissions) {
        List<Business_Dossier__c> dossierList = BusinessDossierSelector.newInstance().selectById(new Set<Id>{
                dossierId
        });
        if (dossierList.size() == 1) {
            fflib_ISObjectUnitOfWork unitOfWork = null;
            if (checkPermissions) {
                unitOfWork = Application.UnitOfWork.newInstance(new DMLWithCRUD());
            } else {
                unitOfWork = Application.UnitOfWork.newInstance();
            }
            unitOfWork.registerDeleted(dossierList[0]);
            unitOfWork.commitWork();
            return true;
            // TODO: commented for now. Must be added back when we move to update lists
//            //if dossier is deleted, then remove it from the update list of dossiers on the company.info server
//            WsDutchBusiness.dutchBusinessUpdateRemoveDossier(dossierList[0].Dossier_Number__c, dossierList[0].Establishment_Number__c);
        }
        return false;
    }


}
