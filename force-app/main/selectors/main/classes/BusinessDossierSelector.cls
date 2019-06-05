
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
        return (IBusinessDossierSelector) Application.Selector.newInstance(Dutch_Business_Dossier__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Dutch_Business_Dossier__c.Id,
                Dutch_Business_Dossier__c.Name,
                Dutch_Business_Dossier__c.Account__c,
                Dutch_Business_Dossier__c.Account__r.Id,
                Dutch_Business_Dossier__c.Account__r.name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Dutch_Business_Dossier__c.sObjectType;
    }


    public List<Dutch_Business_Dossier__c> selectByDossierNumber(set<String> dossierNumSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Dutch_Business_Dossier__c> result = new list<Dutch_Business_Dossier__c>();
        queryFactory.setCondition('Dossier_Number__c IN :dossierNumSet');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }



}
