/**
 * Created by tejaswinidandi on 08/06/2020.
 */

public interface IDuplicateManagement {

    Id createDuplicate(SObject sobj);

    List<SObject> findDuplicates(List<SObject> sObjects);

}