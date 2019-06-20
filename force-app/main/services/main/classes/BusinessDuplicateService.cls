/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public without sharing class BusinessDuplicateService {

    public static Business_Dossier__c checkSingleDuplicateDossier(String dossierNumber, String establishmentNumber) {
        return newInstance().checkSingleDuplicateDossier(dossierNumber, establishmentNumber);
    }

    public static IBusinessDuplicateService newInstance() {
        return (IBusinessDuplicateService) Application.Service.newInstance(IBusinessDuplicateService.class);
    }

}