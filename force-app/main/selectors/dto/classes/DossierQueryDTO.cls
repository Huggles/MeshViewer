/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public with sharing class DossierQueryDTO {

    public DossierQueryDTO(String dossierNumber, String establishmentNumber) {
        this.dossierNumber = dossierNumber;
        this.establishmentNumber = establishmentNumber;
    }

    public String dossierNumber {
        get; set;
    }
    public String establishmentNumber {
        get; set;
    }

}