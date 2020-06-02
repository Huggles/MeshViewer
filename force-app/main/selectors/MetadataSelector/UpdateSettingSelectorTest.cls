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
            Update_Settings__c updateSettings =  UpdateSettingSelector.getUpdateSettings();
            Test.stopTest();
            System.assertNotEquals(null,updateSettings);
        }

    }
    @IsTest
    static void setUpdateSettingTest() {
        System.runAs(TestUtils.getSystemAdminUser()){
            Update_Settings__c updateSettings =  UpdateSettingSelector.getUpdateSettings();
            Test.startTest();
            UpdateSettingSelector.setUpdateSettings(updateSettings);
            Test.stopTest();
            System.assertNotEquals(null,updateSettings);
        }
    }
}