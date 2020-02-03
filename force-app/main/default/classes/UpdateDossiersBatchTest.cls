/**
 * Created by tejaswinidandi on 2019-08-01.
 */

@IsTest
public class UpdateDossiersBatchTest {

    @TestSetup
    private static void setupData() {
        Credentials__c c = new Credentials__c();
        c.Username__c = 'test';
        c.Password__c = 'pas';
        c.CompanyInfo_Account_Id__c = '1';
        c.CompanyConnectUserId__c = 11;
        c.Last_Executed_Batch__c = Datetime.newInstance(2019, 7, 28);

        Business_Dossier__c d = new Business_Dossier__c();
        d.Dossier_Number__c = '1';
        d.Establishment_Number__c = '2';
        d.Indication_Main_Establishment__c = false;
        d.Name = 't1';

        Business_Dossier__c d1 = new Business_Dossier__c();
        d1.Dossier_Number__c = '11';
        d1.Establishment_Number__c = '12';
        d1.Name = 't11';

        Account a1 = new Account();
        a1.Name = 'aa';
        Account a2 = new Account();
        a2.Name = 'aa2';

        insert a1;
        insert a2;
        insert c;
        d.Account__c = a1.Id;
        d1.Account__c = a2.Id;
        insert d;
        insert d1;
    }


    @IsTest
    static void testBatch() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        Integer pageNR = 1;

        mocks.startStubbing();

        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();
        output.paging = new DutchBusinessWsdl.ResultInfo();
        output.paging.numpages = 1;
        output.results = new DutchBusinessWsdl.DutchBusinessUpdateReferenceArray();
        output.results.item = new List<DutchBusinessWsdl.DutchBusinessUpdateReference>();
        DutchBusinessWsdl.DutchBusinessUpdateReference a1 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a1.dossier_number = '1';
        a1.establishment_number = '2';
        a1.update_types = stringArray(new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress'});
        output.results.item.add(a1);

        DutchBusinessWsdl.DutchBusinessUpdateReference a2 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a2.dossier_number = '11';
        a2.establishment_number = '12';
        a2.update_types = stringArray(new List<String>{'Removed'});
        output.results.item.add(a2);
        Credentials__c c = Credentials__c.getOrgDefaults();

        DutchBusinessWsdl.DutchBusinessDossierV3 output1 = new DutchBusinessWsdl.DutchBusinessDossierV3();

        mocks.when(mockWS.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray) fflib_Match.anyObject(), fflib_Match.anyInteger())).thenReturn(output);
        mocks.when(mockWS.dutchBusinessGetDossierV3(a1.dossier_number, a1.establishment_number)).thenReturn(output1);

        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, mockWS);

        test.startTest();
        UpdateDossiersBatch o = new UpdateDossiersBatch();
        Database.executeBatch(o);
        test.stopTest();

        List<Business_Dossier__c> bd = [SELECT Id, Is_Removed__c, Dossier_Number__c FROM Business_Dossier__c WHERE Dossier_Number__c = '11' LIMIT 1];
        System.assertEquals(bd[0].Is_Removed__c, true);
        Credentials__c cs = Credentials__c.getOrgDefaults();
        Date d = cs.Last_Executed_Batch__c.Date();
        System.assertEquals(d, Datetime.now().Date());
    }

    @IsTest
    static void testBatchWithMorePages() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        Integer pageNR = 1;

        mocks.startStubbing();

        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();
        output.paging = new DutchBusinessWsdl.ResultInfo();
        output.paging.numpages = 5;
        output.results = new DutchBusinessWsdl.DutchBusinessUpdateReferenceArray();
        output.results.item = new List<DutchBusinessWsdl.DutchBusinessUpdateReference>();
        DutchBusinessWsdl.DutchBusinessUpdateReference a1 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a1.dossier_number = '1';
        a1.establishment_number = '2';
        a1.update_types = stringArray(new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress'});
        output.results.item.add(a1);

        DutchBusinessWsdl.DutchBusinessUpdateReference a2 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a2.dossier_number = '11';
        a2.establishment_number = '12';
        a2.update_types = stringArray(new List<String>{'Removed'});
        output.results.item.add(a2);
        Credentials__c c = Credentials__c.getOrgDefaults();

        DutchBusinessWsdl.DutchBusinessDossierV3 output1 = new DutchBusinessWsdl.DutchBusinessDossierV3();

        mocks.when(mockWS.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray) fflib_Match.anyObject(), fflib_Match.anyInteger())).thenReturn(output);
        mocks.when(mockWS.dutchBusinessGetDossierV3(a1.dossier_number, a1.establishment_number)).thenReturn(output1);

        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, mockWS);

        test.startTest();
        UpdateDossiersBatch o = new UpdateDossiersBatch();
        Database.executeBatch(o);
        test.stopTest();

        List<Business_Dossier__c> bd = [SELECT Id, Is_Removed__c, Dossier_Number__c FROM Business_Dossier__c WHERE Dossier_Number__c = '11' LIMIT 1];
        System.assertEquals(bd[0].Is_Removed__c, true);
    }

    @IsTest
    static void testBatchWithNoUpdates() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);
        Integer pageNR = 1;

        mocks.startStubbing();

        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();
        output.paging = new DutchBusinessWsdl.ResultInfo();
        output.paging.numpages = 1;
        output.results = new DutchBusinessWsdl.DutchBusinessUpdateReferenceArray();
        output.results.item = new List<DutchBusinessWsdl.DutchBusinessUpdateReference>();

        Credentials__c c = Credentials__c.getOrgDefaults();

        DutchBusinessWsdl.DutchBusinessDossierV3 output1 = new DutchBusinessWsdl.DutchBusinessDossierV3();

        mocks.when(mockWS.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray) fflib_Match.anyObject(), fflib_Match.anyInteger())).thenReturn(output);
        mocks.when(mockWS.dutchBusinessGetDossierV3('', '')).thenReturn(output1);

        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, mockWS);

        test.startTest();
        UpdateDossiersBatch o = new UpdateDossiersBatch();
        Database.executeBatch(o);
        test.stopTest();

        List<Business_Dossier__c> bd = [SELECT Id, Is_Removed__c, Dossier_Number__c FROM Business_Dossier__c WHERE Dossier_Number__c = '11' LIMIT 1];
        System.assertEquals(bd[0].Is_Removed__c, false);
        Credentials__c cs = Credentials__c.getOrgDefaults();
        Date d = cs.Last_Executed_Batch__c.Date();
        System.assertEquals(d, Datetime.now().Date());
    }

    public static DutchBusinessWsdl.stringArray stringArray (List<String> types) {
        DutchBusinessWsdl.stringArray updateTypesArrayResponse = new DutchBusinessWsdl.stringArray();
        updateTypesArrayResponse.item = new List<String>();
        for (String s : types) {
            updateTypesArrayResponse.item.add(s);
        }

        return updateTypesArrayResponse;
    }
}