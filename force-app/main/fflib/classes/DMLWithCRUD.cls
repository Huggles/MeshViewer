/**
 * Created by jaapbranderhorst on 11/02/2018.
 */

public with sharing class DMLWithCRUD implements fflib_SObjectUnitOfWork.IDML {

    public void dmlInsert(List<SObject> objList) {
        DMLManager.insertAsUser(objList);
    }

    public void dmlUpdate(List<SObject> objList) {
        DMLManager.updateAsUser(objList);
    }

    public void dmlDelete(List<SObject> objList) {
        DMLManager.deleteAsUser(objList);
    }
    public void eventPublish(List<SObject> objList){
        // does nothing, had to stub it because of fflib update
    }

}