/**
 * Created by jaapbranderhorst on 2019-06-22.
 */

public inherited sharing class UpdateDossierRequestDTO {

    public DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier { get; private set; }
    public Business_Dossier__c dossierDB { get; private set; }

    public UpdateDossierRequestDTO(DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier, Business_Dossier__c dossierDB) {
        this.dataVendorDossier = dataVendorDossier;
        this.dossierDB = dossierDB;
    }

}