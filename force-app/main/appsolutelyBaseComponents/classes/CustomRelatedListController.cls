/**
 * Created by Hugo on 23/06/2020.
 */

public with sharing class CustomRelatedListController {


    @AuraEnabled
    public static List<Map<String,Object>> getChildRecords(String objectAPIName, String parentFieldAPIName, String queryFields, Id recordId){
        SObjectType type = Schema.getGlobalDescribe().get(ObjectAPIName);
        if(type == null){
            throw new AuraHandledException('Object API Name does not exist');
        }
        Map<String,Schema.SObjectField> fields = type.getDescribe().fields.getMap();

        if(fields.get(ParentFieldAPIName) == null){
            throw new AuraHandledException('Parent field does not exist');
        }

        string encodedObjectAPIName = EncodingUtil.urlEncode(objectAPIName,'UTF8');
        string encodedParentFieldAPIName = EncodingUtil.urlEncode(parentFieldAPIName,'UTF8');

        string query = 'SELECT ' + queryFields + ' FROM ' + encodedObjectAPIName + ' WHERE ' + encodedParentFieldAPIName + ' = \'' + recordId + '\'';

        System.debug(query);

        List<SObject> results = Database.query(query);

        List<Map<String,Object>> flattenedResults = new List<Map<String,Object>>();
        for(SObject result : results){
            Map<String,Object> jsonResult = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(result));
            Map<String,Object> flattenedMap = flattenMap(jsonResult);
            flattenedResults.add(flattenedMap);
        }
        return flattenedResults;
    }

    public static Map<String,Object> flattenMap(Map<string,object> mapToFlatten){
        Map<String,Object> flattenedMap = new Map<String,Object>();
        for(String field : mapToFlatten.keySet()){
            Object value = mapToFlatten.get(field);
            if( value instanceof Map<String,Object>){
                Map<String,Object> node = (Map<String,Object>)mapToFlatten.get(field);
                for(String nodeField : node.keySet()){
                    flattenedMap.put( (field+'.'+nodeField), node.get(nodeField));
                }
            }else{
                flattenedMap.put(field, mapToFlatten.get(field));
            }
        }
        return flattenedMap;
    }
}