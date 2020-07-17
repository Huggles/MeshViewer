/**
 * Created by vishalshete on 16/07/2020.
 */

@IsTest
public with sharing class GetNameSpaceTest {
    @IsTest
    public static void getNameSpaceApex(){
        Test.startTest();
        String namespaces = GetNameSpace.getNameSpace('GetNameSpace','Apex');
        Test.stopTest();
        System.assert(namespaces == 'appsolutely','The namespace of the class GetNameSpace should be appsolutely');

    }

    @IsTest
    public static void getNameSpaceObject(){

        Test.startTest();
        String namespaces = GetNameSpace.getNameSpace('Business_Dossier','Object');
        Test.stopTest();
        System.assert(namespaces == 'appsolutely','The namespace of the Object Business_Dossier should be appsolutely');

    }

    @IsTest
    public static void getNameSpaceCustomMetadataRecord(){

        Test.startTest();
        String namespaces = GetNameSpace.getNameSpace('BEL_Creditsafe','CustomMetadata','Datasource_Per_Country__mdt');
        Test.stopTest();
        System.assert(namespaces == 'appsolutely','The namespace of the custom metadata record BEL_Creditsafe for Custom Object Datasource_Per_Country__mdt should be appsolutely');

    }

    @IsTest
    public static void getNameSpaceApexError(){
        try {
            Test.startTest();
            String namespaces = GetNameSpace.getNameSpace('null', 'Apex');
            Test.stopTest();
        } catch (Exception e){
            System.assert(e.getMessage()=='Script-thrown exception' ,'Test class should throw an error');
        }
    }

    @IsTest
    public static void getNameSpaceObjectError(){
    try{
        Test.startTest();
        String namespaces = GetNameSpace.getNameSpace('null','Object');
        Test.stopTest();
    } catch (Exception e){

        System.assert(e.getMessage()=='Script-thrown exception' ,'Test class should throw an error');
    }

    }

    @IsTest
    public static void getNameSpaceCustomMetadataRecordError(){
        try{
            Test.startTest();
            String namespaces = GetNameSpace.getNameSpace('null','CustomMetadata','null');

            Test.stopTest();

        } catch (Exception e){
            System.assert(e.getMessage()=='Script-thrown exception' ,'Test class should throw an error');
        }
    }

}