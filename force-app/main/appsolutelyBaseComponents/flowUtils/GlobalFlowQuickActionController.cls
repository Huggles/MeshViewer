/**
 * Created by jaapbranderhorst on 07/03/2020.
 */

/**
 * Apex Controller for aura component createAccountBasedOnCompanyInfoAction
 */
public with sharing class GlobalFlowQuickActionController {

    /**
     * Returns the name of the flow as configured in the Subscriber settings with developername FLOW_SETTING_KEY.
     * Throws a CIConfigurationException if the Flow_Setting is not found or the value is null.
     *
     * @param flowSettingName the developer name of the subscriber setting
     * @return either the found flow API name or an AuraHandledException telling the flow setting name could not be found
     */
    @AuraEnabled(cacheable=true)
    public static Object getFlowAPIName(String flowSettingName) {
        try {
            String value = SettingUtils.getSubscriberSetting(flowSettingName);
            if (String.isEmpty(value)) {
                throw new CIConfigurationException();
            }
            return value;
        } catch (CIConfigurationException ex) {
            throw new AuraHandledException('Flow Setting Name ' + flowSettingName + ' not found.');
        } catch (Exception ex) {
            // TODO: migrate to AuraResponseWrapper
            // ErrorLogUtil.logException(ex);
            throw new AuraHandledException('Exception occured: ' + ex.getMessage());
        }
    }


}