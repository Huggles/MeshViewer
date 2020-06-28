/**
 * Created by jaapbranderhorst on 26/06/2020.
 */

public with sharing class ConfigOrgPerCountryDataSourceController {

    public class DataSourceOption {

        @AuraEnabled
        public String label { get; set; }

        @AuraEnabled
        public String value { get; set; }

        public DataSourceOption(Datasource_Per_Country__mdt datasourcePerCountry) {
            this.label = datasourcePerCountry.Data_source__r.Label;
            this.value = datasourcePerCountry.Data_source__r.DeveloperName;
        }
    }

    public class DataSourcesPerCountry {
        @AuraEnabled
        public String country { get; set; }

        @AuraEnabled
        public String countryCode {get; set;}

        @AuraEnabled
        public String selectedDataSource {get; set;}

        @AuraEnabled
        public List<DataSourceOption> dataSourceOptions { get; set; }

        public DataSourcesPerCountry(String countryCode, List<Datasource_Per_Country__mdt> datasourcePerCountriesOptions) {
            Datasource_Per_Country__mdt datasourcePerCountry = datasourcePerCountriesOptions.get(0);
            this.country = datasourcePerCountry.ISO_3166_Entry__r.Country_Name__c;
            this.countryCode = datasourcePerCountry.ISO_3166_Entry__r.Country_Code__c;
            this.selectedDataSource = SetupService.getSelectedDataSource(this.countryCode).DeveloperName;
            List<DataSourceOption> dataSourceOptions = new List<DataSourceOption>();
            for (Datasource_Per_Country__mdt datasourcePerCountry2 : datasourcePerCountriesOptions) {
                dataSourceOptions.add(new DataSourceOption(datasourcePerCountry2));
            }
            this.dataSourceOptions = dataSourceOptions;
        }

        public DataSourcesPerCountry() {}
    }

    @AuraEnabled(Cacheable=true)
    public static List<DataSourcesPerCountry> getDataSourcesPerCountry() {
        try {
            List<Datasource_Per_Country__mdt> datasourcePerCountries = SetupService.getDataSourcesPerCountry();
            List<DataSourcesPerCountry> returnValue = new List<DataSourcesPerCountry>();
            Map<String, List<Datasource_Per_Country__mdt>> datasourcePerCountriesByCountryCode = new Map<String, List<Datasource_Per_Country__mdt>>();
            for (Datasource_Per_Country__mdt datasourcePerCountry : datasourcePerCountries) {
                String countryCode = datasourcePerCountry.ISO_3166_Entry__r.Country_Code__c;
                List<Datasource_Per_Country__mdt> datasourcePerCountries2 = datasourcePerCountriesByCountryCode.get(countryCode);
                if (datasourcePerCountries2 == null) {
                    datasourcePerCountries2 = new List<Datasource_Per_Country__mdt>();
                    datasourcePerCountriesByCountryCode.put(countryCode, datasourcePerCountries2);
                }
                datasourcePerCountries2.add(datasourcePerCountry);
            }
            for (String countryCode : datasourcePerCountriesByCountryCode.keySet()) {
                returnValue.add(new DataSourcesPerCountry(countryCode, datasourcePerCountriesByCountryCode.get(countryCode)));
            }
            return returnValue;
        }catch (Exception e){
            ErrorLogUtil.logException(e,true);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void setDataSourcePerCountry(List<DataSourcesPerCountry> dataSourcesPerCountries) {
        try {
            System.debug('dataSourcesPerCountries: ' + JSON.serializePretty(dataSourcesPerCountries));
            Map<String, String> selectedDataSourceByCountryId = new Map<String, String>();
            for (DataSourcesPerCountry dataSourcesPerCountry : dataSourcesPerCountries) {
                selectedDataSourceByCountryId.put(dataSourcesPerCountry.countryCode, dataSourcesPerCountry.selectedDataSource);
            }
            System.debug('selectedDataSourceByCountryId:  ' + JSON.serializePretty(selectedDataSourceByCountryId));
            SetupService.setDataSourcePerCountry(selectedDataSourceByCountryId);
        } catch(Exception e) {
            ErrorLogUtil.logException(e,true);
            throw new AuraHandledException(e.getMessage());
        }
    }

}