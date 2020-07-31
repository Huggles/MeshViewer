/**
 * Created by jaapbranderhorst on 28/03/2020.
 */

@IsTest
private class SettingUtilsTest {

    private final static String SUBSCRIBER_SETTING_TEST_SETTING_NAME = 'Test';

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

    @IsTest
    static void testGetSubscriberSettingsHappyFlow() {
        // given
        // an existing setting (from the ErrorLogUtil functionality)
        String settingName = SUBSCRIBER_SETTING_TEST_SETTING_NAME;

        // when
        Test.startTest();
        String value = SettingUtils.getSubscriberSetting(settingName);
        Test.stopTest();

        // then
        System.assert(!String.isEmpty(value));
    }

    @IsTest
    static void testGetProtectedSettingsHappyFlow() {
        // given
        // an existing setting (from the ErrorLogUtil functionality)
        String settingName = SetupServiceImpl.UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME;

        // when
        Test.startTest();
        String value = SettingUtils.getProtectedSetting(settingName);
        Test.stopTest();

        // then
        System.assert(!String.isEmpty(value));
    }
}