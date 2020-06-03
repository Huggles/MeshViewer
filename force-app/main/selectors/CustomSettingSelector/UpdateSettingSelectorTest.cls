/**
 * Created by Hugo on 02/06/2020.
 */

@IsTest
private class UpdateSettingSelectorTest {

    @TestSetup
    static void testSetup(){

    }

    @IsTest
    static void getUpdateSettingTest() {
        System.runAs(TestUtils.getSystemAdminUser()){
            Test.startTest();
            List<UpdateSettingSelector.UpdateSettingsWrapper> updateSettings =  UpdateSettingSelector.getUpdateSettings();
            Test.stopTest();
            System.assertNotEquals(null,updateSettings);

        }
    }
    @IsTest
    static void setUpdateSettingTest() {
        System.runAs(TestUtils.getSystemAdminUser()){
            string assertionField = 'appsolutely__chamberno__c';

            List<UpdateSettingSelector.UpdateSettingsWrapper> updateSettings =  UpdateSettingSelector.getUpdateSettings();
            System.assertEquals(true,getUpdateSettingValue(updateSettings, assertionField));

            Test.startTest();
            setUpdateSettingValue(updateSettings, assertionField, false);
            UpdateSettingSelector.setUpdateSettings(updateSettings);
            Test.stopTest();

            updateSettings =  UpdateSettingSelector.getUpdateSettings();
            System.assertEquals(false,getUpdateSettingValue(updateSettings, assertionField));

        }
    }
    private static boolean getUpdateSettingValue(List<UpdateSettingSelector.UpdateSettingsWrapper> updateSettings, string apiName){
        for(UpdateSettingSelector.UpdateSettingsWrapper usw : updateSettings){
            if(usw.apiName == apiName)
                return usw.value;
        }
        return false;
    }
    private static void setUpdateSettingValue(List<UpdateSettingSelector.UpdateSettingsWrapper> updateSettings, string apiName, boolean value){
        for(UpdateSettingSelector.UpdateSettingsWrapper usw : updateSettings){
            if(usw.apiName == apiName){
                usw.value = value;
                return;
            }
        }
    }
}