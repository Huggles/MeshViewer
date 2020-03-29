/**
 * Created by jaapbranderhorst on 28/03/2020.
 */

public inherited sharing class SettingUtils {

    /**
    * Retrieves a setting with the given name. Throws and logs an exception if the setting cannot be found
    *
    * @param settingName name of the setting
    *
    * @return the value of the setting
    */
    public static String getSetting(String settingName) {
        try {
            String value = ([SELECT Value__c FROM Setting__mdt WHERE DeveloperName = :settingName LIMIT 1]).Value__c;
            return value;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex);
            throw ex;
        }
    }

    /**
    * Retrieves a subscriber setting with the given name. Throws and logs an exception if the setting cannot be found
    *
    * @param settingName name of the subscriber setting
    *
    * @return the value of the setting
    */
    public static String getSubscriberSetting(String settingName) {
        try {
            String value = ([SELECT Value__c FROM Subscriber_Setting__mdt WHERE DeveloperName = :settingName LIMIT 1]).Value__c;
            return value;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex);
            throw ex;
        }
    }

}