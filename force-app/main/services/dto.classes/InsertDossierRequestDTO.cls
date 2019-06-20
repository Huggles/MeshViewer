/**
 * Created by jaapbranderhorst on 2019-06-20.
 */

public with sharing class InsertDossierRequestDTO {

    public DutchBusinessDto.DutchBusinessGetDossierResponse dossier {
        get; set;
    }

    public Id accountId { get; set; }

}