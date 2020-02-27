/**
 * Created by jaapbranderhorst on 2019-06-30.
 */

public inherited sharing class SearchForDossiersResultDto {
    @AuraEnabled public String vendor { get; set; }
    @AuraEnabled public String creditSafeCountry {get; set; }
    @AuraEnabled public String dossier_number { get; set; } // chamber of commerce number
    @AuraEnabled public String establishment_number { get; set; }
    @AuraEnabled public String name { get; set; }
    @AuraEnabled public String match_type { get; set; }
    @AuraEnabled public String establishment_city { get; set; }
    @AuraEnabled public String establishment_street { get; set; }
    @AuraEnabled public String correspondence_city { get; set; }
    @AuraEnabled public String correspondence_street { get; set; }
    @AuraEnabled public Boolean indication_economically_active { get; set; }
    @AuraEnabled public String phone { get; set; }
    @AuraEnabled public String creditSafeStatus {get; set;}
    @AuraEnabled public List<String> trade_names { get; set; }
    @AuraEnabled public String creditSafeId { get; set; }
    @AuraEnabled public Datetime date_last_account { get; set; }
    @AuraEnabled public Datetime date_last_change { get; set; }
    @AuraEnabled public String office_type { get; set; }
    @AuraEnabled public String establishment_full_address { get; set; }
    @AuraEnabled public String establishment_house_nr { get; set; }
    @AuraEnabled public String establishment_postal_code { get; set; }
    @AuraEnabled public String company_id { get; set; }


    public SearchForDossiersResultDto(DutchBusinessWsdl.DutchBusinessReferenceV2 dutchBusinessReferenceV2) {
        vendor = CustomerConnect.DataVendor.COMPANY_INFO.name();
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

    public SearchForDossiersResultDto(CreditsafeWsdl.CreditsafeCompanyV2 creditsafeCompanyV2) {
        vendor = CustomerConnect.DataVendor.CREDIT_SAFE.name();
        dossier_number = creditsafeCompanyV2.registration_number;
        name = creditsafeCompanyV2.name;
        creditSafeCountry = creditsafeCompanyV2.country;
        CreditsafeWsdl.CreditsafeAddressV2 address = creditsafeCompanyV2.address;
        if (address != null) {
            establishment_city = address.city;
            establishment_full_address = address.full_address;
            establishment_house_nr = address.house_number;
            establishment_postal_code = address.postal_code;
            establishment_street = address.street;
            phone = address.telephone;
        }
        creditSafeStatus = creditsafeCompanyV2.status;
        creditSafeId = creditsafeCompanyV2.creditsafe_number;
        date_last_change = creditsafeCompanyV2.date_last_change;
        date_last_account = creditsafeCompanyV2.date_last_account;
        office_type = creditsafeCompanyV2.office_type;
        trade_names = new List<String>();
        if (creditsafeCompanyV2.trade_names != null && creditsafeCompanyV2.trade_names.item != null) {
            for (String str : creditsafeCompanyV2.trade_names.item) {
                trade_names.add(str);
            }
        }
        company_id = creditsafeCompanyV2.id;
    }
}