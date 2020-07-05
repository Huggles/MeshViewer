/**
 * Created by jaapbranderhorst on 01/03/2020.
 */

public without sharing class FieldSetHelper {

    public inherited sharing class FieldDescriptionDto {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String apiName;

        public FieldDescriptionDto(String label, String apiName) {
            this.label = label;
            this.apiName = apiName;
        }
    }


    /**
     * Returns the field definitions (API name, label) defined in the fieldset with name fieldSetName and defined for sObject objectName
     *
     * @param objectName
     * @param fieldSetName
     *
     * @return
     */
    @AuraEnabled(Cacheable=true)
    public static AuraResponseWrapper getFieldSetFieldDescriptions(String objectName, String fieldSetName) {
        try {
            Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
            Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
            if (sObjectTypeObj == null) {
                Exception e = new InputException('No sObjectType found for given object name ' + objectName);
                throw e;
            }
            Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
            Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
            if (fieldSetObj == null) {
                Exception e = new InputException('No field set found for given fieldset name ' + fieldSetName);
                throw e;
            }
            List<FieldDescriptionDto> fieldDescriptionDtos = new List<FieldDescriptionDto>();
            for (Schema.FieldSetMember fieldSetMember : fieldSetObj.getFields()) {
                fieldDescriptionDtos.add(new FieldDescriptionDto(fieldSetMember.getLabel(), fieldSetMember.getFieldPath()));
            }
            return new AuraResponseWrapper(fieldDescriptionDtos);
        } catch (Exception ex) {
            return new AuraResponseWrapper(ex, true, true );
        }

    }

}