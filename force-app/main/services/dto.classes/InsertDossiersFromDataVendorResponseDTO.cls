/**
 * Created by jaapbranderhorst on 2019-06-23.
 */

public inherited sharing class InsertDossiersFromDataVendorResponseDTO {

    @AuraEnabled
    public Business_Dossier__c dossier { get; private set; }

    @AuraEnabled
    public Boolean dossierExisted { get; private set; }

    public InsertDossiersFromDataVendorResponseDTO(Business_Dossier__c dossier, Boolean dossierExisted) {
        this.dossier = dossier;
        this.dossierExisted = dossierExisted;
    }

}