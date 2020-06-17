/**
 * Created by Hugo on 04/06/2020.
 */

public with sharing class CompanyInfoUpdateTypeController {

    @AuraEnabled
    public static List<Protected_Subscriber_Setting__mdt> getUpdateTypes() {
        return SetupService.getUpdateTypes();
    }

    @AuraEnabled
    public static Id setUpdateTypes(List<Map<string, object>> payload) {
        return SetupService.setUpdateTypes(payload);
    }
}