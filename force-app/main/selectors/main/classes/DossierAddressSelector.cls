/****************************************************************************************
Author          : DanNicholson
******************************************************************************************/
public with sharing class DossierAddressSelector extends fflib_SObjectSelector implements IDossierAddressSelector  {

    public DossierAddressSelector() {
        super(false, // Do not include FieldSet fields
                true,  // enforce Object level security
                true); // enforce Field level security
    }

    public static IDossierAddressSelector newInstance() {
        return (IDossierAddressSelector) Application.Selector.newInstance(Dossier_Address__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Dossier_Address__c.Id,
                Dossier_Address__c.Name,
                Dossier_Address__c.Business_Data__c,
                Dossier_Address__c.Business_Data__r.Id,
                Dossier_Address__c.Business_Data__r.name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Dossier_Address__c.sObjectType;
    }


    public List<Dossier_Address__c> selectByDossierNumber(set<String> dossierNumSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Dossier_Address__c> result = new list<Dossier_Address__c>();
        queryFactory.setEnforceFLS(true);
        queryFactory.setCondition('Business_Data__r.Dossier_Number__c IN :dossierNumSet');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    public List<Dossier_Address__c> selectById(set<Id> addressIdSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Dossier_Address__c> result = new list<Dossier_Address__c>();
        queryFactory.setEnforceFLS(true);
        queryFactory.setCondition('Id IN :dosserIdSet');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

}