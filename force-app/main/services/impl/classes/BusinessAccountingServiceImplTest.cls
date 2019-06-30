@isTest
public with sharing class BusinessAccountingServiceImplTest {


    @isTest
    public static void onboardCustomer(){




    }


    @isTest
    public static void testCreateCIUser(){


    }

    @isTest
    public static void testGetUserOnboardedFail(){
        system.assert(!BusinessAccountingServiceImpl.GetUserOnboarded());

    }

    @isTest
    public static void testGetUserOnboardedSuccess(){
        Credentials__c CS = Credentials__c.getOrgDefaults();
        cs.Username__c = 'mock';
        cs.Password__c = 'mock';
        insert cs;
        system.assert(BusinessAccountingServiceImpl.GetUserOnboarded());

    }

    @isTest
    public static void testAddBudget(){


    }
    @isTest
    public static void testGetBalance(){

    }



}