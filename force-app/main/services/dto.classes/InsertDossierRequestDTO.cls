/**
 * Created by jaapbranderhorst on 2019-06-20.
 */

public inherited sharing class InsertDossierRequestDTO {

    public DutchBusinessWsdl.DutchBusinessDossierV3 dossier {
        get; set;
    }

    public Account account { get; set; }

    public InsertDossierRequestDTO(DutchBusinessWsdl.DutchBusinessDossierV3 dossier, Account account) {
        this.dossier = dossier;
        this.account = account;
    }

}