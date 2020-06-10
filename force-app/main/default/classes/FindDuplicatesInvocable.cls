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

        List<SObject> duplicateSObjects = DuplicateManagementService.findDuplicates(sObjects);

        List<List<SObject>> allDuplicateSObjects = new List<List<SObject>>();
        if (duplicateSObjects.size() > 0) {
            allDuplicateSObjects.add(new List<SObject>(duplicateSObjects));
        }

        return allDuplicateSObjects;
    }
}