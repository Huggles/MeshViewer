/**
 * Created by tejaswinidandi on 08/06/2020.
 */

public inherited sharing class DuplicateManagementService {

    public static Id createDuplicate(SObject sobj){
        return newInstance().createDuplicate(sobj);
    }

    public static List<SObject> findDuplicates(List<SObject> sObjects){
        return newInstance().findDuplicates(sObjects);
    }

    public static IDuplicateManagement newInstance() {
        return (IDuplicateManagement) Application.Service.newInstance(IDuplicateManagement.class);
    }
}