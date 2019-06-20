/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public without sharing class BusinessDuplicateService {

    public static Boolean checkDossier(String dossierNumber, String establishmentNumber){
        return newInstance().checkDossier(dossierNumber, establishmentNumber);
    }

    public static IBusinessDuplicateService newInstance() {
        return (IBusinessDuplicateService) Application.Service.newInstance(IBusinessDuplicateService.class);
    }

}