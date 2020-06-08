/**
 * Created by tejaswinidandi on 20/05/2020.
 */

global inherited sharing class FindDuplicatesInvocable {

    global inherited sharing class FindDuplicatesArgument {
        @InvocableVariable(label='SObject' description='The sobject value' required=true)
        global SObject sobj;

        @TestVisible
        private FindDuplicatesArgument(SObject sobj) {
            this.sobj = sobj;
        }

        global FindDuplicatesArgument() {

        }
    }

    @InvocableMethod(label='Find Duplicate Sobjects' description='Find Duplicate Sobjects in Salesforce' category='Company.info')
    global static List<List<SObject>> findDuplicates(List<FindDuplicatesArgument> arguments) {
        List<SObject> sObjects = new List<SObject>();
        for (FindDuplicatesArgument findDuplicatesArgument: arguments) {
            sObjects.add(findDuplicatesArgument.sobj);
        }
        List<SObject> duplicateSObjects = new List<SObject>();
        List<List<SObject>> allDuplicateSObjects = new List<List<SObject>>();

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
            allDuplicateSObjects.add(new List<SObject>(duplicateSObjects));
        }
        catch (HandledException e) {
            // System.HandledException: No active duplicate rules are defined for the [objname] object type
        }
        return allDuplicateSObjects;
    }
}