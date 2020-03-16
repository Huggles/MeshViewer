/**
 * Created by jaapbranderhorst on 12/03/2020.
 */

public inherited sharing class Iso3166CountryPickListController {

    public inherited sharing class  Iso3166Option {

        @AuraEnabled
        public String country { get; set; }

        @AuraEnabled
        public String alpha3Code {get; set; }

        @AuraEnabled
        public String countryCode { get; set; }

        @AuraEnabled
        public String alpha2Code {get; set;}

        public Iso3166Option(String country, String alpha2Code, String alpha3Code, String countryCode) {
            this.country = country;
            this.alpha2Code = alpha2Code;
            this.alpha3Code = alpha3Code;
            this.countryCode = countryCode;
        }
    }

    /**
     * loads all ISO3166 metadata fields and returns them as options for a picklist
     *
     * @return
     */
    @AuraEnabled(cacheable=true)
    public static List<Iso3166Option> getIso3166Options() {
        List<ISO_3166_Entry__mdt> iso3166Entries = [SELECT Alpha_2_Code__c, Country_Code__c, Country_Name__c, Label FROM ISO_3166_Entry__mdt ORDER BY Country_Name__c];
        List<Iso3166Option> options = new List<Iso3166CountryPickListController.Iso3166Option>();
        for (ISO_3166_Entry__mdt o3166Entry : iso3166Entries) {
            options.add(new Iso3166Option(o3166Entry.Country_Name__c, o3166Entry.Alpha_2_Code__c, o3166Entry.Label, o3166Entry.Country_Code__c));
        }
        return options;
    }

    /**
     * Returns the DTO (option object) containing the Iso3166 information belonging to the given alpha2Code
     *
     * @param alpha2Code
     *
     * @return
     */
    @AuraEnabled(cacheable=true)
    public static Iso3166Option getIsO3166OptionByAlpha2Code(String alpha2Code) {
        alpha2Code = alpha2Code.toUpperCase();
        ISO_3166_Entry__mdt o3166Entry = [SELECT Alpha_2_Code__c, Country_Code__c, Country_Name__c, Label FROM ISO_3166_Entry__mdt WHERE Alpha_2_Code__c =:alpha2Code LIMIT 1];
        return new Iso3166Option(o3166Entry.Country_Name__c, o3166Entry.Alpha_2_Code__c, o3166Entry.Label, o3166Entry.Country_Code__c);
    }

}