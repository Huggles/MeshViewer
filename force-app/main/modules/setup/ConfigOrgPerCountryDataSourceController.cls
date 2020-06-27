/**
 * Created by jaapbranderhorst on 26/06/2020.
 */

public with sharing class ConfigOrgPerCountryDataSourceController {

    public class DataSourcesPerCountry {
        @AuraEnabled
        public String country { get; set; }

        @AuraEnabled
        public String countryCode {get; set;}

        @AuraEnabled
        public String selectedDataSource {get; set;}

        @AuraEnabled
        public List<String> dataSourceOptions { get; set;}

        public DataSourcesPerCountry(Datasource_Per_Country__mdt datasourcePerCountry) {
            this.country = datasourcePerCountry.ISO_3166_Entry__r.Label;
            this.countryCode = datasourcePerCountry.ISO_3166_Entry__r.Country_Code__c;
            this.selectedDataSource = SetupService.getSelectedDataSource(this.countryCode).Label;
            // TODO: options
        }
    }

    @AuraEnabled(Cacheable=true)
    public static List<DataSourcesPerCountry> getDataSourcesPerCountry() {
        try {
            List<Datasource_Per_Country__mdt> datasourcePerCountries = SetupService.getDataSourcesPerCountry();
            List<DataSourcesPerCountry> dataSourcesPerCountriesAura = new List<DataSourcesPerCountry>();
            for (Datasource_Per_Country__mdt datasourcePerCountry : datasourcePerCountries) {
                dataSourcesPerCountriesAura.add(new DataSourcesPerCountry(datasourcePerCountry));
            }
            return dataSourcesPerCountriesAura;
        }catch (Exception e){
            ErrorLogUtil.logException(e,true);
            throw new AuraHandledException(e.getMessage());
        }

    }

}