/**
 * Created by jaapbranderhorst on 2019-06-22.
 */

public with sharing class UpdateDossierRequestDTO {

    public DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier { get; private set; }
    public Business_Dossier__c dossierDB { get; private set; }

    public UpdateDossierRequestDTO(DutchBusinessDto.DutchBusinessGetDossierResponse dataVendorDossier, Business_Dossier__c dossierDB) {
        this.dataVendorDossier = dataVendorDossier;
        this.dossierDB = dossierDB;
    }

}