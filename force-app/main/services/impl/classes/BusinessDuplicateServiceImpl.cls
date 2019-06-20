/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public without sharing class BusinessDuplicateServiceImpl implements IBusinessDuplicateService {


    public static Business_Dossier__c checkSingleDuplicateDossier(String dossierNumber, String establishmentNumber) {
        try {
            IBusinessDossierSelector selector = BusinessDossierSelector.newInstance();
            // query needs to run in system context (no FLS). All users should see all dossiers. Done through the permission set
            List<Business_Dossier__c> dossiers = selector.selectByDossierNumbers(new Set<DossierQueryDTO>{
                    new DossierQueryDTO(dossierNumber, establishmentNumber)
            }, false);
            return dossiers.size() > 0 ? dossiers[0] : null;
        } catch (System.Exception ex) {
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception, ex);
        }
    }

}