/**
 * Created by jaapbranderhorst on 28/06/2020.
 */

public with sharing class BusinessSearchFormController {

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getCountryOptions() {
        return BusinessService.getCountryOptionsForBusinessSearch();
    }

}