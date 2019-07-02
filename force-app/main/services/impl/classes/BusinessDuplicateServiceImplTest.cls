/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

@IsTest
private class BusinessDuplicateServiceImplTest {

    @IsTest
    public static void testDuplicateAccount() {
        Test.startTest();
        {
            List<Account> duplicateAccounts = BusinessDuplicateService.checkForAccountDuplicates(new Account(Name = 'test'));
            System.assert(duplicateAccounts != null);
        }
        Test.stopTest();
    }

    @IsTest
    public static void testCheckForExistingVatNumberInDBExistingVAT() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessDossierSelector selector = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);

        List<Business_Dossier__c> businessDossiers = new List<Business_Dossier__c>();
        businessDossiers.add(new Business_Dossier__c(Dossier_Number__c = '1234', Establishment_Number__c = '1',  VAT_Number__c = '123'));
        businessDossiers.add(new Business_Dossier__c(Dossier_Number__c = '1234', Establishment_Number__c = '2'));

        mocks.startStubbing();
        mocks.when(selector.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(selector.selectByDossierNumber((Set<String>)fflib_Match.anyObject(), fflib_Match.eqBoolean(false))).thenReturn(businessDossiers);
        mocks.stopStubbing();

        Application.Selector.setMock(selector);

        Test.startTest();
        {
            System.assert(BusinessDuplicateService.checkForExistingVatNumberInDB('1234') == '123');
        }
        Test.stopTest();
    }

    @IsTest
    public static void testCheckForDuplicateDossiersNoDuplicates() {
        List<CheckDuplicateDossierRequest> requests = new List<CheckDuplicateDossierRequest>();
        for (Integer i = 0; i < 10; i++) {
            requests.add(new CheckDuplicateDossierRequest('' + i, '' + i));
        }
        Test.startTest();
        {
            List<CheckDuplicateDossierResponse> responses = BusinessDuplicateService.checkForDuplicateDossiers(requests);
            System.assert(responses.size() == 10);
            for (CheckDuplicateDossierResponse checkDuplicateDossierResponse : responses) {
                System.assert(checkDuplicateDossierResponse.dossierFound == null);
            }
        }
        Test.stopTest();
    }

    @IsTest
    public static void testCheckForDuplicateDossiersDuplicates() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessDossierSelector selector = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);

        List<CheckDuplicateDossierRequest> duplicateDossierRequests = new List<CheckDuplicateDossierRequest>();
        Set<DossierQueryDTO> queryDTOs = new Set<DossierQueryDTO>();
        List<Business_Dossier__c> queryResult = new List<Business_Dossier__c>();
        for (Integer i = 0; i < 10; i++) {
            duplicateDossierRequests.add(new CheckDuplicateDossierRequest('' + i, '' + i));
            queryDTOs.add(new DossierQueryDTO(i + '', i + ''));
            queryResult.add(new Business_Dossier__c(Dossier_Number__c = '' + i,
                    Establishment_Number__c = '' + i,
                    Account__c = fflib_IDGenerator.generate(Account.SObjectType),
                    Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType))
            );
        }

        mocks.startStubbing();
        mocks.when(selector.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(selector.selectByDossierNumbers((Set<DossierQueryDTO>)fflib_Match.anyObject(), fflib_Match.eqBoolean(false))).thenReturn(queryResult);
        mocks.stopStubbing();

        Application.Selector.setMock(selector);

        Test.startTest();
        {
            List<CheckDuplicateDossierResponse> responses = BusinessDuplicateService.checkForDuplicateDossiers(duplicateDossierRequests);
            System.assert(responses.size() == 10);
            for (Integer i = 0; i < 10; i++) {
                System.assert(responses.get(i).dossierFound == queryResult.get(i));
            }
        }
        Test.stopTest();
    }

    @IsTest
    public static void testCheckForDuplicateDossiersExceptionThrown() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessDossierSelector selector = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);

        List<CheckDuplicateDossierRequest> duplicateDossierRequests = new List<CheckDuplicateDossierRequest>();
        Set<DossierQueryDTO> queryDTOs = new Set<DossierQueryDTO>();
        List<Business_Dossier__c> queryResult = new List<Business_Dossier__c>();
        for (Integer i = 0; i < 10; i++) {
            duplicateDossierRequests.add(new CheckDuplicateDossierRequest('' + i, '' + i));
            queryDTOs.add(new DossierQueryDTO(i + '', i + ''));
            queryResult.add(new Business_Dossier__c(Dossier_Number__c = '' + i,
                    Establishment_Number__c = '' + i,
                    Account__c = fflib_IDGenerator.generate(Account.SObjectType),
                    Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType))
            );
        }

        mocks.startStubbing();
        mocks.when(selector.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.when(selector.selectByDossierNumbers((Set<DossierQueryDTO>)fflib_Match.anyObject(), fflib_Match.eqBoolean(false))).thenThrow(new CustomException('test'));
        mocks.stopStubbing();

        Application.Selector.setMock(selector);

        Boolean exceptionCaught = false;
        Test.startTest();
        {
            try {
                BusinessDuplicateService.checkForDuplicateDossiers(duplicateDossierRequests);
            } catch (CCException e) {
                exceptionCaught = true;
            }
        }
        Test.stopTest();
        System.assert(exceptionCaught);
        System.assert([SELECT Id FROM Error_Log__c].size() == 1);
    }


//    @IsTest
//    public static void testCheckDossierDossierDoesNotExist() {
//        fflib_ApexMocks mocks = new fflib_ApexMocks();
//        IBusinessDossierSelector mockDossierSelector = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);
//
//        mocks.startStubbing();
//        mocks.when(mockDossierSelector.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
//        mocks.when(mockDossierSelector.selectByDossierNumbers((Set<DossierQueryDTO>)fflib_Match.anyObject(), (Boolean)fflib_Match.eq(false))).thenReturn(new List<Business_Dossier__c>());
//        mocks.stopStubbing();
//        Application.Selector.setMock(mockDossierSelector);
//
//        Boolean result = true;
//        Test.startTest();
//        Business_Dossier__c dossier2 = BusinessDuplicateService.checkSingleDuplicateDossier('1234', '1234');
//        result = dossier2 != null ? true : false;
//        Test.stopTest();
//        System.assert(!result);
//    }
//
//    @IsTest
//    public static void testCheckDossierDossierDoesExist() {
//        fflib_ApexMocks mocks = new fflib_ApexMocks();
//        IBusinessDossierSelector mockDossierSelector = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);
//
//        mocks.startStubbing();
//        mocks.when(mockDossierSelector.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
//        Business_Dossier__c dossier = new Business_Dossier__c(Id = fflib_IDGenerator.generate(Business_Dossier__c.SObjectType));
//        mocks.when(mockDossierSelector.selectByDossierNumbers((Set<DossierQueryDTO>)fflib_Match.anyObject(), (Boolean)fflib_Match.eq(false))).thenReturn(new List<Business_Dossier__c>{dossier});
//        mocks.stopStubbing();
//        Application.Selector.setMock(mockDossierSelector);
//
//        Boolean result = false;
//        Test.startTest();
//        Business_Dossier__c dossier2 = BusinessDuplicateService.checkSingleDuplicateDossier('1234', '1234');
//        result = dossier2 != null ? true : false;
//        Test.stopTest();
//        System.assert(result);
//    }

}