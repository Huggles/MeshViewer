/**
 * Created by vishalshete on 16/07/2020.
 */

@IsTest
public with sharing class GetNameSpaceTest {
    @TestSetup
    public static void createTestData() {
        User usr;
        Profile p1 = [SELECT Id,Name FROM Profile WHERE  UserLicense.Name != 'Salesforce' LIMIT 1];
        System.debug(p1.Name);

        PermissionSet ps =[SELECT Profile.Id,ProfileId, profile.name
        FROM PermissionSet
        WHERE IsOwnedByProfile = true
        AND Profile.UserType = 'Standard'
        AND Id NOT IN (SELECT ParentId
        FROM ObjectPermissions
        WHERE SObjectType = 'appsolutely__Business_Dossier__c '
        AND PermissionsRead = false)
        LIMIT 1];

        if (p1 != null) {
            //create a user with the profile found that doesn't have access to the Account object
            usr = new User(
                    firstName = 'testUsrF',
                    LastName = 'testUsrL',
                    Alias = 'tstUsr',
                    Email = 'testy.test@test.com',
                    UserName = 'test@user99@test.com',
                    EmailEncodingKey = 'ISO-8859-1',
                    LanguageLocaleKey = 'en_US',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    ProfileId = ps.ProfileId,
                    IsActive = true
            );
            insert usr;
        }
    }
    @IsTest
    public static void getNameSpaceApex() {
        Test.startTest();
        String namespaces = GetNameSpace.getNameSpace('GetNameSpace', 'Apex');
        Test.stopTest();
        System.assert(namespaces == 'appsolutely', 'The namespace of the class GetNameSpace should be appsolutely');

    }

    @IsTest
    public static void getNameSpaceObject() {

        Test.startTest();
        String namespaces = GetNameSpace.getNameSpace('Business_Dossier', 'Object');
        Test.stopTest();
        System.assert(namespaces == 'appsolutely', 'The namespace of the Object Business_Dossier should be appsolutely');

    }

    @IsTest
    public static void getNameSpaceCustomMetadataRecord() {

        Test.startTest();
        String namespaces = GetNameSpace.getNameSpace('BEL_Creditsafe', 'CustomMetadata', 'Datasource_Per_Country__mdt');
        Test.stopTest();
        System.assert(namespaces == 'appsolutely', 'The namespace of the custom metadata record BEL_Creditsafe for Custom Object Datasource_Per_Country__mdt should be appsolutely');

    }

    @IsTest
    public static void getNameSpaceApexError() {
        try {
            Test.startTest();
            String namespaces = GetNameSpace.getNameSpace('null', 'Apex');
            Test.stopTest();
        } catch (Exception e) {
            System.assert(e.getMessage() == 'Script-thrown exception', 'Test class should throw an error');
        }
    }

    @IsTest
    public static void getNameSpaceObjectError() {
        try {
            Test.startTest();
            String namespaces = GetNameSpace.getNameSpace('null', 'Object');
            Test.stopTest();
        } catch (Exception e) {

            System.assert(e.getMessage() == 'Script-thrown exception', 'Test class should throw an error');
        }

    }

    @IsTest
    public static void getNameSpaceCustomMetadataRecordError() {
        try {
            Test.startTest();
            String namespaces = GetNameSpace.getNameSpace('null', 'CustomMetadata', 'null');

            Test.stopTest();

        } catch (Exception e) {
            System.assert(e.getMessage() == 'Script-thrown exception', 'Test class should throw an error');
        }
    }
    @IsTest
    public static void getNameSpaceCustomMetadataRecordAccessError() {
        try {
            User u = [SELECT Id,Profile.Name FROM User WHERE Email = 'testy.test@test.com' LIMIT 1];
            System.debug(u.Profile.Name);
            System.runAs(u) {
                Test.startTest();
                String namespaces = GetNameSpace.getNameSpace('BEL_Creditsafe', 'CustomMetadata', 'Datasource_Per_Country__mdt');
                Test.stopTest();
            }

        } catch (Exception e) {
            System.assert(e.getMessage() == 'Script-thrown exception', 'Test class should throw an error');
        }
    }
    @IsTest
    public static void throwCustomExceptionTest() {
        Test.startTest();
        GetNameSpace.throwCustomException('Custom Object');
        Test.stopTest();
        System.assert([SELECT Id FROM Error_Log__c].size() == 1, 'There should be one error message inserted');
    }

}