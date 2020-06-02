/**
 * Created by tejaswinidandi on 02/06/2020.
 */

public with sharing class CreateDuplicates {

    @AuraEnabled
    public static Id createDuplicateAccount(Account account) {
        return createDuplicate(account);
    }

    public static Id createDuplicate(SObject sobj) {
        Id sobjectCreatedID;
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;

        Database.SaveResult sr = Database.insert(sobj, dml);
        if (sr.isSuccess()) {
            sobjectCreatedID = sr.id;
        }

        return sobjectCreatedID;
    }

}