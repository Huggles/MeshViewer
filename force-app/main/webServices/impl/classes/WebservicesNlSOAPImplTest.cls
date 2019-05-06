@isTest
public with sharing class WebservicesNlSOAPImplTest {
    @isTest
    public static void userContextOrgActive(){
        
        Credentials__c CS = Credentials__c.getOrgDefaults();
        cs.Username__c = 'mock';
        cs.Password__c = 'mock';
        insert cs;
        Test.startTest();
        boolean error = false;
            try{IWebservicesNlSOAP service = WebservicesNlSOAP.newInstance();}catch(BdsException e){error = true;}
        Test.stopTest();
        system.assert(!error);  
    }

   /* @isTest
    public static void userContextOrgNotActive(){
        
        Test.startTest();
        boolean error = false;
            try{IWebservicesNlSOAP service = WebservicesNlSOAP.newInstance();}catch(BdsException e){error = true;}
        Test.stopTest();
        system.assert(error);  
    }*/
    

}
