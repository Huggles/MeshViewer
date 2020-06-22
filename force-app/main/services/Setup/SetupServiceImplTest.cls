/**
 * Created by Hugo on 04/06/2020.
 */

@IsTest
public with sharing class SetupServiceImplTest {

    @TestSetup
    public static void testSetup(){

    }

    @IsTest
    public static void getUpdateSettingsTest(){
        System.runAs(TestUtils.getCompanyInfoAdmin()){
            Test.startTest();
            List<Protected_Subscriber_Setting__mdt> updateTypes = SetupService.getUpdateTypes();
            Test.stopTest();

            System.assertNotEquals(null,updateTypes);
            System.assertNotEquals(0,updateTypes.size());
        }
    }
    @IsTest
    public static void setUpdateSettingsTest(){

        Map<String,Object> record1 = new Map<String,Object>{
                'developerName' => 'Activity',
                'checked' => false,
                'label' => 'Activity'
        };
        List<Map<String,Object>> l1 = new List<Map<String,Object>>();
        l1.add(record1);

        Map<String,Object> record2 = new Map<String,Object>{
                'developerName' => 'Activity',
                'checked' => true,
                'label' => 'Activity'
        };
        List<Map<String,Object>> l2 = new List<Map<String,Object>>();
        l1.add(record2);

        System.runAs(TestUtils.getCompanyInfoAdmin()){
            //Run with checked=true and checked=false to make sure it runs all scenarios.
            Test.startTest();
            try{
                SetupService.setUpdateTypes(l1);
                SetupService.setUpdateTypes(l2);
            }catch (Exception e){
                System.assertEquals(Label.Error_updating_update_type_settings, e.getMessage());
            }
            Test.stopTest();
        }
    }


}