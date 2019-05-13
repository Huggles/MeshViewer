public with sharing class DutchBusinessDossierSelector extends fflib_SObjectSelector implements IDutchBusinessDossierSelector  {

    public DutchBusinessDossierSelector() {
        super(false, // Do not include FieldSet fields
                true,  // enforce Object level security
                true); // enforce Field level security
    }

    public static IDutchBusinessDossierSelector newInstance() {
        return (IDutchBusinessDossierSelector) Application.Selector.newInstance(Dutch_Business_Dossier__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Dutch_Business_Dossier__c.Id,
                Dutch_Business_Dossier__c.Name,
                Dutch_Business_Dossier__c.Account__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Dutch_Business_Dossier__c.sObjectType;
    }

    // might want to change this to unbound from name field? (by having dossier number field)
    public List<Dutch_Business_Dossier__c> selectByName(String dossierNum){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Dutch_Business_Dossier__c> result = new list<Dutch_Business_Dossier__c>();
        queryFactory.setCondition('Name = :dossierNum');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }
    public List<Dutch_Business_Dossier__c> selectByDossierNumber(String dossierNum){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Dutch_Business_Dossier__c> result = new list<Dutch_Business_Dossier__c>();
        queryFactory.setCondition('Name = :dossierNum');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }



}
