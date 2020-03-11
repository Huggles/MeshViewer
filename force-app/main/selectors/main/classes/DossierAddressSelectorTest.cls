/**
 * Created by jaapbranderhorst on 2019-06-22.
 */

@IsTest
private class DossierAddressSelectorTest {
    @TestSetup
    static void setup() {
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (Integer i = 0; i < 10; i++) {
            dossiers.add(new Business_Dossier__c(Name = '' + i));

        }
        insert dossiers;
        List<Dossier_Address__c> addresses = new List<Dossier_Address__c>();
        for (Business_Dossier__c businessDossier : dossiers) {
            addresses.add(addressCreator('Establishment', businessDossier.Id));
            addresses.add(addressCreator('Correspondence', businessDossier.Id));
        }
        insert addresses;
    }

    static Dossier_Address__c addressCreator(String type, Id dossierId) {
        Dossier_Address__c addressDB = new Dossier_Address__c();
        addressDB.Business_Data__c = dossierId;
        addressDB.Name = 'Name'; //dataVendorDossiercorrespondence_address_original_address;
        addressDB.Postcode__c = 'Postcode';
        addressDB.Street__c = 'Street';
        addressDB.City__c = 'City';
        addressDB.House_Number__c = '79';
        addressDB.House_Number_Addition__c = 'a';
        addressDB.Country__c = 'nl';
        addressDB.Type__c = type;
        return addressDB;
    }

    @IsTest
    static void testSelectByDossierId() {
        Map<Id, Business_Dossier__c> dossiersByIds = new Map<Id, Business_Dossier__c>([SELECT Id FROM Business_Dossier__c]);
        Test.startTest();
        List<Dossier_Address__c> selectedAddresses = DossierAddressSelector.newInstance().selectByDossierId(dossiersByIds.keySet());
        System.assert(selectedAddresses.size() == 20);
        for (Dossier_Address__c dossierAddress : selectedAddresses) {
            System.assert(!String.isEmpty(dossierAddress.Postcode__c));
            System.assert(!String.isEmpty(dossierAddress.Street__c));
            System.assert(!String.isEmpty(dossierAddress.City__c));
            System.assert(!String.isEmpty(dossierAddress.House_Number__c));
            System.assert(!String.isEmpty(dossierAddress.House_Number_Addition__c));
            System.assert(!String.isEmpty(dossierAddress.Country__c));
            System.assert(!String.isEmpty(dossierAddress.Type__c));
        }
    }
}