/**
 * Created by Hugo on 04/06/2020.
 */

@IsTest
public with sharing class ConfigUpdateTypeControllerTest {
    @IsTest
    public static void getUpdateSettingsHappyFlowTest(){
        System.runAs(CompanyInfoTestUserFactory.getAdminUser()){
            Test.startTest();
            List<Protected_Subscriber_Setting__mdt> updateTypes = ConfigUpdateTypeController.getUpdateTypes();
            Test.stopTest();

            //Check response != null
            System.assertNotEquals(null,updateTypes);

            //Check response size = 21
            System.assertEquals(21,updateTypes.size());

            //Check fields
            System.assertNotEquals(null, updateTypes[0].Description__c);
            //Check fields
            System.assertNotEquals(null, updateTypes[0].Enabled__c);
            //Check fields
            System.assertNotEquals(null, updateTypes[0].External_Id__c);
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

        System.runAs(CompanyInfoTestUserFactory.getAdminUser()){
            //Deploying custom metadata cannot be tested/mocked. It will always throw an error.
            Test.startTest();
            try{
                ConfigUpdateTypeController.setUpdateTypes(l1);
                //Code should never come here, as test method cannot setUpdateType.
                //Should always return AuraHandledException
                System.assert(false);
            }catch (AuraHandledException e){
                //Should always return AuraHandledException
                System.assert(true);
            }catch (Exception e){
                //No other exceptions
                System.assert(false);
            }
            Test.stopTest();
        }
    }
}