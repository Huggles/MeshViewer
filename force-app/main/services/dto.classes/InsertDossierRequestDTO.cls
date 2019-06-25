/**
 * Created by jaapbranderhorst on 2019-06-20.
 */

public with sharing class InsertDossierRequestDTO {

    public DutchBusinessDto.DutchBusinessGetDossierResponse dossier {
        get; set;
    }

    public Account account { get; set; }

    public InsertDossierRequestDTO(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account account) {
        this.dossier = dossier;
        this.account = account;
    }

}