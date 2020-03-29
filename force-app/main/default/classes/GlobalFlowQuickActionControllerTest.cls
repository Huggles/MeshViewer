/**
 * Created by jaapbranderhorst on 07/03/2020.
 */

@IsTest
private class GlobalFlowQuickActionControllerTest {
    @IsTest
    static void testGetFlowAPINameNoFlowSetting() {
        // given
        // no flow setting
        String flowSettingName = 'fake';

        // when
        Boolean exceptionThrown = false;
        Test.startTest();
        Object response = GlobalFlowQuickActionController.getFlowAPIName(flowSettingName);
        Test.stopTest();

        // then
        // an exception should be thrown
        System.assert(response instanceof AuraResponseWrapper);
        System.assert(!String.isEmpty(((AuraResponseWrapper)response).errorMsg));
    }

    @IsTest
    static void testGetFlowAPINameHappyFlow() {
        // given
        // existing flow setting
        String flowSettingName = 'Create_Account_Flow_API_Name';

        // when
        Boolean exceptionThrown = false;
        String flowName = null;
        Test.startTest();
        try {
            flowName = (String)GlobalFlowQuickActionController.getFlowAPIName(flowSettingName);
        } catch (CIConfigurationException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        // then
        // no exception should be thrown
        System.assert(!exceptionThrown);
        System.assert(flowName == 'Create_Account_based_on_Company_info_data');
    }
}