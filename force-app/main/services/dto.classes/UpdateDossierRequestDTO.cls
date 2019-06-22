/**
 * Created by jaapbranderhorst on 2019-06-22.
 */

public with sharing class UpdateDossierRequestDTO {

    public DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier { get; set; }
    public Business_Dossier__c dossierDB { get; set; }

    public UpdateDossierRequestDTO(DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier, Business_Dossier__c dossierDB) {
        this.dataVendorDossier = dataVendorDossier;
        this.dossierDB = dossierDB;
    }

}