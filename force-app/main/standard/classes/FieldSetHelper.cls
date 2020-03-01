/**
 * Created by jaapbranderhorst on 01/03/2020.
 */

public with sharing class FieldSetHelper {

    /**
     * Returns the field names defined in the fieldset with name fieldSetName and defined for sObject objectName
     *
     * @param objectName
     * @param fieldSetName
     *
     * @return
     */
    @AuraEnabled(Cacheable=true)
    public static List<String> getFieldSetFieldNames(String objectName, String fieldSetName) {
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
        if (sObjectTypeObj == null) {
            Exception e = new InputException('No sObjectType found for given object name ' + objectName);
            ErrorLogUtil.logException(e);
            throw e;
        }
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        if (fieldSetObj == null) {
            Exception e = new InputException('No field set found for given fieldset name ' + fieldSetName);
            ErrorLogUtil.logException(e);
            throw e;
        }
        List<String> apiNames = new List<String>();
        for (Schema.FieldSetMember fieldSetMember : fieldSetObj.getFields()) {
            apiNames.add(fieldSetMember.getFieldPath());
        }
        return apiNames;
    }

}