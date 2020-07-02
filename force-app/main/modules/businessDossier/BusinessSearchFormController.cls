/**
 * Created by jaapbranderhorst on 28/06/2020.
 */

public with sharing class BusinessSearchFormController {

    public class CountryOption {

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String value;

        public CountryOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<CountryOption> getCountryOptions() {
        Map<String, String> alpha2CodeByCountryName = BusinessService.getCountryOptionsForBusinessSearch();
        List<CountryOption> returnValue = new List<BusinessSearchFormController.CountryOption>();
        for (String countryName : alpha2CodeByCountryName.keySet()) {
            returnValue.add(new CountryOption(countryName, alpha2CodeByCountryName.get(countryName)));
        }
        return returnValue;
    }

    @AuraEnabled
    public static String getSelectedDataSource(String alpha2CountryCode) {
        Data_source__mdt dataSource = SetupService.getSelectedDataSource(alpha2CountryCode);
        System.debug('country code: ' + alpha2CountryCode);
        System.debug('datasource: ' + JSON.serializePretty(dataSource));
        return dataSource.DeveloperName;
    }

}