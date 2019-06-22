/****************************************************************************************
Author          : DanNicholson
******************************************************************************************/
public inherited sharing class DossierAddressSelector extends fflib_SObjectSelector implements IDossierAddressSelector  {

    public DossierAddressSelector() {
//        super(false, // Do not include FieldSet fields
//                true,  // enforce Object level security
//                true); // enforce Field level security
    }

    public static IDossierAddressSelector newInstance() {
        return (IDossierAddressSelector) Application.Selector.newInstance(Dossier_Address__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Dossier_Address__c.Id,
                Dossier_Address__c.Name,
                Dossier_Address__c.Business_Data__c,
                Dossier_Address__c.Type__c,
                Dossier_Address__c.Postcode__c,
                Dossier_Address__c.Street__c,
                Dossier_Address__c.City__c,
                Dossier_Address__c.House_Number__c,
                Dossier_Address__c.House_Number_Addition__c,
                Dossier_Address__c.Country__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Dossier_Address__c.sObjectType;
    }

    public List<Dossier_Address__c> selectByDossierId(set<Id> dossierIdSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Dossier_Address__c> result = new list<Dossier_Address__c>();
        // queryFactory.setEnforceFLS(true);
        queryFactory.setCondition('Business_Data__c IN :dossierIdSet');
        queryFactory.setLimit(20);
        System.debug('SOQL selectByDossierid: ' + queryFactory.toSOQL());
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

}