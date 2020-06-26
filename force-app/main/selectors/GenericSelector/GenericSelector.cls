/**
* Created by Hugo on 26/06/2020.
*/

public inherited sharing class GenericSelector extends fflib_SObjectSelector implements IGenericSelector{


    public String objectDeveloperName;
    public List<String> fieldsDeveloperNames;
    public String relationshipFieldDeveloperName;

    public static GenericSelector newInstance() {
        return (GenericSelector) GenericSelector.class.newInstance();
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        List<SObjectField> sObjectFieldsList = new List<SObjectField>();
        Map<String,Schema.SObjectField> fields = getSObjectType().getDescribe().fields.getMap();
        if(fields != null){
            for(String fieldDeveloperName : fieldsDeveloperNames){
                if(fields.containsKey(fieldDeveloperName)){
                    sObjectFieldsList.add((fields.get(fieldDeveloperName)));
                }else{
                    throw new InputException('Field not found');
                }
            }
        }else{
            throw new InputException(Label.Error_Input_Incorrect);
        }
        return sObjectFieldsList;
    }
    public Schema.SObjectType getSObjectType() {
        SObjectType type = Schema.getGlobalDescribe().get(objectDeveloperName);
        if(type != null){
            return type;
        }else{
            throw new InputException(Label.Error_Input_Incorrect);
        }
    }
    public List<SObject> selectByParentRecordId(Id parentRecordId){
        fflib_QueryFactory queryFactory = newQueryFactory();
        queryFactory.setCondition(relationshipFieldDeveloperName + ' = :parentRecordId');
        queryFactory.setEnforceFLS(true);
        List<SObject> results = Database.query(queryFactory.toSOQL());
        return results;
    }
}