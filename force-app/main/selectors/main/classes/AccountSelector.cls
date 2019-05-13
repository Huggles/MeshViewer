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
                account.Dutch_Business_Dossier__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }

}
