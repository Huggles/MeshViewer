/**
 * Created by jaapbranderhorst on 28/03/2020.
 */

@IsTest
private class SettingUtilsTest {
    @IsTest
    static void testGetSettingsHappyFlow() {
        // given
        // an existing setting (from the ErrorLogUtil functionality)
        String settingName = ErrorLogUtil.ERROR_LOG_SETTING_EMAIL;

        // when
        Test.startTest();
        String value = SettingUtils.getSetting(settingName);
        Test.stopTest();

        // then
        System.assert(!String.isEmpty(value));
    }
}