/**
 * Created by tejaswinidandi on 08/06/2020.
 */

public interface IDuplicateManagement {

    /*
     * Creates a potential duplicate SObject record by overriding duplicate rules
     *
     * @param sobj that needs to be created
     *
     * @return Id of the created SObject
     */
    Id createDuplicate(SObject sobj);

    /*
     * Find potential duplicate SObjects for the given SObject
     *
     * @param sObjects List of SObjects for which duplicates need to be found
     *
     * @return List of found duplicate SObjects
     */
    List<SObject> findDuplicates(List<SObject> sObjects);

}