/**
 * Created by tejaswinidandi on 2019-07-19.
 */

public with sharing class UpdateDossierReferenceDTO {

    public String dossier_number { get; set; }
    public String establishment_number { get; set; }
    public List<String> update_types {get; set;}
    public Integer numPages {get; set;}

    public UpdateDossierReferenceDTO(DutchBusinessWsdl.DutchBusinessUpdateReference updateReference, Integer numPages){
        this.dossier_number = updateReference.dossier_number;
        this.establishment_number = updateReference.establishment_number;
        this.update_types = new List<String>();
        this.update_types.addAll(updateReference.update_types.item);
        this.numPages = numPages;
    }

}