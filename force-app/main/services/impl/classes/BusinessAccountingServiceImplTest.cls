@isTest
public with sharing class BusinessAccountingServiceImplTest {


    @isTest
    public static void testGetUserOnboardedFail(){
        system.assert(!BusinessAccountingService.GetUserOnboarded());

    }

    @isTest
    public static void testGetUserOnboardedSuccess(){
        Credentials__c CS = Credentials__c.getOrgDefaults();
        cs.Username__c = 'mock';
        cs.Password__c = 'mock';
        insert cs;
        system.assert(BusinessAccountingService.GetUserOnboarded());

    }


}