@isTest
public with sharing class BusinessServiceImplTest {

    @IsTest
    public static void testDeleteDossierHappyFlow() {
        // given
        // a business dossier, a SBI code and an address in the DB
        Business_Dossier__c dossier = new Business_Dossier__c(Name = 'test');
        insert dossier;
        Business_Data_SBI__c sb = new Business_Data_SBI__c(Business_Dossier__c = dossier.Id);
        insert sb;

        // when
        Test.startTest();
        BusinessService.deleteDossier(dossier.Id, false);
        Test.stopTest();

        // then
        // no objects any more
        System.assert([SELECT Id FROM Business_Dossier__c].size() == 0);
        System.assert([SELECT Id FROM Business_Data_SBI__c].size() == 0);

    }

}