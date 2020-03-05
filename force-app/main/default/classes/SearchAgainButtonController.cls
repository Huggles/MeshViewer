/**
 * Created by jaapbranderhorst on 05/03/2020.
 */

public with sharing class SearchAgainButtonController {

    @AuraEnabled
    public static Object deleteDossier(Id recordId){
        try{
            BusinessService.deleteDossier(recordId);
            AuraResponseWrapper output = new AuraResponseWrapper(true);
            return output;
        }catch (CCException e) {
            return new AuraResponseWrapper(e);
        }
    }

}