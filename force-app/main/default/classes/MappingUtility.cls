/**
 * Created by jaapbranderhorst on 16/02/2020.
 */

public inherited sharing class MappingUtility {

    /**
     * Deserializes the mappingJSON in pairs attributeName/fieldName. Determines the SObjectType based on the given recordId. Then queries
     * that SObjectType to retrieve the fields determined through the mappingJson. Returns a map with the attributeNames as key and
     * the corresponding fieldName value.
     *
     * @param mappingJson
     * @param recordId
     *
     * @return
     */
    public static Map<String, Object> mapToObjectsByStrings(String mappingJson, Id recordId) {
        Map<String, Object> mapping = (Map<String, Object>)JSON.deserializeUntyped(mappingJson);
        SObjectType objectType = recordId.getSobjectType();
        String query = 'SELECT ';
        List<Object> values = mapping.values();
        query += values[0];
        for (Integer i = 1; i < mapping.size(); i++) {
            query += ',';
            query += (String)values[i];
        }
        query += ' FROM ';
        query += objectType.getDescribe().name;
        query += ' WHERE Id = :recordId WITH SECURITY_ENFORCED';
        List<SObject> sObjects = Database.query(query);
        Map<String, Object> returnMap = new Map<String, Object>();
        for (String attribute : mapping.keySet()) {
            // this currently only works for fields on the sobject itself. Doesn't traverse.
            // See https://salesforce.stackexchange.com/questions/24801/using-sobject-get-to-fetch-a-field-value-from-a-related-parent-object
            // to solve this.
            returnMap.put(attribute, sObjects[0].get((String)mapping.get(attribute)));
        }
        return returnMap;
    }
}