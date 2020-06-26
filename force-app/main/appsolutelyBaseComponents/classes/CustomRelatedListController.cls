/**
 * Created by Hugo on 23/06/2020.
 */

public with sharing class CustomRelatedListController {


    @AuraEnabled
    public static List<Map<String,Object>> getChildRecords(
            String objectDeveloperName, String relationshipFieldDeveloperName,
            List<String> queryFields,   Id parentRecordId){


        GenericSelector genericSelector = GenericSelector.newInstance();
        genericSelector.objectDeveloperName = objectDeveloperName;
        genericSelector.fieldsDeveloperNames = queryFields;
        genericSelector.relationshipFieldDeveloperName = relationshipFieldDeveloperName;

        List<SObject> results = genericSelector.selectByParentRecordId(parentRecordId);

        List<Map<String,Object>> flattenedResults = new List<Map<String,Object>>();
        for(SObject result : results){
            Map<String,Object> jsonResult = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(result));
            Map<String,Object> flattenedMap = flattenMap(jsonResult);
            flattenedResults.add(flattenedMap);
        }
        return flattenedResults;
    }

    private static Map<String,Object> flattenMap(Map<string,object> mapToFlatten){
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