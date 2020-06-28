/**
 * Created by Hugo on 04/06/2020.
 */

@IsTest
public with sharing class SetupServiceImplTest {
    @IsTest
    public static void getUpdateSettingsHappyFlowTest(){
        System.runAs(TestUtils.getAdminUser()){
            Test.startTest();
            List<Protected_Subscriber_Setting__mdt> updateTypes = SetupService.getUpdateTypes();
            Test.stopTest();


            //Check response
            System.assertNotEquals(null,updateTypes);
            //Check response size = 21
            System.assertEquals(21,updateTypes.size());

            //Check fields
            System.assertNotEquals(null, updateTypes[0].Description__c);
            System.assertNotEquals(null, updateTypes[0].Enabled__c);
            System.assertNotEquals(null, updateTypes[0].External_Id__c);
        }
    }

    @IsTest
    public static void getDataSourcesPerCountryHappyFlowTest() {
        System.runAs(TestUtils.getAdminUser()) {
            // when
            Test.startTest();
            List<Datasource_Per_Country__mdt> datasourcePerCountries = SetupService.getDataSourcesPerCountry();
            Test.stopTest();

            // then
            System.assertEquals(true, datasourcePerCountries.size() > 0); // the number of records varies more than with the update types so we test only if there are records
            for (Datasource_Per_Country__mdt datasourcePerCountry : datasourcePerCountries) {
                System.assertEquals(false, datasourcePerCountry.Data_Source_Select_Record__c);
                System.assertEquals(false, String.isEmpty(datasourcePerCountry.Data_source__r.Label));
                System.assertEquals(false, String.isEmpty(datasourcePerCountry.ISO_3166_Entry__r.Label));
            }
        }
    }

//    @IsTest
//    public static void getDataSourcesPerCountryNoAccess() {
//        System.runAs(TestUtils.getDutchBusinessUser()) {
//            Test.startTest();
//            {
//                try {
//                    List<Datasource_Per_Country__mdt> datasourcePerCountries = SetupService.getDataSourcesPerCountry();
//                    //Should not reach this statement as there is an access error.
//                    System.assert(false);
//                }
//                catch (QueryException e){
//                    //Should always return a query exception due to insufficient access rights.
//                    System.assert(true);
//                }
//                catch (Exception e){
//                    //Other exception should not happen
//                    System.assert(false);
//                }
//            }
//            Test.stopTest();
//        }
//    }

    @IsTest
    public static void oneSelectedRecordPerCountryTest() {
        System.runAs(TestUtils.getAdminUser()) {
            Test.startTest();
            {
                List<Datasource_Per_Country__mdt> datasourcePerCountries = SetupService.getDataSourcesPerCountry();
                Set<Id> countryIds = new Set<Id>();
                for (Datasource_Per_Country__mdt datasourcePerCountry : datasourcePerCountries) {
                    countryIds.add(datasourcePerCountry.ISO_3166_Entry__c);
                }
                Integer nrOfSelectRows = [SELECT Count() FROM Datasource_Per_Country__mdt WHERE Data_Source_Select_Record__c = TRUE];
                System.assertEquals(countryIds.size(), nrOfSelectRows);
            }
            Test.stopTest();
        }
    }

    @IsTest
    public static void getSelectedDataSourceHappyFlow() {
        System.runAs(TestUtils.getAdminUser()) {
            Test.startTest();
            {
                List<Datasource_Per_Country__mdt> datasourcePerCountries = SetupService.getDataSourcesPerCountry();
                Set<String> countryCodes = new Set<String>();
                for (Datasource_Per_Country__mdt datasourcePerCountry : datasourcePerCountries) {
                    countryCodes.add(datasourcePerCountry.ISO_3166_Entry__r.Alpha_2_Code__c);
                }
                for (String countryCode : countryCodes) {
                    Data_source__mdt datasourcePerCountry = SetupService.getSelectedDataSource(countryCode);
                    System.assertEquals(false, datasourcePerCountry == null);
                }
            }
            Test.stopTest();
        }
    }

//    @IsTest
//    public static void getUpdateSettingsNoAccessTest(){
//        System.runAs(TestUtils.getDutchBusinessUser()){
//            Test.startTest();
//            try {
//                List<Protected_Subscriber_Setting__mdt> updateTypes = SetupService.getUpdateTypes();
//                //Should not reach this statement as there is an access error.
//                System.assert(false);
//            }
//            catch (QueryException e){
//                //Should always return a query exception due to insufficient access rights.
//                System.assert(true);
//            }
//            catch (Exception e){
//                //Other exception should not happen
//                System.assert(false);
//            }
//            Test.stopTest();
//        }
//    }


    @IsTest
    public static void setUpdateSettingsTest(){

        Map<String,Object> record1 = new Map<String,Object>{
                'developerName' => 'Activity',
                'checked' => false,
                'label' => 'Activity'
        };
        List<Map<String,Object>> l1 = new List<Map<String,Object>>();
        l1.add(record1);

        System.runAs(TestUtils.getAdminUser()){
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