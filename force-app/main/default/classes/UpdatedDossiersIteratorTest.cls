/**
 * Created by jaapbranderhorst on 02/02/2020.
 */

@IsTest
private class UpdatedDossiersIteratorTest {

    private static final List<String> updateMockStrings = new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress', 'Contact',
            'Activity', 'Personnel', 'FinancialStatus', 'Status', 'Branch', 'ImportExport', 'ContactPerson', 'Capital',
            'SubscriptionDates', 'New', 'Establishment', 'RSIN', 'Tradenames'};

    @IsTest
    static void testNoResults() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService businessServiceMock = (IBusinessService)mocks.mock(IBusinessService.class);

        mocks.startStubbing();
        mocks.when(businessServiceMock.getDutchBusinessUpdatedDossiersSince(fflib_Match.anyInteger(), (List<String>)fflib_Match.anyList(), fflib_Match.anyDate())).thenReturn(new List<UpdateDossierReferenceDTO>());
        mocks.stopStubbing();

        Application.Service.setMock(IBusinessService.class, businessServiceMock);

        // when
        Test.startTest();
        UpdatedDossiersIterator iterator = new UpdatedDossiersIterator(updateMockStrings, new UpdateDossiersBatch(), null);
        Test.stopTest();

        // then
        System.assert(!iterator.hasNext());

    }

    @IsTest
    static void testOnePageWithOneDossier() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService businessServiceMock = (IBusinessService)mocks.mock(IBusinessService.class);
        IBusinessDossierSelector businessDossierSelectorMock = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);

        mocks.startStubbing();
        // mock getDutchBusinessUpdatedDossiersSince
        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();

        DutchBusinessWsdl.DutchBusinessUpdateReference a1 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a1.dossier_number = '1';
        a1.establishment_number = '2';
        a1.update_types = stringArray(new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress'});

        List<UpdateDossierReferenceDTO> updateDossierReferenceDTOS = new List<UpdateDossierReferenceDTO>();
        UpdateDossierReferenceDTO updateDossierReferenceDTO = new UpdateDossierReferenceDTO(a1, 1);
        updateDossierReferenceDTOs.add(updateDossierReferenceDTO);

        mocks.when(businessServiceMock.getDutchBusinessUpdatedDossiersSince(fflib_Match.anyInteger(), (List<String>)fflib_Match.anyList(), fflib_Match.anyDate())).thenReturn(updateDossierReferenceDTOS);

        // mock selectByDossierNumbers
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>{new Business_Dossier__c(Establishment_Number__c = '2', Dossier_Number__c = '1', Name = 'fake')};
        mocks.when(businessDossierSelectorMock.selectByDossierNumbers((Set<DossierQueryDTO>)fflib_Match.anyObject(), fflib_Match.eqBoolean(false))).thenReturn(dossiers);
        mocks.when(businessDossierSelectorMock.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.stopStubbing();

        Application.Service.setMock(IBusinessService.class, businessServiceMock);
        Application.Selector.setMock(businessDossierSelectorMock);

        // when
        Test.startTest();
        UpdatedDossiersIterator iterator = new UpdatedDossiersIterator(updateMockStrings, new UpdateDossiersBatch(), null);
        Test.stopTest();

        // then
        System.assert(iterator.hasNext());
        System.assert(iterator.next() != null);
        System.assert(!iterator.hasNext());

    }

    @IsTest
    static void testTwoPagesWithOneDossier() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IBusinessService businessServiceMock = (IBusinessService)mocks.mock(IBusinessService.class);
        IBusinessDossierSelector businessDossierSelectorMock = (IBusinessDossierSelector)mocks.mock(IBusinessDossierSelector.class);

        mocks.startStubbing();
        // mock getDutchBusinessUpdatedDossiersSince
        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();

        DutchBusinessWsdl.DutchBusinessUpdateReference a1 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
        a1.dossier_number = '1';
        a1.establishment_number = '2';
        a1.update_types = stringArray(new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress'});

        List<UpdateDossierReferenceDTO> updateDossierReferenceDTOS = new List<UpdateDossierReferenceDTO>();
        UpdateDossierReferenceDTO updateDossierReferenceDTO = new UpdateDossierReferenceDTO(a1, 2);
        updateDossierReferenceDTOs.add(updateDossierReferenceDTO);

        mocks.when(businessServiceMock.getDutchBusinessUpdatedDossiersSince(fflib_Match.anyInteger(), (List<String>)fflib_Match.anyList(), fflib_Match.anyDate())).thenReturn(updateDossierReferenceDTOS);

        // mock selectByDossierNumbers
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>{new Business_Dossier__c(Establishment_Number__c = '2', Dossier_Number__c = '1', Name = 'fake')};
        mocks.when(businessDossierSelectorMock.selectByDossierNumbers((Set<DossierQueryDTO>)fflib_Match.anyObject(), fflib_Match.eqBoolean(false))).thenReturn(dossiers);
        mocks.when(businessDossierSelectorMock.sObjectType()).thenReturn(Business_Dossier__c.SObjectType);
        mocks.stopStubbing();

        Application.Service.setMock(IBusinessService.class, businessServiceMock);
        Application.Selector.setMock(businessDossierSelectorMock);

        // when
        Test.startTest();
        UpdatedDossiersIterator iterator = new UpdatedDossiersIterator(updateMockStrings, new UpdateDossiersBatch(), null);
        Test.stopTest();

        // then
        System.assert(iterator.hasNext());
        System.assert(iterator.next() != null);
        System.assert(iterator.hasNext());
        System.assert(iterator.next() != null);
        System.assert(!iterator.hasNext());

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