/**
 * Created by Hugo on 02/06/2020.
 */

public with sharing class UpdateSettingSelector {

    @AuraEnabled
    public static Update_Settings__c getUpdateSettings(){
        Update_Settings__c updateSettings = Update_Settings__c.getOrgDefaults();
        if(updateSettings.Name == null){
            updateSettings = new Update_Settings__c();
            insert updateSettings;
            updateSettings = Update_Settings__c.getOrgDefaults();
        }
        return updateSettings;
    }
    @AuraEnabled
    public static void setUpdateSettings(Update_Settings__c updateSettings){
        if(updateSettings == null){
            throw new AuraHandledException(Label.Error_Input_Incorrect);
        }
        DMLManager.updateAsUser(updateSettings);
    }
}