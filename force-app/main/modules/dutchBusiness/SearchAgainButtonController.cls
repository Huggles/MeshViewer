/**
 * Created by jaapbranderhorst on 08/03/2020.
 */

public with sharing class SearchAgainButtonController {

    @AuraEnabled
    public static void deleteDossier(Id dossierId) {
        try {
            BusinessService.deleteDossier(dossierId, false);
        } catch(Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }

    }

    @AuraEnabled
    public static void deleteInternationalAddress(Id internationalAddressId) {
        try {
            InternationalAddressService.deleteInternationalAddress(internationalAddressId, false);
        } catch(Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }
    }

}