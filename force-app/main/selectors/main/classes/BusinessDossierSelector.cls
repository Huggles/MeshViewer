
/****************************************************************************************
Author          : ValerijsProkudins
******************************************************************************************/
public with sharing class BusinessDossierSelector extends fflib_SObjectSelector implements IBusinessDossierSelector  {

    public BusinessDossierSelector() {
        super(false, // Do not include FieldSet fields
                true,  // enforce Object level security
                true); // enforce Field level security
    }

    public static IBusinessDossierSelector newInstance() {
        return (IBusinessDossierSelector) Application.Selector.newInstance(Business_Dossier__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Business_Dossier__c.Id,
                Business_Dossier__c.Name,
                Business_Dossier__c.Account__c,
                Business_Dossier__c.Account__r.Id,
                Business_Dossier__c.Account__r.name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Business_Dossier__c.sObjectType;
    }


    public List<Business_Dossier__c> selectByDossierNumber(set<String> dossierNumSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Business_Dossier__c> result = new list<Business_Dossier__c>();
        queryFactory.setEnforceFLS(true);
        queryFactory.setCondition('Dossier_Number__c IN :dossierNumSet');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    public List<Business_Dossier__c> selectByDossierNumbers(set<String> dossierNumSet, Set<String> establishmentNumSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Business_Dossier__c> result = new list<Business_Dossier__c>();
        queryFactory.setEnforceFLS(true);
        queryFactory.setCondition('Dossier_Number__c IN :dossierNumSet');
        queryFactory.setCondition('Establishment_Number__c IN :establishmentNumSet');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    public List<Business_Dossier__c> selectById(set<Id> dosserIdSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Business_Dossier__c> result = new list<Business_Dossier__c>();
        queryFactory.setEnforceFLS(true);
        queryFactory.selectField('Dossier_Number__c');
        queryFactory.setCondition('Id IN :dosserIdSet');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }



}
