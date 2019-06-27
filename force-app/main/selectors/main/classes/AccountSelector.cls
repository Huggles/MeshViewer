/****************************************************************************************
Author          : ValerijsProkudins
******************************************************************************************/
public inherited sharing class AccountSelector extends fflib_SObjectSelector implements IAccountSelector{

    public static IAccountSelector newInstance() {
        return (IAccountSelector) Application.Selector.newInstance(Account.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Account.Id,
                Account.Name,
                Account.Business_Dossier__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }

    public List<Account> selectById(set<ID> idSet){
        return (List<Account>) selectSObjectsById(idSet);
    }
}
