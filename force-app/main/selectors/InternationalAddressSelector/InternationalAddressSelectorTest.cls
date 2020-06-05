/**
 * Created by tejaswinidandi on 23/04/2020.
 */

@IsTest
private class InternationalAddressSelectorTest {

    @TestSetup
    static void setup() {
        List<International_Address__c> internationalAddresses = new List<International_Address__c>();
        for (Integer i = 0; i < 10; i++) {
            internationalAddresses.add(new International_Address__c(Country__c = 'NL' + i, Postcode__c = 'P' + i));
        }
        insert internationalAddresses;
    }

    @IsTest
    static void testSelectById() {
        Map<Id, International_Address__c> internationalAddressesByIds = new Map<Id, International_Address__c>([SELECT Id FROM International_Address__c]);
        Test.startTest();
        List<International_Address__c> internationalAddresses = InternationalAddressSelector.newInstance().selectById(internationalAddressesByIds.keySet());
        System.assert(internationalAddresses.size() == 10);
    }
}