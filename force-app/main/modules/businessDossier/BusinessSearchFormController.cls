/**
 * Created by jaapbranderhorst on 28/06/2020.
 */

public with sharing class BusinessSearchFormController {

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getCountryOptions() {
        return BusinessService.getCountryOptionsForBusinessSearch();
    }

    @AuraEnabled
    public static String getSelectedDataSource(String alpha2CountryCode) {
        Data_source__mdt dataSource = SetupService.getSelectedDataSource(alpha2CountryCode);
        return dataSource.DeveloperName;
    }

}