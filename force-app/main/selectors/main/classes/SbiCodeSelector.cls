/**
 * Created by jaapbranderhorst on 2019-06-18.
 */

public with sharing class SbiCodeSelector extends fflib_SObjectSelector implements ISbiCodeSelector {


    public SbiCodeSelector() {
//        super(false,
//                true,
//                true);
    }

    public static ISbiCodeSelector newInstance() {
        return (ISbiCodeSelector) Application.Selector.newInstance(Business_Data_SBI__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Business_Data_SBI__c.Id,
                Business_Data_SBI__c.Name,
                Business_Data_SBI__c.Business_Dossier__c,
                Business_Data_SBI__c.SBI_Code__c,
                Business_Data_SBI__c.SBI_Description__c,
                Business_Data_SBI__c.SBI_Type__c

        };
    }

    public Schema.SObjectType getSObjectType() {
        return Business_Data_SBI__c.sObjectType;
    }

    public List<Business_Data_SBI__c> selectByDossierId(set<Id> dossierIdSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Business_Data_SBI__c> result = new List<Business_Data_SBI__c>();
        queryFactory.setCondition('Business_Dossier__c IN :dossierIdSet');
        System.debug('SOQL selectByDossierid: ' + queryFactory.toSOQL());
        result = Database.query(queryFactory.toSOQL());
        System.debug('found records: ' + result);
        return result;
    }

}