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
    public static AuraResponseWrapper getCountryOptions() {
        try {
            Map<String, String> alpha2CodeByCountryName = BusinessService.getCountryOptionsForBusinessSearch();
            List<CountryOption> returnValue = new List<BusinessSearchFormController.CountryOption>();
            for (String countryName : alpha2CodeByCountryName.keySet()) {
                returnValue.add(new CountryOption(countryName, alpha2CodeByCountryName.get(countryName)));
            }
            return new AuraResponseWrapper(returnValue);
        } catch (Exception ex) {
            return new AuraResponseWrapper(ex, true, true);
        }

    }

    @AuraEnabled
    public static AuraResponseWrapper getSelectedDataSource(String alpha2CountryCode) {
        try {
            Data_source__mdt dataSource = SetupService.getSelectedDataSource(alpha2CountryCode);
            return new AuraResponseWrapper(dataSource.DeveloperName);
        } catch (Exception ex) {
            return new AuraResponseWrapper(ex, true, true);
        }

    }

}