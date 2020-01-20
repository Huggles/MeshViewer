/**
 * Created by jaapbranderhorst on 2019-06-21.
 */

public inherited sharing class InsertAccountResponseDTO {

    public DutchBusinessWsdl.DutchBusinessDossierV3 dossier { get; set; }
    public Account account { get; set;}

    public InsertAccountResponseDTO(DutchBusinessWsdl.DutchBusinessDossierV3 dossier, Account account) {
        this.account = account;
        this.dossier = dossier;
    }

}