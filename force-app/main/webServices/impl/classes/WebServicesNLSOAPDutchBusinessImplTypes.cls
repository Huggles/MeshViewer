/****************************************************************************************
Author          : ValerijsProkudins
Description     : CompanyConnect DutchBusiness integration implementation Type class. NB: it extends the Baseline implementation class!
******************************************************************************************/
public abstract class WebServicesNLSOAPDutchBusinessImplTypes  extends WebservicesNlSOAPImpl implements IWebServicesNLSOAPDutchBusiness{
    public class dutchBusinessGetDossierV3RequestType {
        public String dossier_number;
        public String establishment_number;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_number_type_info = new String[]{'establishment_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','establishment_number'};
    }
    public class dutchBusinessGetDossierV3ResponseType {
        public DutchBusinessDossierV3 out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessDossierV3','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class DutchBusinessDossierV3 {
        public DutchBusinessUpdateReference update_info;
        public String dossier_number;
        public String establishment_number;
        public String main_establishment_number;
        public Boolean indication_main_establishment;
        public String rsin_number;
        public String chamber_number;
        public String legal_form_code;
        public String legal_form_text;
        public String indication_organisation_code;
        public String legal_name;
        public String trade_name_45;
        public String trade_name_full;
        public stringArray trade_names;
        public DutchBusinessFormattedAddress establishment_address;
        public DutchBusinessFormattedAddress correspondence_address;
        public String telephone_number;
        public String mobile_number;
        public String domain_name;
        public String contact_title1;
        public String contact_title2;
        public String contact_initials;
        public String contact_prefix;
        public String contact_surname;
        public String contact_gender;
        public String primary_sbi_code;
        public String secondary_sbi_code1;
        public String secondary_sbi_code2;
        public String primary_sbi_code_text;
        public String secondary_sbi_code1_text;
        public String secondary_sbi_code2_text;
        public Integer personnel;
        public Integer class_personnel;
        public Integer personnel_fulltime;
        public Integer class_personnel_fulltime;
        public DutchBusinessDateV3 personnel_reference_date;
        public Integer personnel_ci;
        public Integer class_personnel_ci;
        public DutchBusinessDateV3 personnel_ci_reference_date;
        public Boolean indication_import;
        public Boolean indication_export;
        public Boolean indication_economically_active;
        public Boolean indication_non_mailing;
        public Boolean indication_bankruptcy;
        public Boolean indication_dip;
        public DutchBusinessInsolvencyArray insolvencies;
        public Long authorized_share_capital;
        public String authorized_share_capital_currency;
        public Long paid_up_share_capital;
        public String paid_up_share_capital_currency;
        public Long issued_share_capital;
        public String issued_share_capital_currency;
        public DutchBusinessDateV3 founding_date;
        public DutchBusinessDateV3 discontinuation_date;
        public DutchBusinessDateV3 continuation_date;
        public DutchBusinessDateV3 establishment_date;
        public DutchBusinessAnnualFinancialStatementSummary annual_financial_statement_summary;
        public DutchBusinessStructure structure;
        public DutchBusinessSBICollection sbi_collection;
        private String[] update_info_type_info = new String[]{'update_info','http://www.webservices.nl/soap/','DutchBusinessUpdateReference','1','1','false'};
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_number_type_info = new String[]{'establishment_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] main_establishment_number_type_info = new String[]{'main_establishment_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] indication_main_establishment_type_info = new String[]{'indication_main_establishment','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] rsin_number_type_info = new String[]{'rsin_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] chamber_number_type_info = new String[]{'chamber_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] legal_form_code_type_info = new String[]{'legal_form_code','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] legal_form_text_type_info = new String[]{'legal_form_text','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] indication_organisation_code_type_info = new String[]{'indication_organisation_code','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] legal_name_type_info = new String[]{'legal_name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] trade_name_45_type_info = new String[]{'trade_name_45','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] trade_name_full_type_info = new String[]{'trade_name_full','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] trade_names_type_info = new String[]{'trade_names','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] establishment_address_type_info = new String[]{'establishment_address','http://www.webservices.nl/soap/','DutchBusinessFormattedAddress','0','1','false'};
        private String[] correspondence_address_type_info = new String[]{'correspondence_address','http://www.webservices.nl/soap/','DutchBusinessFormattedAddress','0','1','false'};
        private String[] telephone_number_type_info = new String[]{'telephone_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] mobile_number_type_info = new String[]{'mobile_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] domain_name_type_info = new String[]{'domain_name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] contact_title1_type_info = new String[]{'contact_title1','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] contact_title2_type_info = new String[]{'contact_title2','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] contact_initials_type_info = new String[]{'contact_initials','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] contact_prefix_type_info = new String[]{'contact_prefix','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] contact_surname_type_info = new String[]{'contact_surname','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] contact_gender_type_info = new String[]{'contact_gender','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] primary_sbi_code_type_info = new String[]{'primary_sbi_code','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] secondary_sbi_code1_type_info = new String[]{'secondary_sbi_code1','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] secondary_sbi_code2_type_info = new String[]{'secondary_sbi_code2','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] primary_sbi_code_text_type_info = new String[]{'primary_sbi_code_text','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] secondary_sbi_code1_text_type_info = new String[]{'secondary_sbi_code1_text','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] secondary_sbi_code2_text_type_info = new String[]{'secondary_sbi_code2_text','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] personnel_type_info = new String[]{'personnel','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] class_personnel_type_info = new String[]{'class_personnel','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] personnel_fulltime_type_info = new String[]{'personnel_fulltime','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] class_personnel_fulltime_type_info = new String[]{'class_personnel_fulltime','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] personnel_reference_date_type_info = new String[]{'personnel_reference_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] personnel_ci_type_info = new String[]{'personnel_ci','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] class_personnel_ci_type_info = new String[]{'class_personnel_ci','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] personnel_ci_reference_date_type_info = new String[]{'personnel_ci_reference_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] indication_import_type_info = new String[]{'indication_import','http://www.webservices.nl/soap/','boolean','0','1','false'};
        private String[] indication_export_type_info = new String[]{'indication_export','http://www.webservices.nl/soap/','boolean','0','1','false'};
        private String[] indication_economically_active_type_info = new String[]{'indication_economically_active','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] indication_non_mailing_type_info = new String[]{'indication_non_mailing','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] indication_bankruptcy_type_info = new String[]{'indication_bankruptcy','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] indication_dip_type_info = new String[]{'indication_dip','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] insolvencies_type_info = new String[]{'insolvencies','http://www.webservices.nl/soap/','DutchBusinessInsolvencyArray','0','1','false'};
        private String[] authorized_share_capital_type_info = new String[]{'authorized_share_capital','http://www.webservices.nl/soap/','long','0','1','false'};
        private String[] authorized_share_capital_currency_type_info = new String[]{'authorized_share_capital_currency','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] paid_up_share_capital_type_info = new String[]{'paid_up_share_capital','http://www.webservices.nl/soap/','long','0','1','false'};
        private String[] paid_up_share_capital_currency_type_info = new String[]{'paid_up_share_capital_currency','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] issued_share_capital_type_info = new String[]{'issued_share_capital','http://www.webservices.nl/soap/','long','0','1','false'};
        private String[] issued_share_capital_currency_type_info = new String[]{'issued_share_capital_currency','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] founding_date_type_info = new String[]{'founding_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] discontinuation_date_type_info = new String[]{'discontinuation_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] continuation_date_type_info = new String[]{'continuation_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] establishment_date_type_info = new String[]{'establishment_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] annual_financial_statement_summary_type_info = new String[]{'annual_financial_statement_summary','http://www.webservices.nl/soap/','DutchBusinessAnnualFinancialStatementSummary','0','1','false'};
        private String[] structure_type_info = new String[]{'structure','http://www.webservices.nl/soap/','DutchBusinessStructure','0','1','false'};
        private String[] sbi_collection_type_info = new String[]{'sbi_collection','http://www.webservices.nl/soap/','DutchBusinessSBICollection','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'update_info','dossier_number','establishment_number','main_establishment_number','indication_main_establishment','rsin_number','chamber_number','legal_form_code','legal_form_text','indication_organisation_code','legal_name','trade_name_45','trade_name_full','trade_names','establishment_address','correspondence_address','telephone_number','mobile_number','domain_name','contact_title1','contact_title2','contact_initials','contact_prefix','contact_surname','contact_gender','primary_sbi_code','secondary_sbi_code1','secondary_sbi_code2','primary_sbi_code_text','secondary_sbi_code1_text','secondary_sbi_code2_text','personnel','class_personnel','personnel_fulltime','class_personnel_fulltime','personnel_reference_date','personnel_ci','class_personnel_ci','personnel_ci_reference_date','indication_import','indication_export','indication_economically_active','indication_non_mailing','indication_bankruptcy','indication_dip','insolvencies','authorized_share_capital','authorized_share_capital_currency','paid_up_share_capital','paid_up_share_capital_currency','issued_share_capital','issued_share_capital_currency','founding_date','discontinuation_date','continuation_date','establishment_date','annual_financial_statement_summary','structure','sbi_collection'};
    }
    public class DutchBusinessDateV3 {
        public Integer year;
        public Integer month;
        public Integer day;
        private String[] year_type_info = new String[]{'year','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] month_type_info = new String[]{'month','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] day_type_info = new String[]{'day','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'year','month','day'};
    }
    public class DutchBusinessDateV2 {
        public Integer year;
        public Integer month;
        public Integer day;
        private String[] year_type_info = new String[]{'year','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] month_type_info = new String[]{'month','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] day_type_info = new String[]{'day','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'year','month','day'};
    }
    public class DutchBusinessAddressV2 {
        public String postcode;
        public String city;
        public String street;
        public Integer house_number;
        public String house_number_addition;
        public String country;
        private String[] postcode_type_info = new String[]{'postcode','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] city_type_info = new String[]{'city','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] street_type_info = new String[]{'street','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] house_number_type_info = new String[]{'house_number','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] house_number_addition_type_info = new String[]{'house_number_addition','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] country_type_info = new String[]{'country','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'postcode','city','street','house_number','house_number_addition','country'};
    }
    public class DutchBusinessInsolvency {
        public String insolvency_id;
        public DutchBusinessInsolvencyPublicationArray events;
        private String[] insolvency_id_type_info = new String[]{'insolvency_id','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] events_type_info = new String[]{'events','http://www.webservices.nl/soap/','DutchBusinessInsolvencyPublicationArray','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'insolvency_id','events'};
    }
    public class DutchBusinessInsolvencyArray {
        public DutchBusinessInsolvency[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessInsolvency','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class DutchBusinessInsolvencyPublication {
        public String publication_id;
        public String description;
        public DutchBusinessDateV3 date_x;
        private String[] publication_id_type_info = new String[]{'publication_id','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] date_x_type_info = new String[]{'date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'publication_id','description','date_x'};
    }
    public class DutchBusinessInsolvencyPublicationArray {
        public DutchBusinessInsolvencyPublication[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessInsolvencyPublication','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
        public class DutchBusinessSBICollection {
        public DutchBusinessSBICodeArray original;
        public DutchBusinessSBICodeArray company_info;
        private String[] original_type_info = new String[]{'original','http://www.webservices.nl/soap/','DutchBusinessSBICodeArray','1','1','false'};
        private String[] company_info_type_info = new String[]{'company_info','http://www.webservices.nl/soap/','DutchBusinessSBICodeArray','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'original','company_info'};
    }
        public class DutchBusinessStructure {
        public String ultimate_parent;
        public Integer number_of_subsidiaries;
        public String parent;
        private String[] ultimate_parent_type_info = new String[]{'ultimate_parent','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] number_of_subsidiaries_type_info = new String[]{'number_of_subsidiaries','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] parent_type_info = new String[]{'parent','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'ultimate_parent','number_of_subsidiaries','parent'};
    }
        public class DutchBusinessAnnualFinancialStatementSummary {
        public Integer year;
        public DutchBusinessMoneyV2 turnover;
        public DutchBusinessMoneyV2 profit;
        public DutchBusinessMoneyV2 assets;
        private String[] year_type_info = new String[]{'year','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] turnover_type_info = new String[]{'turnover','http://www.webservices.nl/soap/','DutchBusinessMoneyV2','0','1','false'};
        private String[] profit_type_info = new String[]{'profit','http://www.webservices.nl/soap/','DutchBusinessMoneyV2','0','1','false'};
        private String[] assets_type_info = new String[]{'assets','http://www.webservices.nl/soap/','DutchBusinessMoneyV2','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'year','turnover','profit','assets'};
    }
        public class DutchBusinessMoneyV2 {
        public Long amount;
        public String currency_x;
        public String formatted;
        private String[] amount_type_info = new String[]{'amount','http://www.webservices.nl/soap/','long','0','1','false'};
        private String[] currency_x_type_info = new String[]{'currency','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] formatted_type_info = new String[]{'formatted','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'amount','currency_x','formatted'};
    }
    public class DutchBusinessMoneyV3 {
        public Long amount;
        public String currency_x;
        public String formatted;
        private String[] amount_type_info = new String[]{'amount','http://www.webservices.nl/soap/','long','0','1','false'};
        private String[] currency_x_type_info = new String[]{'currency','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] formatted_type_info = new String[]{'formatted','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'amount','currency_x','formatted'};
    }
        public class DutchBusinessFormattedAddress {
        public DutchBusinessAddressV3 original;
        public DutchBusinessAddressV3 official;
        public DutchBusinessAddressV3 formatted;
        private String[] original_type_info = new String[]{'original','http://www.webservices.nl/soap/','DutchBusinessAddressV3','0','1','false'};
        private String[] official_type_info = new String[]{'official','http://www.webservices.nl/soap/','DutchBusinessAddressV3','0','1','false'};
        private String[] formatted_type_info = new String[]{'formatted','http://www.webservices.nl/soap/','DutchBusinessAddressV3','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'original','official','formatted'};
    }
    public class DutchBusinessUpdateReference {
        public String dossier_number;
        public String establishment_number;
        public stringArray update_types;
        public Date date_last_update;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_number_type_info = new String[]{'establishment_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] update_types_type_info = new String[]{'update_types','http://www.webservices.nl/soap/','stringArray','1','1','false'};
        private String[] date_last_update_type_info = new String[]{'date_last_update','http://www.webservices.nl/soap/','date','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','establishment_number','update_types','date_last_update'};
    }
    public class DutchBusinessAddressV3 {
        public String address;
        public String postcode;
        public String city;
        public String street;
        public Integer house_number;
        public String house_number_addition;
        public String country;
        private String[] address_type_info = new String[]{'address','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] postcode_type_info = new String[]{'postcode','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] city_type_info = new String[]{'city','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] street_type_info = new String[]{'street','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] house_number_type_info = new String[]{'house_number','http://www.webservices.nl/soap/','int','0','1','false'};
        private String[] house_number_addition_type_info = new String[]{'house_number_addition','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] country_type_info = new String[]{'country','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'address','postcode','city','street','house_number','house_number_addition','country'};
    }
    public class DutchBusinessSBICode {
        public String sbi_code;
        public String description;
        private String[] sbi_code_type_info = new String[]{'sbi_code','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'sbi_code','description'};
    }
    public class DutchBusinessSBICodeArray {
        public DutchBusinessSBICode[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessSBICode','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class DutchBusinessSbiCodeV3 {
        public String sbi_code;
        public String description;
        private String[] sbi_code_type_info = new String[]{'sbi_code','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'sbi_code','description'};
    }
    public class DutchBusinessSbiCodeV3Array {
        public DutchBusinessSbiCodeV3[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessSbiCodeV3','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }    
    public class dutchBusinessSearchParametersV2ResponseType {
        public DutchBusinessReferenceV2PagedResult out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessReferenceV2PagedResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class DutchBusinessReferenceV2PagedResult {
        public ResultInfo paging;
        public string errorcode;
        public DutchBusinessReferenceV2Array results;
        private String[] paging_type_info = new String[]{'paging','http://www.webservices.nl/soap/','ResultInfo','1','1','false'};
        private String[] results_type_info = new String[]{'results','http://www.webservices.nl/soap/','DutchBusinessReferenceV2Array','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'paging','results'};
    }
    public class ResultInfo {
        public Integer curpage;
        public Integer perpage;
        public Integer numpages;
        public Integer numresults;
        public Integer maxresults;
        private String[] curpage_type_info = new String[]{'curpage','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] perpage_type_info = new String[]{'perpage','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] numpages_type_info = new String[]{'numpages','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] numresults_type_info = new String[]{'numresults','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] maxresults_type_info = new String[]{'maxresults','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'curpage','perpage','numpages','numresults','maxresults'};
    }
    public class DutchBusinessReferenceV2Array {
        public DutchBusinessReferenceV2[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessReferenceV2','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class DutchBusinessReferenceV2 { 
        /*@AuraEnabled public String dossier_number{get;set;}
        @AuraEnabled public String establishment_number{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String match_type{get;set;}
        @AuraEnabled public String establishment_city{get;set;}
        @AuraEnabled public String establishment_street{get;set;}
        @AuraEnabled public String correspondence_city{get;set;}
        @AuraEnabled public String correspondence_street{get;set;}
        @AuraEnabled public Boolean indication_economically_active{get;set;}*/

        public String dossier_number;
        public String establishment_number;
        public String name;
        public String match_type;
        public String establishment_city;
        public String establishment_street;
        public String correspondence_street;
        public String correspondence_city;
        public Boolean indication_economically_active;

        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_number_type_info = new String[]{'establishment_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] name_type_info = new String[]{'name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] match_type_type_info = new String[]{'match_type','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] establishment_city_type_info = new String[]{'establishment_city','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_street_type_info = new String[]{'establishment_street','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] correspondence_city_type_info = new String[]{'correspondence_city','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] correspondence_street_type_info = new String[]{'correspondence_street','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] indication_economically_active_type_info = new String[]{'indication_economically_active','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','establishment_number','name','match_type','establishment_city','establishment_street','correspondence_city','correspondence_street','indication_economically_active'};
    }
    public class dutchBusinessSearchParametersV2RequestType {
        public String trade_name;
        public String city;
        public String street;
        public String postcode;
        public Integer house_number;
        public String house_number_addition;
        public String telephone_number;
        public String domain_name;
        public Boolean strict_search;
        public Integer page;
        private String[] trade_name_type_info = new String[]{'trade_name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] city_type_info = new String[]{'city','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] street_type_info = new String[]{'street','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] postcode_type_info = new String[]{'postcode','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] house_number_type_info = new String[]{'house_number','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] house_number_addition_type_info = new String[]{'house_number_addition','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] telephone_number_type_info = new String[]{'telephone_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] domain_name_type_info = new String[]{'domain_name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] strict_search_type_info = new String[]{'strict_search','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] page_type_info = new String[]{'page','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'trade_name','city','street','postcode','house_number','house_number_addition','telephone_number','domain_name','strict_search','page'};
        //private String[] field_order_type_info = new String[]{'trade_name','city','street','house_number','house_number_addition','telephone_number','domain_name','strict_search','page'};

    }

    public class dutchBusinessGetVatNumberRequestType {
        public String dossier_number;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number'};
    }

    public class dutchBusinessGetVatNumberResponseType {
        public DutchBusinessDto.DutchBusinessVatNumber out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }

    
    /*
    public class DutchBusinessLegalEntityData {
        public String dossier_number;
        public DateTime reference_date;
        public DutchBusinessLegalEntityV3 legal_entity;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] reference_date_type_info = new String[]{'reference_date','http://www.webservices.nl/soap/','dateTime','0','1','false'};
        private String[] legal_entity_type_info = new String[]{'legal_entity','http://www.webservices.nl/soap/','DutchBusinessLegalEntityV3','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','reference_date','legal_entity'};
    }
    public class DutchBusinessLegalEntityV3 {
        public String rsin_number;
        public String name;
        public String alternative_name;
        public String shortened_name;
        public String registration;
        public String legal_form_text;
        public String legal_form_change;
        public String foreign_legal_form_description;
        public String activity;
        public String company_arrangement;
        public String legal_name;
        public String statutory_seat;
        public DutchBusinessDateV3 registration_date;
        public DutchBusinessDateV3 founding_date;
        public DutchBusinessDateV3 discontinuation_date;
        public DutchBusinessDateV3 dissolution_date;
        public String dissolution_reason;
        public DutchBusinessDateV3 removal_date;
        public DutchBusinessDateV3 registration_end_date;
        public DutchBusinessDateV3 legal_entity_end_date;
        public DutchBusinessDateV3 liquidation_closure_date;
        public DutchBusinessDateV3 liquidation_reopening_date;
        public DutchBusinessDateV3 deed_incorporation_date;
        public DutchBusinessDateV3 deed_last_statutes_amendment_date;
        public DutchBusinessDateV3 last_statutes_amendment_date;
        public String liability;
        public String merger_description;
        public String annual_report_submission;
        public DutchBusinessMoneyV3 authorized_share_capital;
        public DutchBusinessMoneyV3 issued_share_capital;
        public DutchBusinessMoneyV3 paid_up_share_capital;
        public String duration;
        public DutchBusinessDateV3 duration_end_date;
        public String shares;
        public String share_holders;
        public stringArray remarks;
        public DutchBusinessAddressV3 establishment_address;
        public DutchBusinessAddressV3 correspondence_address;
        public stringArray telephone_numbers;
        public stringArray fax_numbers;
        public stringArray email_addresses;
        public stringArray domain_names;
        public DutchBusinessSbiCodeV3Array sbi_codes;
        private String[] rsin_number_type_info = new String[]{'rsin_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] name_type_info = new String[]{'name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] alternative_name_type_info = new String[]{'alternative_name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] shortened_name_type_info = new String[]{'shortened_name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] registration_type_info = new String[]{'registration','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] legal_form_text_type_info = new String[]{'legal_form_text','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] legal_form_change_type_info = new String[]{'legal_form_change','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] foreign_legal_form_description_type_info = new String[]{'foreign_legal_form_description','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] activity_type_info = new String[]{'activity','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] company_arrangement_type_info = new String[]{'company_arrangement','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] legal_name_type_info = new String[]{'legal_name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] statutory_seat_type_info = new String[]{'statutory_seat','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] registration_date_type_info = new String[]{'registration_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] founding_date_type_info = new String[]{'founding_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] discontinuation_date_type_info = new String[]{'discontinuation_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] dissolution_date_type_info = new String[]{'dissolution_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] dissolution_reason_type_info = new String[]{'dissolution_reason','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] removal_date_type_info = new String[]{'removal_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] registration_end_date_type_info = new String[]{'registration_end_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] legal_entity_end_date_type_info = new String[]{'legal_entity_end_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] liquidation_closure_date_type_info = new String[]{'liquidation_closure_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] liquidation_reopening_date_type_info = new String[]{'liquidation_reopening_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] deed_incorporation_date_type_info = new String[]{'deed_incorporation_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] deed_last_statutes_amendment_date_type_info = new String[]{'deed_last_statutes_amendment_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] last_statutes_amendment_date_type_info = new String[]{'last_statutes_amendment_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] liability_type_info = new String[]{'liability','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] merger_description_type_info = new String[]{'merger_description','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] annual_report_submission_type_info = new String[]{'annual_report_submission','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] authorized_share_capital_type_info = new String[]{'authorized_share_capital','http://www.webservices.nl/soap/','DutchBusinessMoneyV3','0','1','false'};
        private String[] issued_share_capital_type_info = new String[]{'issued_share_capital','http://www.webservices.nl/soap/','DutchBusinessMoneyV3','0','1','false'};
        private String[] paid_up_share_capital_type_info = new String[]{'paid_up_share_capital','http://www.webservices.nl/soap/','DutchBusinessMoneyV3','0','1','false'};
        private String[] duration_type_info = new String[]{'duration','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] duration_end_date_type_info = new String[]{'duration_end_date','http://www.webservices.nl/soap/','DutchBusinessDateV3','0','1','false'};
        private String[] shares_type_info = new String[]{'shares','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] share_holders_type_info = new String[]{'share_holders','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] remarks_type_info = new String[]{'remarks','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] establishment_address_type_info = new String[]{'establishment_address','http://www.webservices.nl/soap/','DutchBusinessAddressV3','0','1','false'};
        private String[] correspondence_address_type_info = new String[]{'correspondence_address','http://www.webservices.nl/soap/','DutchBusinessAddressV3','0','1','false'};
        private String[] telephone_numbers_type_info = new String[]{'telephone_numbers','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] fax_numbers_type_info = new String[]{'fax_numbers','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] email_addresses_type_info = new String[]{'email_addresses','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] domain_names_type_info = new String[]{'domain_names','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] sbi_codes_type_info = new String[]{'sbi_codes','http://www.webservices.nl/soap/','DutchBusinessSbiCodeV3Array','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'rsin_number','name','alternative_name','shortened_name','registration','legal_form_text','legal_form_change','foreign_legal_form_description','activity','company_arrangement','legal_name','statutory_seat','registration_date','founding_date','discontinuation_date','dissolution_date','dissolution_reason','removal_date','registration_end_date','legal_entity_end_date','liquidation_closure_date','liquidation_reopening_date','deed_incorporation_date','deed_last_statutes_amendment_date','last_statutes_amendment_date','liability','merger_description','annual_report_submission','authorized_share_capital','issued_share_capital','paid_up_share_capital','duration','duration_end_date','shares','share_holders','remarks','establishment_address','correspondence_address','telephone_numbers','fax_numbers','email_addresses','domain_names','sbi_codes'};
    }

    public class DutchBusinessOrganizationTree {
        public String name;
        public String dossier_number;
        public DutchBusinessOrganizationNode tree;
        private String[] name_type_info = new String[]{'name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] tree_type_info = new String[]{'tree','http://www.webservices.nl/soap/','DutchBusinessOrganizationNode','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'name','dossier_number','tree'};
    }
    public class DutchBusinessPeriod {
        public Date start_date;
        public Date end_date;
        private String[] start_date_type_info = new String[]{'start_date','http://www.webservices.nl/soap/','date','0','1','false'};
        private String[] end_date_type_info = new String[]{'end_date','http://www.webservices.nl/soap/','date','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'start_date','end_date'};
    }
    public class DutchBusinessEstablishmentReferenceArray {
        public DutchBusinessEstablishmentReference[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessEstablishmentReference','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class DutchBusinessEstablishmentReferencePagedResult {
        public ResultInfo paging;
        public DutchBusinessEstablishmentReferenceArray results;
        private String[] paging_type_info = new String[]{'paging','http://www.webservices.nl/soap/','ResultInfo','1','1','false'};
        private String[] results_type_info = new String[]{'results','http://www.webservices.nl/soap/','DutchBusinessEstablishmentReferenceArray','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'paging','results'};
    }
    public class DutchBusinessEstablishmentReference {
        public String dossier_number;
        public String establishment_number;
        public String legal_name;
        public String trade_name;
        public String match_type;
        public String establishment_city;
        public String establishment_street;
        public String correspondence_city;
        public String correspondence_street;
        public Boolean indication_main_establishment;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_number_type_info = new String[]{'establishment_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] legal_name_type_info = new String[]{'legal_name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] trade_name_type_info = new String[]{'trade_name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] match_type_type_info = new String[]{'match_type','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] establishment_city_type_info = new String[]{'establishment_city','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_street_type_info = new String[]{'establishment_street','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] correspondence_city_type_info = new String[]{'correspondence_city','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] correspondence_street_type_info = new String[]{'correspondence_street','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] indication_main_establishment_type_info = new String[]{'indication_main_establishment','http://www.webservices.nl/soap/','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','establishment_number','legal_name','trade_name','match_type','establishment_city','establishment_street','correspondence_city','correspondence_street','indication_main_establishment'};
    }
    public class DutchBusinessNewsItem {
        public String title;
        public DateTime date_x;
        public String short_x;
        public String url;
        public String source;
        public String type_x;
        public Decimal sentiment;
        public stringArray topics;
        public DutchBusinessNewsCompanyArray companies;
        private String[] title_type_info = new String[]{'title','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] date_x_type_info = new String[]{'date','http://www.webservices.nl/soap/','dateTime','1','1','false'};
        private String[] short_x_type_info = new String[]{'short','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] url_type_info = new String[]{'url','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] source_type_info = new String[]{'source','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] sentiment_type_info = new String[]{'sentiment','http://www.webservices.nl/soap/','decimal','1','1','false'};
        private String[] topics_type_info = new String[]{'topics','http://www.webservices.nl/soap/','stringArray','1','1','false'};
        private String[] companies_type_info = new String[]{'companies','http://www.webservices.nl/soap/','DutchBusinessNewsCompanyArray','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'title','date_x','short_x','url','source','type_x','sentiment','topics','companies'};
    }
    public class DutchBusinessNewsItemArray {
        public DutchBusinessNewsItem[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessNewsItem','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class DutchBusinessNewsItemPagedResult {
        public ResultInfo paging;
        public DutchBusinessNewsItemArray results;
        private String[] paging_type_info = new String[]{'paging','http://www.webservices.nl/soap/','ResultInfo','1','1','false'};
        private String[] results_type_info = new String[]{'results','http://www.webservices.nl/soap/','DutchBusinessNewsItemArray','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'paging','results'};
    }
    public class dutchBusinessGetOrganizationTreeResponseType {
        public DutchBusinessOrganizationTree out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessOrganizationTree','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class dutchBusinessGetPositionsRequestType {
        public String dossier_number;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number'};
    }
    public class dutchBusinessGetPositionsResponseType {
        public DutchBusinessPositions out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessPositions','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class dutchBusinessSearchRequestType {
        public String dossier_number;
        public String trade_name;
        public String city;
        public String street;
        public String postcode;
        public Integer house_number;
        public String house_number_addition;
        public String telephone_number;
        public String domain_name;
        public Boolean strict_search;
        public Integer page;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] trade_name_type_info = new String[]{'trade_name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] city_type_info = new String[]{'city','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] street_type_info = new String[]{'street','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] postcode_type_info = new String[]{'postcode','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] house_number_type_info = new String[]{'house_number','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] house_number_addition_type_info = new String[]{'house_number_addition','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] telephone_number_type_info = new String[]{'telephone_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] domain_name_type_info = new String[]{'domain_name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] strict_search_type_info = new String[]{'strict_search','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] page_type_info = new String[]{'page','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','trade_name','city','street','postcode','house_number','house_number_addition','telephone_number','domain_name','strict_search','page'};
    }
    public class dutchBusinessSearchResponseType {
        public DutchBusinessEstablishmentReferencePagedResult out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessEstablishmentReferencePagedResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class DutchBusinessReferencePagedResult {
        public ResultInfo paging;
        public DutchBusinessReferenceArray results;
        private String[] paging_type_info = new String[]{'paging','http://www.webservices.nl/soap/','ResultInfo','1','1','false'};
        private String[] results_type_info = new String[]{'results','http://www.webservices.nl/soap/','DutchBusinessReferenceArray','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'paging','results'};
    }
    public class dutchBusinessGetLegalEntityResponseType {
        public DutchBusinessLegalEntityData out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessLegalEntityData','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class dutchBusinessGetOrganizationTreeRequestType {
        public String dossier_number;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number'};
    }
    public class dutchBusinessSearchPostcodeRequestType {
        public String postcode;
        public Integer house_number;
        public String house_number_addition;
        public Integer page;
        private String[] postcode_type_info = new String[]{'postcode','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] house_number_type_info = new String[]{'house_number','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] house_number_addition_type_info = new String[]{'house_number_addition','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] page_type_info = new String[]{'page','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'postcode','house_number','house_number_addition','page'};
    }
    public class dutchBusinessSearchPostcodeResponseType {
        public DutchBusinessReferencePagedResult out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessReferencePagedResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }    
    public class dutchBusinessSearchDossierNumberRequestType {
        public String dossier_number;
        public String establishment_number;
        public String rsin_number;
        public Integer page;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_number_type_info = new String[]{'establishment_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] rsin_number_type_info = new String[]{'rsin_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] page_type_info = new String[]{'page','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','establishment_number','rsin_number','page'};
    }
    public class dutchBusinessSearchDossierNumberResponseType {
        public DutchBusinessReferencePagedResult out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessReferencePagedResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }

    public class dutchBusinessSearchSelectionRequestType {
        public stringArray city;
        public stringArray postcode;
        public stringArray sbi;
        public Boolean primary_sbi_only;
        public intArray legal_form;
        public Integer employees_min;
        public Integer employees_max;
        public String economically_active;
        public String financial_status;
        public String changed_since;
        public String new_since;
        public Integer page;
        public stringArray provinces;
        public String sbi_match_type;
        private String[] city_type_info = new String[]{'city','http://www.webservices.nl/soap/','stringArray','1','1','false'};
        private String[] postcode_type_info = new String[]{'postcode','http://www.webservices.nl/soap/','stringArray','1','1','false'};
        private String[] sbi_type_info = new String[]{'sbi','http://www.webservices.nl/soap/','stringArray','1','1','false'};
        private String[] primary_sbi_only_type_info = new String[]{'primary_sbi_only','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] legal_form_type_info = new String[]{'legal_form','http://www.webservices.nl/soap/','intArray','1','1','false'};
        private String[] employees_min_type_info = new String[]{'employees_min','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] employees_max_type_info = new String[]{'employees_max','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] economically_active_type_info = new String[]{'economically_active','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] financial_status_type_info = new String[]{'financial_status','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] changed_since_type_info = new String[]{'changed_since','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] new_since_type_info = new String[]{'new_since','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] page_type_info = new String[]{'page','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] provinces_type_info = new String[]{'provinces','http://www.webservices.nl/soap/','stringArray','1','1','false'};
        private String[] sbi_match_type_type_info = new String[]{'sbi_match_type','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'city','postcode','sbi','primary_sbi_only','legal_form','employees_min','employees_max','economically_active','financial_status','changed_since','new_since','page','provinces','sbi_match_type'};
    }
    public class dutchBusinessSearchSelectionResponseType {
        public DutchBusinessReferencePagedResult out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessReferencePagedResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class dutchBusinessSearchNewsByDossierRequestType {
        public Integer dossier_number;
        public DateTime period_start;
        public DateTime period_end;
        public String sort_order;
        public Integer page;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] period_start_type_info = new String[]{'period_start','http://www.webservices.nl/soap/','dateTime','1','1','false'};
        private String[] period_end_type_info = new String[]{'period_end','http://www.webservices.nl/soap/','dateTime','1','1','false'};
        private String[] sort_order_type_info = new String[]{'sort_order','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] page_type_info = new String[]{'page','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','period_start','period_end','sort_order','page'};
    }
    public class dutchBusinessSearchNewsByDossierResponseType {
        public DutchBusinessNewsItemPagedResult out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessNewsItemPagedResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class DutchBusinessOrganizationNode {
        public String name;
        public String type_x;
        public String id;
        public DutchBusinessOrganizationNodeArray children;
        private String[] name_type_info = new String[]{'name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] id_type_info = new String[]{'id','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] children_type_info = new String[]{'children','http://www.webservices.nl/soap/','DutchBusinessOrganizationNodeArray','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'name','type_x','id','children'};
    }
    public class DutchBusinessOrganizationNodeArray {
        public DutchBusinessOrganizationNode[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessOrganizationNode','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class DutchBusinessOrganizationReferenceV2 {
        public String dossier_number;
        public String registration;
        public String name;
        public stringArray trade_names;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] registration_type_info = new String[]{'registration','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] name_type_info = new String[]{'name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] trade_names_type_info = new String[]{'trade_names','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','registration','name','trade_names'};
    }
    public class DutchBusinessPositions {
        public String dossier_number;
        public DateTime reference_date;
        public DutchBusinessPositionV2Array positions;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] reference_date_type_info = new String[]{'reference_date','http://www.webservices.nl/soap/','dateTime','0','1','false'};
        private String[] positions_type_info = new String[]{'positions','http://www.webservices.nl/soap/','DutchBusinessPositionV2Array','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','reference_date','positions'};
    }
    public class DutchBusinessPositionV2 {
        public DutchBusinessPersonV2 functionary;
        public DutchBusinessOrganizationReferenceV2 organisation;
        public DutchBusinessAddressV2 residential_address;
        public DutchBusinessAddressV2 correspondence_address;
        public DutchBusinessAddressV2 establishment_address;
        public Boolean longest_serving;
        public String function_type;
        public String function_description;
        public String function_title;
        public DutchBusinessDateV2 function_start_date;
        public DutchBusinessDateV2 function_registration_date;
        public DutchBusinessDateV2 function_end_date;
        public String function_authorization;
        public String function_authorization_description;
        public DutchBusinessDateV2 function_authorization_start_date;
        public String function_authorization_signing_power;
        public DutchBusinessDateV2 function_authorization_end_date;
        public String authorization_description;
        public String authorization_establishment_number;
        public DutchBusinessDateV2 authorization_start_date;
        public DutchBusinessDateV2 authorization_end_date;
        public stringArray authorization_constraints;
        public String inauguration;
        public String inauguration_function;
        public String inauguration_duration;
        public DutchBusinessDateV2 inauguration_date;
        public String inauguration_body;
        public String under_receivership;
        public String rights_against_third_parties;
        public String release_of_covenant;
        public DutchBusinessDateV2 date_since;
        public DutchBusinessDateV2 date_joined;
        public stringArray remarks;
        private String[] functionary_type_info = new String[]{'functionary','http://www.webservices.nl/soap/','DutchBusinessPersonV2','0','1','false'};
        private String[] organisation_type_info = new String[]{'organisation','http://www.webservices.nl/soap/','DutchBusinessOrganizationReferenceV2','0','1','false'};
        private String[] residential_address_type_info = new String[]{'residential_address','http://www.webservices.nl/soap/','DutchBusinessAddressV2','0','1','false'};
        private String[] correspondence_address_type_info = new String[]{'correspondence_address','http://www.webservices.nl/soap/','DutchBusinessAddressV2','0','1','false'};
        private String[] establishment_address_type_info = new String[]{'establishment_address','http://www.webservices.nl/soap/','DutchBusinessAddressV2','0','1','false'};
        private String[] longest_serving_type_info = new String[]{'longest_serving','http://www.webservices.nl/soap/','boolean','0','1','false'};
        private String[] function_type_type_info = new String[]{'function_type','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] function_description_type_info = new String[]{'function_description','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] function_title_type_info = new String[]{'function_title','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] function_start_date_type_info = new String[]{'function_start_date','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] function_registration_date_type_info = new String[]{'function_registration_date','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] function_end_date_type_info = new String[]{'function_end_date','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] function_authorization_type_info = new String[]{'function_authorization','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] function_authorization_description_type_info = new String[]{'function_authorization_description','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] function_authorization_start_date_type_info = new String[]{'function_authorization_start_date','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] function_authorization_signing_power_type_info = new String[]{'function_authorization_signing_power','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] function_authorization_end_date_type_info = new String[]{'function_authorization_end_date','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] authorization_description_type_info = new String[]{'authorization_description','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] authorization_establishment_number_type_info = new String[]{'authorization_establishment_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] authorization_start_date_type_info = new String[]{'authorization_start_date','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] authorization_end_date_type_info = new String[]{'authorization_end_date','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] authorization_constraints_type_info = new String[]{'authorization_constraints','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] inauguration_type_info = new String[]{'inauguration','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] inauguration_function_type_info = new String[]{'inauguration_function','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] inauguration_duration_type_info = new String[]{'inauguration_duration','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] inauguration_date_type_info = new String[]{'inauguration_date','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] inauguration_body_type_info = new String[]{'inauguration_body','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] under_receivership_type_info = new String[]{'under_receivership','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] rights_against_third_parties_type_info = new String[]{'rights_against_third_parties','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] release_of_covenant_type_info = new String[]{'release_of_covenant','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] date_since_type_info = new String[]{'date_since','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] date_joined_type_info = new String[]{'date_joined','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] remarks_type_info = new String[]{'remarks','http://www.webservices.nl/soap/','stringArray','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'functionary','organisation','residential_address','correspondence_address','establishment_address','longest_serving','function_type','function_description','function_title','function_start_date','function_registration_date','function_end_date','function_authorization','function_authorization_description','function_authorization_start_date','function_authorization_signing_power','function_authorization_end_date','authorization_description','authorization_establishment_number','authorization_start_date','authorization_end_date','authorization_constraints','inauguration','inauguration_function','inauguration_duration','inauguration_date','inauguration_body','under_receivership','rights_against_third_parties','release_of_covenant','date_since','date_joined','remarks'};
    }
    public class DutchBusinessPositionV2Array {
        public DutchBusinessPositionV2[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessPositionV2','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class DutchBusinessNewsCompany {
        public String dossier_number;
        public String name;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] name_type_info = new String[]{'name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','name'};
    }
    public class DutchBusinessNewsCompanyArray {
        public DutchBusinessNewsCompany[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessNewsCompany','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class dutchBusinessSearchEstablishmentsRequestType {
        public String dossier_number;
        public String establishment_number;
        public String rsin_number;
        public Integer page;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_number_type_info = new String[]{'establishment_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] rsin_number_type_info = new String[]{'rsin_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] page_type_info = new String[]{'page','http://www.webservices.nl/soap/','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','establishment_number','rsin_number','page'};
    }
    public class dutchBusinessSearchEstablishmentsResponseType {
        public DutchBusinessEstablishmentReferencePagedResult out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','DutchBusinessEstablishmentReferencePagedResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class dutchBusinessGetLegalEntityRequestType {
        public String dossier_number;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number'};
    }
    public class DutchBusinessReferenceArray {
        public DutchBusinessReference[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/','DutchBusinessReference','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class DutchBusinessPersonV2 {
        public String full_name;
        public String first_name;
        public String title;
        public String initials;
        public String last_name;
        public String gender;
        public DutchBusinessDateV2 date_deceased;
        public DutchBusinessDateV2 date_of_birth;
        public String place_of_birth;
        public String country_of_birth;
        private String[] full_name_type_info = new String[]{'full_name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] first_name_type_info = new String[]{'first_name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] title_type_info = new String[]{'title','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] initials_type_info = new String[]{'initials','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] last_name_type_info = new String[]{'last_name','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] gender_type_info = new String[]{'gender','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] date_deceased_type_info = new String[]{'date_deceased','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] date_of_birth_type_info = new String[]{'date_of_birth','http://www.webservices.nl/soap/','DutchBusinessDateV2','0','1','false'};
        private String[] place_of_birth_type_info = new String[]{'place_of_birth','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] country_of_birth_type_info = new String[]{'country_of_birth','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'full_name','first_name','title','initials','last_name','gender','date_deceased','date_of_birth','place_of_birth','country_of_birth'};
    }
    public class DutchBusinessReference {
        public String dossier_number;
        public String establishment_number;
        public String trade_name;
        public String establishment_city;
        public String establishment_street;
        public String correspondence_city;
        public String correspondence_street;
        public Boolean indication_economically_active;
        private String[] dossier_number_type_info = new String[]{'dossier_number','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_number_type_info = new String[]{'establishment_number','http://www.webservices.nl/soap/','string','0','1','false'};
        private String[] trade_name_type_info = new String[]{'trade_name','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_city_type_info = new String[]{'establishment_city','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] establishment_street_type_info = new String[]{'establishment_street','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] correspondence_city_type_info = new String[]{'correspondence_city','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] correspondence_street_type_info = new String[]{'correspondence_street','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] indication_economically_active_type_info = new String[]{'indication_economically_active','http://www.webservices.nl/soap/','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'dossier_number','establishment_number','trade_name','establishment_city','establishment_street','correspondence_city','correspondence_street','indication_economically_active'};
    }
    */

}
