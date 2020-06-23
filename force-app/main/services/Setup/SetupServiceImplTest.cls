/**
 * Created by Hugo on 04/06/2020.
 */

@IsTest
public with sharing class SetupServiceImplTest {
    @IsTest
    public static void getUpdateSettingsHappyFlowTest(){
        System.runAs(TestUtils.getCompanyInfoAdmin()){
            Test.startTest();
            List<Protected_Subscriber_Setting__mdt> updateTypes = SetupService.getUpdateTypes();
            Test.stopTest();


            //Check response
            System.assertNotEquals(null,updateTypes);
            System.assertNotEquals(0,updateTypes.size());

            //Check fields
            System.assertNotEquals(null, updateTypes[0].Description__c);
            System.assertNotEquals(null, updateTypes[0].Enabled__c);
            System.assertNotEquals(null, updateTypes[0].External_Id__c);
        }
    }

    @IsTest
    public static void getUpdateSettingsNoAccessTest(){
        System.runAs(TestUtils.getCompanyInfoBusinessUser()){
            Test.startTest();
            try {
                List<Protected_Subscriber_Setting__mdt> updateTypes = SetupService.getUpdateTypes();
                //Should not reach this statement as there is an access error.
                System.assert(false);
            }
            catch (QueryException e){
                //Should always return a query exception due to insufficient access rights.
                System.assert(true);
            }
            catch (Exception e){
                //Other exception should not happen
                System.assert(false);
            }
            Test.stopTest();
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

        System.runAs(TestUtils.getCompanyInfoAdmin()){
            //Deploying custom metadata cannot be tested/mocked. It will always throw an error.
            Test.startTest();
            try{
                SetupService.setUpdateTypes(l1);
            }catch (Exception e){
                //Should always return an exception due to the fact that this function cannot be run in test methods.
                System.assertEquals(Label.Error_updating_update_type_settings, e.getMessage());
            }
            Test.stopTest();
        }
    }
}