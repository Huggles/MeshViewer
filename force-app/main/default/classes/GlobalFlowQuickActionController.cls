/**
 * Created by jaapbranderhorst on 07/03/2020.
 */

/**
 * Apex Controller for aura component createAccountBasedOnCompanyInfoAction
 */
public with sharing class GlobalFlowQuickActionController {

    private static String FLOW_SETTING_KEY = 'Create_Account_Flow_API_Name';

    /**
     * Returns the name of the flow as configured in the Flow_Setting with developername FLOW_SETTING_KEY.
     * Throws a CIConfigurationException if the Flow_Setting is not found or the value is null.
     * @return
     */
    @AuraEnabled(cacheable=true)
    public static String getFlowAPIName(String flowSettingName) {
        // TODO: move this to a Configuration Utility class.
        try {
            List<Flow_Settings__mdt> flowSettings = [SELECT Value__c FROM Flow_Settings__mdt WHERE DeveloperName = :flowSettingName LIMIT 1];
            if (flowSettings != null && flowSettings.size() == 1 && !String.isEmpty(flowSettings[0].Value__c)) {
                return flowSettings[0].Value__c;
            } else {
                // TODO: change Label
                throw new CIConfigurationException(Label.Config_Account_ActivateDescription);
            }
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex);
            throw ex;
        }

    }


}