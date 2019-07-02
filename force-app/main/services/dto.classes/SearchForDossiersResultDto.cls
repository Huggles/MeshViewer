/**
 * Created by jaapbranderhorst on 2019-06-30.
 */

public with sharing class SearchForDossiersResultDto {
    @AuraEnabled public String dossier_number { get; set; }
    @AuraEnabled public String establishment_number { get; set; }
    @AuraEnabled public String name { get; set; }
    @AuraEnabled public String match_type { get; set; }
    @AuraEnabled public String establishment_city { get; set; }
    @AuraEnabled public String establishment_street { get; set; }
    @AuraEnabled public String correspondence_city { get; set; }
    @AuraEnabled public String correspondence_street { get; set; }
    @AuraEnabled public Boolean indication_economically_active { get; set; }
    
    public SearchForDossiersResultDto(DutchBusinessWsdl.DutchBusinessReferenceV2 dutchBusinessReferenceV2) {
        dossier_number = dutchBusinessReferenceV2.dossier_number;
        establishment_number = dutchBusinessReferenceV2.establishment_number;
        name = dutchBusinessReferenceV2.name;
        match_type = dutchBusinessReferenceV2.match_type;
        establishment_city = dutchBusinessReferenceV2.establishment_city;
        establishment_street = dutchBusinessReferenceV2.establishment_street;
        correspondence_city = dutchBusinessReferenceV2.correspondence_city;
        correspondence_street = dutchBusinessReferenceV2.correspondence_street;
        indication_economically_active = dutchBusinessReferenceV2.indication_economically_active;
    }
}