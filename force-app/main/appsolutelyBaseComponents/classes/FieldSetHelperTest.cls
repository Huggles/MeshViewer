/**
 * Created by jaapbranderhorst on 01/03/2020.
 */

@IsTest
private class FieldSetHelperTest {

    @IsTest
    static void testGetFieldSetFieldDescriptionsWrongSobject() {
        //given
        // a dummy sobject name
        String sObjectName = 'fake__c';

        // when
        Boolean exceptionThrown = false;
        Test.startTest();
        Object responseWrapper = FieldSetHelper.getFieldSetFieldDescriptions(sObjectName, 'fake');
        Test.stopTest();

        // then an exception should be thrown which message ends with the sobject name
        System.assert(responseWrapper instanceof AuraResponseWrapper);
        System.assertEquals('ERROR', ((AuraResponseWrapper)responseWrapper).state);
        System.assertNotEquals(null, ((AuraResponseWrapper)responseWrapper).error);
        System.assertEquals(null, ((AuraResponseWrapper)responseWrapper).data);
        System.assert(((AuraResponseWrapper)responseWrapper).error.message.endsWith(sObjectName));
    }

    @IsTest
    static void testGetFieldSetFieldDescriptionsNonExistingFieldset() {
        //given
        // a good sObjectName without field sets
        String sObjectName = 'Account';
        // a fake field set
        String fieldSetName = 'fake';

        // when
        Test.startTest();
        Object responseWrapper =    FieldSetHelper.getFieldSetFieldDescriptions(sObjectName, fieldSetName);
        Test.stopTest();

        System.assert(responseWrapper instanceof AuraResponseWrapper);
        System.assertEquals('ERROR', ((AuraResponseWrapper)responseWrapper).state);
        System.assertNotEquals(null, ((AuraResponseWrapper)responseWrapper).error);
        System.assertEquals(null, ((AuraResponseWrapper)responseWrapper).data);
        System.assert(((AuraResponseWrapper)responseWrapper).error.message.endsWith(fieldSetName));
    }

    @IsTest
    static void testGetFieldSetFieldDescriptionsHappyFlow() {
        //given
        // a good sObjectName with a field set
        String sObjectName = 'appsolutely__Business_Dossier__c';
        // a good field set API name
        String fieldSetName = 'appsolutely__Creditsafe_search_result_fields';

        // when
        List<FieldSetHelper.FieldDescriptionDto> fieldDescriptionDtos = null;
        Test.startTest();
        Object responseWrapper = FieldSetHelper.getFieldSetFieldDescriptions(sObjectName, fieldSetName);
        Test.stopTest();

        // then no exception should be thrown
        System.assertEquals('SUCCESS', ((AuraResponseWrapper)responseWrapper).state);
        System.assertEquals(true, (( List<FieldSetHelper.FieldDescriptionDto>)((AuraResponseWrapper)responseWrapper).data).size() > 0);
    }

}