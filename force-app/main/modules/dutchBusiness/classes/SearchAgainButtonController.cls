/**
 * Created by jaapbranderhorst on 08/03/2020.
 */

public with sharing class SearchAgainButtonController {

    @AuraEnabled
    public static void deleteDossier(Id dossierId) {
        BusinessService.deleteDossier(dossierId, false);
    }

    @AuraEnabled
    public static void deleteInternationalAddress(Id internationalAddressId) {
        InternationalAddressService.deleteInternationalAddress(internationalAddressId, false);
    }

}