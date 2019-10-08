/**
 * Created by jaapbranderhorst on 2019-06-23.
 */

public inherited sharing class CheckDuplicateDossierRequest {

    public String dossierNumber { get; private set; }
    public String establishmentNumber {get; private set;}

    public CheckDuplicateDossierRequest(String dossierNumber, String establishmentNumber) {
        this.dossierNumber = dossierNumber;
        this.establishmentNumber = establishmentNumber;
    }

}