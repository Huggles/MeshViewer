/**
 * Created by Hugo on 23/06/2020.
 */

public with sharing class CustomRelatedListController {


    @AuraEnabled
    public static List<SObject> getChildRecords(String objectAPIName, String parentFieldAPIName, String queryFields, Id recordId){
        SObjectType type = Schema.getGlobalDescribe().get(ObjectAPIName);
        if(type == null){
            throw new AuraHandledException('Object API Name does not exist');
        }
        Map<String,Schema.SObjectField> fields = type.getDescribe().fields.getMap();

        if(fields.get(ParentFieldAPIName) == null){
            throw new AuraHandledException('Parent field does not exist');
        }
        for(String field : queryFields.split(',')){
            if(fields.get(field) == null){
                throw new AuraHandledException('Field not found: ' + field );
            }
        }

        string encodedObjectAPIName = EncodingUtil.urlEncode(objectAPIName,'UTF8');
        string encodedParentFieldAPIName = EncodingUtil.urlEncode(parentFieldAPIName,'UTF8');

        string query = 'SELECT ' + queryFields + ' FROM ' + encodedObjectAPIName + ' WHERE ' + encodedParentFieldAPIName + ' = \'' + recordId + '\'';

        System.debug(query);

        List<SObject> results = Database.query(query);
        return results;
    }

}