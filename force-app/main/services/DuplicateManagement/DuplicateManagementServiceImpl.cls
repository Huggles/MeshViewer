/**
 * Created by tejaswinidandi on 08/06/2020.
 */

public inherited sharing class DuplicateManagementServiceImpl implements IDuplicateManagement{

    /*
     * Creates a potential duplicate SObject record by overriding duplicate rules
     *
     * @param sobj that needs to be created
     *
     * @return Id of the created SObject
     */

    public static Id createDuplicate(SObject sobj) {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance(new fflib_SObjectUnitOfWork.DuplicateDML(true));

        unitOfWork.registerNew(sobj);
        unitOfWork.commitWork();

        return sobj.Id;
    }

    /*
     * Find potential duplicate SObjects for the given SObject
     *
     * @param sObjects List of SObjects for which duplicates need to be found
     *
     * @return List of found duplicate SObjects
     */
    public static List<SObject> findDuplicates(List<SObject> sObjects) {
        List<SObject> duplicateSObjects = new List<SObject>();
        try {
            Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(sObjects);
            for (Datacloud.FindDuplicatesResult findDupeResult : results) {
                for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                        for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                            //Check if the record was already added by another duplicate rule first. We dont want records twice.
                            SObject record = matchRecord.getRecord();
                            if(!listContainsId(duplicateSObjects, record.Id)){
                                duplicateSObjects.add(record);
                            }
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

    /*
     * Check whether a list of records contains an element with a specific Id
     *
     * @param records List of SObjects to check
     * @param idToFind Id to find.
     *
     * @return Boolean whether the Id is in the list.
     */
    private static Boolean listContainsId(List<SObject> records, Id idToFind){
        for (SObject record : records){
            if(record.Id == idToFind){
                return true;
            }
        }
        return false;
    }


}