/**
 * Created by tejaswinidandi on 21/04/2020.
 */

public with sharing class InternationalAddressSelector  extends fflib_SObjectSelector implements IInternationalAddressSelector{

    public static IInternationalAddressSelector newInstance() {
        return (IInternationalAddressSelector) Application.Selector.newInstance(International_Address__c.SObjectType);
    }

    public Schema.SObjectType getSObjectType() {
        return International_Address__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                International_Address__c.Id
        };
    }

    public List<International_Address__c> selectById(set<Id> internationalAddressIdSet){
        return (List<International_Address__c>) selectSObjectsById(internationalAddressIdSet);
    }

}