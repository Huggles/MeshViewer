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
        String message = null;
        Test.startTest();
        try {
            FieldSetHelper.getFieldSetFieldDescriptions(sObjectName, 'fake');
        } catch (InputException e) {
            exceptionThrown = true;
            message = e.getMessage();
        }
        Test.stopTest();

        // then an exception should be thrown which message ends with the sobject name
        System.assert(exceptionThrown);
        System.assert(message.endsWith(sObjectName));
    }

    @IsTest
    static void testGetFieldSetFieldDescriptionsNonExistingFieldset() {
        //given
        // a good sObjectName without field sets
        String sObjectName = 'Account';
        // a fake field set
        String fieldSetName = 'fake';

        // when
        Boolean exceptionThrown = false;
        String message = null;
        Test.startTest();
        try {
            FieldSetHelper.getFieldSetFieldDescriptions(sObjectName, fieldSetName);
        } catch (InputException e) {
            exceptionThrown = true;
            message = e.getMessage();
        }
        Test.stopTest();

        // then an exception should be thrown which message ends with the sobject name
        System.assert(exceptionThrown);
        System.assert(message.endsWith(fieldSetName));
    }

    @IsTest
    static void testGetFieldSetFieldDescriptionsHappyFlow() {
        //given
        // a good sObjectName with a field set
        String sObjectName = 'appsolutely__Business_Dossier__c';
        // a good field set API name
        String fieldSetName = 'appsolutely__Creditsafe_search_result_fields';

        // when
        Boolean exceptionThrown = false;
        String message = null;
        List<FieldSetHelper.FieldDescriptionDto> fieldDescriptionDtos = null;
        Test.startTest();
        try {
            fieldDescriptionDtos = FieldSetHelper.getFieldSetFieldDescriptions(sObjectName, fieldSetName);
        } catch (InputException e) {
            exceptionThrown = true;
            message = e.getMessage();
        }
        Test.stopTest();

        // then no exception should be thrown
        System.assert(!exceptionThrown);
        System.assert(message == null);
        // fieldNames should be there and the length should be more than zero (don't want to test for exact length so we don't need to change the test every time the field set changes
        System.assert(fieldDescriptionDtos != null);
        System.assert(fieldDescriptionDtos.size() > 0);
    }

}