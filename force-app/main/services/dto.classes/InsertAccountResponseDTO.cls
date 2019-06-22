/**
 * Created by jaapbranderhorst on 2019-06-21.
 */

public with sharing class InsertAccountResponseDTO {

    public DutchBusinessDto.DutchBusinessGetDossierResponse dossier { get; set; }
    public Account account { get; set;}

    public InsertAccountResponseDTO(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, Account account) {
        this.account = account;
        this.dossier = dossier;
    }

}