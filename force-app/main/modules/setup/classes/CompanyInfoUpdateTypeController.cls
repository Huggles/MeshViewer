/**
 * Created by Hugo on 04/06/2020.
 */

public with sharing class CompanyInfoUpdateTypeController {

    @AuraEnabled
    public static List<Protected_Subscriber_Setting__mdt> getUpdateTypes() {
        try {
            return SetupService.getUpdateTypes();
        }catch (Exception e){
            ErrorLogUtil.logException(e,true);
            throw new AuraHandledException(e.getMessage());
        }

    }

    @AuraEnabled
    public static Id setUpdateTypes(List<Map<string, object>> payload) {
        try {
            return SetupService.setUpdateTypes(payload);
        }catch (Exception e){
            ErrorLogUtil.logException(e,true);
            throw new AuraHandledException(e.getMessage());
        }
    }
}