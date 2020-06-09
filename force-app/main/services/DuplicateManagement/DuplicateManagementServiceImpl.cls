/**
 * Created by tejaswinidandi on 08/06/2020.
 */

public inherited sharing class DuplicateManagementServiceImpl implements IDuplicateManagement{

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

    public static List<SObject> findDuplicates(List<SObject> sObjects) {
        List<SObject> duplicateSObjects = new List<SObject>();
        try {
            Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(sObjects);
            for (Datacloud.FindDuplicatesResult findDupeResult : results) {
                for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                        for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                            duplicateSObjects.add(matchRecord.getRecord());
                        }
                    }
                }
            }
        }
        catch (HandledException e) {
            // System.HandledException: No active duplicate rules are defined for the [objname] object type
        }
        return duplicateSObjects;
    }


}