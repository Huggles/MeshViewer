/**
 * Created by jaapbranderhorst on 07/03/2020.
 */

/**
 * Apex Controller for aura component createAccountBasedOnCompanyInfoAction
 */
public with sharing class GlobalFlowQuickActionController {

    private static String FLOW_SETTING_KEY = 'Create_Account_Flow_API_Name';

    /**
     * Returns the name of the flow as configured in the Subscriber settings with developername FLOW_SETTING_KEY.
     * Throws a CIConfigurationException if the Flow_Setting is not found or the value is null.
     *
     * @param flowSettingName the developer name of the subscriber setting
     * @return either the found flow API name or an AuraResponseWrapper containing an error
     */
    @AuraEnabled(cacheable=true)
    public static Object getFlowAPIName(String flowSettingName) {
        try {
            String value = SettingUtils.getSubscriberSetting(flowSettingName);
            if (String.isEmpty(value)) {
                Exception ex = new CIConfigurationException(Label.Config_Account_ActivateDescription);
                throw ex;
            }
            return value;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex);
            return new AuraResponseWrapper(ex, System.Label.Error);
        }
    }


}