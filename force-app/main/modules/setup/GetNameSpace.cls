/**
 * Created by vishalshete on 16/07/2020.
 */

public with sharing class GetNameSpace {

    public static String getNameSpace (String settingName, String settingType){
        switch on settingType {
            when 'Apex' {
                return getClassNameSpace(settingName);
            }
            when 'Object' {
                return getObjectNameSpace(settingName);
            }
        }
        return null;
    }
    public static String getNameSpace(String settingName, String settingType,String settingObject){
        switch on settingType{
            when 'CustomMetadata'{
                return getCustomMetadataNameSpace(settingName,settingObject);
            }
        }
    return null;
    }
    private static Map<String,String> apexNameSpaceMap = new Map<String, String>();

    public static String getClassNameSpace(String className){
        try {
            if(apexNameSpaceMap.size()==0 && Schema.SObjectType.ApexClass.isAccessible()) {
                List<ApexClass> classes = [SELECT Name, NameSpacePrefix FROM ApexClass WHERE NameSpacePrefix != NULL];
                for (ApexClass apexClass : classes) {
                    apexNameSpaceMap.put(apexClass.Name, apexClass.NamespacePrefix);
                }
            }
            return apexNameSpaceMap.get(className);

        } catch (Exception e){
            ErrorLogUtil.logException(e, true);
            throw new AuraHandledException(e.getMessage());
        }

    }

    private static Map<String,EntityDefinition> objectNameSpaceMap = new Map<String, EntityDefinition>();
    public static String getObjectNameSpace(String objName){
        try {
            String objNameSpace;
            if (objectNameSpaceMap.size() == 0 && Schema.SObjectType.EntityDefinition.isAccessible())  {
                List<EntityDefinition> entityDefinitions = [SELECT MasterLabel, QualifiedApiName,DeveloperName, NamespacePrefix FROM EntityDefinition ORDER BY MasterLabel];
                //if (entityDefinitions.size() > 0) return entityDefinitions.get(0).NamespacePrefix;
                for (EntityDefinition entityDefinition : entityDefinitions) {
                    objectNameSpaceMap.put(entityDefinition.DeveloperName, entityDefinition);
                }
                objNameSpace = objectNameSpaceMap.get(objName).NamespacePrefix;
            }
            return objNameSpace;
        } catch (Exception e){
            ErrorLogUtil.logException(e, true);
            throw new AuraHandledException(e.getMessage());
        }
    }
    private static Map<String,SObject> customMetadataRecordNameSpaceMap = new Map<String, SObject>();
    private static List<String> customMetadataNameList = new List<String>();

    public static String getCustomMetadataNameSpace(String developerName,String objName) {
        try {
            String recNameSpace;
            if (!customMetadataNameList.contains(objName) &&((sObject)Type.forName(objName).newInstance()).getSObjectType().getDescribe().isAccessible()) {
                customMetadataNameList.add(objName);
                String queryString = 'SELECT Id, NamespacePrefix,DeveloperName FROM ' + objName;// + ' WHERE DeveloperName =\'' + developerName + '\' LIMIT 1';
                List<SObject> sObjects = Database.query(queryString);
                if (sObjects.size() > 0) {
                    for (SObject s : sObjects) {
                        customMetadataRecordNameSpaceMap.put(s.get('DeveloperName')+objName , s);
                    }
                }
            }
            if(customMetadataRecordNameSpaceMap.get(developerName + objName) != null){
                sObject s = customMetadataRecordNameSpaceMap.get(developerName +objName);
                recNameSpace = s.get('NamespacePrefix').toString();
            }
            return recNameSpace;
        } catch (Exception e){
            ErrorLogUtil.logException(e, true);
            throw new AuraHandledException(e.getMessage());

        }
    }
}