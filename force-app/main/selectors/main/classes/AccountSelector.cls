/****************************************************************************************
Author          : ValerijsProkudins
******************************************************************************************/
public with sharing class AccountSelector extends fflib_SObjectSelector implements IAccountSelector{
    public AccountSelector() {
        super(false, // Do not include FieldSet fields
                true,  // enforce Object level security
                true); // enforce Field level security
    }

    public static IAccountSelector newInstance() {
        return (IAccountSelector) Application.Selector.newInstance(Account.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Account.Id,
                Account.Name,
                Account.Dutch_Business_Dossier__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }



    public list<Account> selectById(set<ID> IdSet){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Account> result = new list<Account>();
        queryFactory.setCondition('Id IN :IdSet');
        queryFactory.setLimit(20);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }
   public Account selectById(String Id){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        Account result = new Account();
        queryFactory.setCondition('Id = :Id');
        queryFactory.setLimit(1);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

}
