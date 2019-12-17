/**
 * Created by jaapbranderhorst on 2019-06-23.
 */

public inherited sharing class CheckDuplicateDossierResponse {

    public String dossierAndEstablishmentNumber { get; set; }
    public Business_Dossier__c dossierFound { get; set;}

    public CheckDuplicateDossierResponse(String dossierNumber, String establishmentNumber, Business_Dossier__c dossierFound) {
        this.dossierAndEstablishmentNumber = dossierNumber + establishmentNumber;
        this.dossierFound = dossierFound;
    }

}