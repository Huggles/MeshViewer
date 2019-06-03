public with sharing class DutchBusinessDto {

    public class DutchBusinessGetDossierRequest {
        public String dossier_number;
        public String establishment_number;
    }
    public class DutchBusinessGetDossierResponse {


        // might need to rethink addresses and some more fields
        @AuraEnabled public list<String> trade_names;
        @AuraEnabled public String dossier_number;
        @AuraEnabled public String establishment_number;
        @AuraEnabled public String main_establishment_number;
        @AuraEnabled public Boolean indication_main_establishment;
        @AuraEnabled public String rsin_number;
        @AuraEnabled public String chamber_number;
        @AuraEnabled public String legal_form_code;
        @AuraEnabled public String legal_form_text;
        @AuraEnabled public String indication_organisation_code;
        @AuraEnabled public String legal_name;
        @AuraEnabled public String trade_name_45;
        @AuraEnabled public String trade_name_full;
        @AuraEnabled public String telephone_number;
        @AuraEnabled public String mobile_number;
        @AuraEnabled public String domain_name;
        @AuraEnabled public String contact_title1;
        @AuraEnabled public String contact_title2;
        @AuraEnabled public String contact_initials;
        @AuraEnabled public String contact_prefix;
        @AuraEnabled public String contact_surname;
        @AuraEnabled public String contact_gender;
        @AuraEnabled public String primary_sbi_code;
        @AuraEnabled public String secondary_sbi_code1;
        @AuraEnabled public String secondary_sbi_code2;
        @AuraEnabled public String primary_sbi_code_text;
        @AuraEnabled public String secondary_sbi_code1_text;
        @AuraEnabled public String secondary_sbi_code2_text;
        @AuraEnabled public Integer personnel;
        @AuraEnabled public Integer class_personnel;
        @AuraEnabled public Integer personnel_fulltime;
        @AuraEnabled public Integer class_personnel_fulltime;
        @AuraEnabled public Integer personnel_ci;
        @AuraEnabled public Integer class_personnel_ci;
        @AuraEnabled public Boolean indication_import;
        @AuraEnabled public Boolean indication_export;
        @AuraEnabled public Boolean indication_economically_active;
        @AuraEnabled public Boolean indication_non_mailing;
        @AuraEnabled public Boolean indication_bankruptcy;
        @AuraEnabled public Boolean indication_dip;
        @AuraEnabled public Long authorized_share_capital;
        @AuraEnabled public String authorized_share_capital_currency;
        @AuraEnabled public Long paid_up_share_capital;
        @AuraEnabled public String paid_up_share_capital_currency;
        @AuraEnabled public Long issued_share_capital;
        @AuraEnabled public String issued_share_capital_currency;
        @AuraEnabled public String annual_financial_statement_summary;
        @AuraEnabled public String insolvencies;
        @AuraEnabled public String sbi_collection;
        @AuraEnabled public String structure;

        @AuraEnabled public String establishment_address_original_address;
        @AuraEnabled public String establishment_address_original_postcode;
        @AuraEnabled public String establishment_address_original_city;
        @AuraEnabled public String establishment_address_original_street;
        @AuraEnabled public Integer establishment_address_original_house_number;
        @AuraEnabled public String establishment_address_original_house_number_addition;
        @AuraEnabled public String establishment_address_original_country;
        @AuraEnabled public String establishment_address_official_address;
        @AuraEnabled public String establishment_address_official_postcode;
        @AuraEnabled public String establishment_address_official_city;
        @AuraEnabled public String establishment_address_official_treet;
        @AuraEnabled public Integer establishment_address_official_house_number;
        @AuraEnabled public String establishment_address_official_house_number_addition;
        @AuraEnabled public String establishment_address_official_country;
        @AuraEnabled public String establishment_address_formatted_address;
        @AuraEnabled public String eestablishment_address_postcode;
        @AuraEnabled public String establishment_address_city;
        @AuraEnabled public String establishment_address_street;
        @AuraEnabled public Integer establishment_address_house_number;
        @AuraEnabled public String establishment_address_house_number_addition;
        @AuraEnabled public String establishment_address_country;

        @AuraEnabled public String correspondence_address_original_address;
        @AuraEnabled public String correspondence_address_original_postcode;
        @AuraEnabled public String correspondence_address_original_city;
        @AuraEnabled public String correspondence_address_original_street;
        @AuraEnabled public Integer correspondence_address_original_house_number;
        @AuraEnabled public String correspondence_address_original_house_number_addition;
        @AuraEnabled public String correspondence_address_original_country;
        @AuraEnabled public String correspondence_address_official_address;
        @AuraEnabled public String correspondence_address_official_postcode;
        @AuraEnabled public String correspondence_address_official_city;
        @AuraEnabled public String correspondence_address_official_treet;
        @AuraEnabled public Integer correspondence_address_official_house_number;
        @AuraEnabled public String correspondence_address_official_house_number_addition;
        @AuraEnabled public String correspondence_address_official_country;
        @AuraEnabled public String correspondence_address_formatted_address;
        @AuraEnabled public String ecorrespondence_address_postcode;
        @AuraEnabled public String correspondence_address_city;
        @AuraEnabled public String correspondence_address_street;
        @AuraEnabled public Integer correspondence_address_house_number;
        @AuraEnabled public String correspondence_address_house_number_addition;
        @AuraEnabled public String correspondence_address_country;
        @AuraEnabled public Date personnel_reference_date;
        @AuraEnabled public Date personnel_ci_reference_date;
        @AuraEnabled public Date founding_date;
        @AuraEnabled public Date discontinuation_date;
        @AuraEnabled public Date continuation_date;
        @AuraEnabled public Date establishment_date;


        // TODO: add 
        // public wwwWebservicesNlSoap.DutchBusinessInsolvencyArray insolvencies;
        //        public wwwWebservicesNlSoap.DutchBusinessAnnualFinancialStatementSummary annual_financial_statement_summary;
        //        public wwwWebservicesNlSoap.DutchBusinessStructure structure;
        //        public wwwWebservicesNlSoap.DutchBusinessSBICollection sbi_collection;


    }

    public class DutchBusinessSearchParametersRequest {
        public string name;
        public string domain;
        public string phone;
        public string street;
        public string city;
        public string postcode;
        public string province;
        public string country;
    }
    public class DutchBusinessSearchParametersResponse {
        // paging info, might be wrong and have more functionallity around that
        public Integer curpage;
        public Integer perpage;
        public Integer numpages;
        public Integer numresults;
        public Integer maxresults;
        public List<DutchBusinessReference> items;
        public DutchBusinessSearchParametersResponse(){
            items = new List<DutchBusinessReference>();
        }
    }
    public class DutchBusinessReference{
        @AuraEnabled public String dossier_number;
        @AuraEnabled public String establishment_number;
        @AuraEnabled public String name;
        @AuraEnabled public String match_type;
        @AuraEnabled public String establishment_city;
        @AuraEnabled public String establishment_street;
        @AuraEnabled public String correspondence_city;
        @AuraEnabled public String correspondence_street;
        @AuraEnabled public Boolean indication_economically_active;
    }
}
