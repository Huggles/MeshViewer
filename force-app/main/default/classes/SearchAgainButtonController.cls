/**
 * Created by jaapbranderhorst on 08/03/2020.
 */

public with sharing class SearchAgainButtonController {

    @AuraEnabled
    public static Boolean deleteDossier(Id dossierId) {
        return BusinessService.deleteDossier(dossierId, false);
    }

}