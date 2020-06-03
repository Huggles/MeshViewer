/**
 * Created by Hugo on 02/06/2020.
 */

public with sharing class UpdateSettingSelector {


    public class UpdateSettingsWrapper{

        @AuraEnabled public string apiName {get; set;}
        @AuraEnabled public string label {get; set;}
        @AuraEnabled public boolean value {get; set;}

    }


    @AuraEnabled
    public static List<UpdateSettingsWrapper> getUpdateSettings(){
        List<UpdateSettingsWrapper> returnWrapper = new List<UpdateSettingsWrapper>();

        Update_Settings__c updateSettings = Update_Settings__c.getOrgDefaults();
        //If no updatesettings were found, first create them.
        if(updateSettings.Name == null){
            updateSettings = new Update_Settings__c();
            DMLManager.insertAsUser(updateSettings);
            updateSettings = Update_Settings__c.getOrgDefaults();
        }

        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get('appsolutely__update_settings__c').getDescribe().fields.getMap();

        //Combine the SObjectField definitions with the org defaults.
        for (String apiName: fields.keySet()) {
            //Only get the custom fields
            if(fields.get(apiName).getDescribe().isCustom()){
                string label = fields.get(apiName).getDescribe().getLabel();
                UpdateSettingsWrapper usw = new UpdateSettingsWrapper();
                usw.apiName = apiName;
                usw.label = label;
                usw.value = (updateSettings.get(apiName) == true);
                returnWrapper.add(usw);
            }
        }

        return returnWrapper;
    }
    @AuraEnabled
    public static void setUpdateSettings(List<UpdateSettingsWrapper> wrappers){
        System.debug(JSON.serialize(wrappers));
        if(wrappers == null){
            throw new AuraHandledException(Label.Error_Input_Incorrect);
        }
        Update_Settings__c updateSettings = Update_Settings__c.getOrgDefaults();
        for(UpdateSettingsWrapper usw : wrappers){
            updateSettings.put(usw.apiName, usw.value);
        }
        DMLManager.updateAsUser(updateSettings);
    }
}