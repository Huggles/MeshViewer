/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

public with sharing class DossierAddressesViewController {

    @AuraEnabled
    public static Object getAddresses(String dossierId) {
        AuraResponseWrapper wrapper = new AuraResponseWrapper(DossierAddressSelector.newInstance().selectByDossierId(new Set<Id>{dossierId}));
        return wrapper;
    }

}