@IsTest
private class CompanyDetailsControllerTest {
    @isTest static void testSearch() {             
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new wwwWebservicesNlSoapMockImpl());
        // Call the method that invokes a callout
        CompanyDetailsControllerHelper.CompanySearchDto dto = new CompanyDetailsControllerHelper.CompanySearchDto();
        dto.postcode = '1234 AD';

        List<wwwWebservicesNlSoap.DutchBusinessReferenceV2> output = CompanyDetailsController.search(JSON.serialize(dto));

        List<wwwWebservicesNlSoap.DutchBusinessReferenceV2> expected = wwwWebservicesNlSoapMockImpl.getExampleBusinessList();
        // Verify that a fake result is returned
        System.assertEquals(JSON.serialize(expected), JSON.serialize(output));
    }
    @isTest static void testSearchNullParams() {             
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new wwwWebservicesNlSoapMockImpl());
        // Call the method that invokes a callout
        List<wwwWebservicesNlSoap.DutchBusinessReferenceV2> output = CompanyDetailsController.search(null);
        // Verify that a fake result is returned
        System.assertEquals(null, output);
    }
    @isTest static void testGetInfo() {             
        Account a = new Account(Name = 'Test Account');
        insert a;
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new wwwWebservicesNlSoapMockImpl());
        // Call the method that invokes a callout
        Test.startTest();
        wwwWebservicesNlSoap.DutchBusinessDossierV3 output = CompanyDetailsControllerHelper.getInfo('12345678');
        wwwWebservicesNlSoap.DutchBusinessDossierV3 expected = wwwWebservicesNlSoapMockImpl.getExampleDossier();
        // verify that a dossier is returned when expected
        System.assertEquals(JSON.serialize(expected), JSON.serialize(output));

        Id out2 = CompanyDetailsController.getInfo('12345678', a.Id);
        Test.stopTest();
        // Confirm that method returns value successfully.
        System.assertNotEquals(null, out2);

        List<Dutch_Business_Dossier__c> dbds = [SELECT Id FROM Dutch_Business_Dossier__c WHERE ID <> NULL];
        // Confirm that Dutch_Business_Dossier__c exists.
        System.assertEquals(1, dbds.size());
    }
    @isTest static void testGetInfoNullDossierNumber() {             
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new wwwWebservicesNlSoapMockImpl());
        // Call the method that invokes a callout
        Test.startTest();
        wwwWebservicesNlSoap.DutchBusinessDossierV3 output = CompanyDetailsControllerHelper.getInfo(null);
        // verify that a dossier is returned when expected
        System.assertEquals(null, output);

        Id out2 = CompanyDetailsController.getInfo(null, null);
        Test.stopTest();
        // Confirm that method returns value successfully.
        System.assertEquals(null, out2);

        List<Dutch_Business_Dossier__c> dbds = [SELECT Id FROM Dutch_Business_Dossier__c WHERE ID <> NULL];
        // Confirm that Dutch_Business_Dossier__c exists.
        System.assertEquals(0, dbds.size());
    }

     @isTest static void getDossierRecordId() {     
        Account a = new Account(Name = 'Test Account');
        insert a;
        wwwWebservicesNlSoap.DutchBusinessDossierV3 dbd = wwwWebservicesNlSoapMockImpl.getExampleDossier();
        Id dbdId = CompanyDetailsControllerHelper.saveDutchBusinessDossier(dbd, a.Id);


        Test.startTest();
        // Get record Id from dossier number.
        Id out = CompanyDetailsController.getDossierRecordId(Integer.valueOf(dbd.dossier_number));
        Test.stopTest();

        System.assertEquals(dbdId, out);

    }
     @isTest static void getDossierRecordIdNoMatch() {     
        Account a = new Account(Name = 'Test Account');
        insert a;
        wwwWebservicesNlSoap.DutchBusinessDossierV3 dbd = wwwWebservicesNlSoapMockImpl.getExampleDossier();
        Test.startTest();
        // Get record Id from dossier number.
        Id out = CompanyDetailsController.getDossierRecordId(Integer.valueOf(dbd.dossier_number));
        Test.stopTest();

        System.assertEquals(null, out);

    }


}