/**
 * Created by tejaswinidandi on 2019-08-01.
 */

@IsTest
public class UpdateDossiersBatchTest {

    @IsTest
    public static void testNoResults() {
        // given
        // a list of updated  dossiers from the CI backend
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness wsDutchBusinessMock = (IWsDutchBusiness) mocks.mock(IWsDutchBusiness.class);
        mocks.startStubbing();

        mocks.when(wsDutchBusinessMock.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray) fflib_Match.anyObject(), fflib_Match.integerBetween(1, true, 1, true))).thenReturn(getDutchBusinessUpdateReferencePagedResultMock(10, 1, 1, 0, 1));
        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, wsDutchBusinessMock);
        // with no match with the dossiers currently in SF
        List<Business_Dossier__c> dossiers = getBusinessDossiersMock(10, 30, 1, 1);
        insert dossiers;
        dossiers = [
                SELECT
                        Annual_Financial_Statement_Summary__c,
                        Assets__c,
                        Authorized_Share_Capital__c,
                        Authorized_Share_Capital_Currency__c,
                        Chamber_Code__c,
                        Chamber_Number__c,
                        Class_Personnel__c,
                        Class_Personnel_CI__c,
                        Class_Personnel_Fulltime__c,
                        Contact_Gender__c,
                        Contact_Initials__c,
                        Contact_Prefix__c,
                        Contact_Surname__c,
                        Contact_Title1__c,
                        Contact_Title2__c,
                        Continuation_Date__c,
                        Creditsafe_Id__c,
                        Date_of_Last_Account__c,
                        Date_of_Last_Change__c,
                        Discontinuation_Date__c,
                        Domain_Name__c,
                        Dossier_Number__c,
                        Establishment_Date__c,
                        Establishment_Number__c,
                        Founding_Date__c,
                        Indication_Bankruptcy__c,
                        Indication_Dip__c,
                        Indication_Economically_Active__c,
                        Indication_Export__c,
                        Indication_Import__c,
                        Indication_Main_Establishment__c,
                        Indication_Non_Mailing__c,
                        Indication_Organisation_Code__c,
                        Insolvencies__c,
                        Is_Removed__c,
                        Issued_Share_Capital__c,
                        Issued_Share_Capital_Currency__c,
                        Legal_Form_Code__c,
                        Legal_Form_Text__c,
                        Main_Establishment_Number__c,
                        Mobile_Number__c,
                        Number_Of_Subsidiaries__c,
                        Office_Type__c,
                        Paid_Up_Share_Capital__c,
                        Paid_Up_Share_Capital_Currency__c,
                        Parent_Chamber_Of_Commerce_Number__c,
                        Personnel__c,
                        Personnel_CI__c,
                        Personnel_CI_Reference_Date__c,
                        Personnel_Fulltime__c,
                        Personnel_Reference_Date__c,
                        Primary_Sbi_Code__c,
                        Primary_Sbi_Code_Text__c,
                        Profit__c,
                        Registration_Country__c,
                        Rsin_Number__c,
                        Sbi_Collection__c,
                        Secondary_Sbi_Code_1__c,
                        Secondary_Sbi_Code_1_Text__c,
                        Secondary_Sbi_Code_2__c,
                        Secondary_Sbi_Code_2_Text__c,
                        Status__c,
                        Structure__c,
                        Telephone_Number__c,
                        Trade_Name_45__c,
                        Trade_Name_Full__c,
                        Trade_Names__c,
                        Turnover__c,
                        Type__c,
                        Ultimate_Parent_Chamber_Of_Commerce_Nr__c,
                        VAT_Number__c,
                        Year__c,
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        RecordTypeId,
                        SystemModstamp
                FROM Business_Dossier__c];

        // when
        // we run the batch
        Test.startTest();
        Database.Batchable<Business_Dossier__c> batch = new UpdateDossiersBatch();
        Database.executeBatch(batch, 100);
        Test.stopTest();

        // then
        // no dossiers in the DB should be changed
        List<Business_Dossier__c> dossiersToBeAsserted = [
                SELECT
                        Annual_Financial_Statement_Summary__c,
                        Assets__c,
                        Authorized_Share_Capital__c,
                        Authorized_Share_Capital_Currency__c,
                        Chamber_Code__c,
                        Chamber_Number__c,
                        Class_Personnel__c,
                        Class_Personnel_CI__c,
                        Class_Personnel_Fulltime__c,
                        Contact_Gender__c,
                        Contact_Initials__c,
                        Contact_Prefix__c,
                        Contact_Surname__c,
                        Contact_Title1__c,
                        Contact_Title2__c,
                        Continuation_Date__c,
                        Creditsafe_Id__c,
                        Date_of_Last_Account__c,
                        Date_of_Last_Change__c,
                        Discontinuation_Date__c,
                        Domain_Name__c,
                        Dossier_Number__c,
                        Establishment_Date__c,
                        Establishment_Number__c,
                        Founding_Date__c,
                        Indication_Bankruptcy__c,
                        Indication_Dip__c,
                        Indication_Economically_Active__c,
                        Indication_Export__c,
                        Indication_Import__c,
                        Indication_Main_Establishment__c,
                        Indication_Non_Mailing__c,
                        Indication_Organisation_Code__c,
                        Insolvencies__c,
                        Is_Removed__c,
                        Issued_Share_Capital__c,
                        Issued_Share_Capital_Currency__c,
                        Legal_Form_Code__c,
                        Legal_Form_Text__c,
                        Main_Establishment_Number__c,
                        Mobile_Number__c,
                        Number_Of_Subsidiaries__c,
                        Office_Type__c,
                        Paid_Up_Share_Capital__c,
                        Paid_Up_Share_Capital_Currency__c,
                        Parent_Chamber_Of_Commerce_Number__c,
                        Personnel__c,
                        Personnel_CI__c,
                        Personnel_CI_Reference_Date__c,
                        Personnel_Fulltime__c,
                        Personnel_Reference_Date__c,
                        Primary_Sbi_Code__c,
                        Primary_Sbi_Code_Text__c,
                        Profit__c,
                        Registration_Country__c,
                        Rsin_Number__c,
                        Sbi_Collection__c,
                        Secondary_Sbi_Code_1__c,
                        Secondary_Sbi_Code_1_Text__c,
                        Secondary_Sbi_Code_2__c,
                        Secondary_Sbi_Code_2_Text__c,
                        Status__c,
                        Structure__c,
                        Telephone_Number__c,
                        Trade_Name_45__c,
                        Trade_Name_Full__c,
                        Trade_Names__c,
                        Turnover__c,
                        Type__c,
                        Ultimate_Parent_Chamber_Of_Commerce_Nr__c,
                        VAT_Number__c,
                        Year__c,
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        RecordTypeId,
                        SystemModstamp
                FROM Business_Dossier__c
        ];
        System.assert(dossiers.size() == dossiersToBeAsserted.size());
        Map<String, Business_Dossier__c> dossiersToBeAssertedByUniqueId = new Map<String, Business_Dossier__c>();
        for (Business_Dossier__c businessDossier : dossiersToBeAsserted) {
            dossiersToBeAssertedByUniqueId.put(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c, businessDossier);
        }
        for (Business_Dossier__c businessDossier : dossiers) {
            Business_Dossier__c dossierToBeAsserted = dossiersToBeAssertedByUniqueId.get(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c);
            System.assert(dossierToBeAsserted != null);
            System.assert(businessDossier == dossierToBeAsserted);
        }
    }

    @IsTest
    public static void testErrorHandlingInitialization() {
        // given
        // the dutchBusinessUpdateGetChangedDossiers method throws an exception
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IDutchBusinessService dutchBusinessServiceMock = (IDutchBusinessService) mocks.mock(IDutchBusinessService.class);

        mocks.startStubbing();

        mocks.when(dutchBusinessServiceMock.getDutchBusinessUpdatedDossiersSince(fflib_Match.anyInteger(), (List<String>)fflib_Match.anyList(), fflib_Match.anyDate())).thenThrow(new CCException());
        mocks.stopStubbing();
        Application.Service.setMock(IDutchBusinessService.class, dutchBusinessServiceMock);

        // when
        Test.startTest();
        try {
            Database.Batchable<Business_Dossier__c> batch = new UpdateDossiersBatch();
            Database.executeBatch(batch, 100);
        } catch (CCException e) {

        }
        Test.stopTest();

        // then



    }


    @IsTest
    public static void testOnePage() {
        // given
        // a list of updated  dossiers from the CI backend (one page)
        // with matches to the SF dossiers
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness wsDutchBusinessMock = (IWsDutchBusiness) mocks.mock(IWsDutchBusiness.class);
        mocks.startStubbing();

        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult dutchBusinessUpdateReferencePagedResultMock = getDutchBusinessUpdateReferencePagedResultMock(10, 1, 1, 1, 1);
        mocks.when(wsDutchBusinessMock.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray) fflib_Match.anyObject(), fflib_Match.integerBetween(1, true, 1, true))).thenReturn(dutchBusinessUpdateReferencePagedResultMock);
        for (DutchBusinessWsdl.DutchBusinessUpdateReference businessUpdateReference : dutchBusinessUpdateReferencePagedResultMock.results.item) {
            mocks.when(wsDutchBusinessMock.dutchBusinessGetDossierV3(businessUpdateReference.dossier_number, businessUpdateReference.establishment_number)).thenReturn(getWsDutchBusinessDossierV3Mock(businessUpdateReference.dossier_number, businessUpdateReference.establishment_number));
        }
        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, wsDutchBusinessMock);
        // with a match with the dossiers currently in SF
        List<Business_Dossier__c> dossiers = getBusinessDossiersMock(10, 1, 1, 1);
        insert dossiers;
        dossiers = [
                SELECT
                        Annual_Financial_Statement_Summary__c,
                        Assets__c,
                        Authorized_Share_Capital__c,
                        Authorized_Share_Capital_Currency__c,
                        Chamber_Code__c,
                        Chamber_Number__c,
                        Class_Personnel__c,
                        Class_Personnel_CI__c,
                        Class_Personnel_Fulltime__c,
                        Contact_Gender__c,
                        Contact_Initials__c,
                        Contact_Prefix__c,
                        Contact_Surname__c,
                        Contact_Title1__c,
                        Contact_Title2__c,
                        Continuation_Date__c,
                        Creditsafe_Id__c,
                        Date_of_Last_Account__c,
                        Date_of_Last_Change__c,
                        Discontinuation_Date__c,
                        Domain_Name__c,
                        Dossier_Number__c,
                        Establishment_Date__c,
                        Establishment_Number__c,
                        Founding_Date__c,
                        Indication_Bankruptcy__c,
                        Indication_Dip__c,
                        Indication_Economically_Active__c,
                        Indication_Export__c,
                        Indication_Import__c,
                        Indication_Main_Establishment__c,
                        Indication_Non_Mailing__c,
                        Indication_Organisation_Code__c,
                        Insolvencies__c,
                        Is_Removed__c,
                        Issued_Share_Capital__c,
                        Issued_Share_Capital_Currency__c,
                        Legal_Form_Code__c,
                        Legal_Form_Text__c,
                        Main_Establishment_Number__c,
                        Mobile_Number__c,
                        Number_Of_Subsidiaries__c,
                        Office_Type__c,
                        Paid_Up_Share_Capital__c,
                        Paid_Up_Share_Capital_Currency__c,
                        Parent_Chamber_Of_Commerce_Number__c,
                        Personnel__c,
                        Personnel_CI__c,
                        Personnel_CI_Reference_Date__c,
                        Personnel_Fulltime__c,
                        Personnel_Reference_Date__c,
                        Primary_Sbi_Code__c,
                        Primary_Sbi_Code_Text__c,
                        Profit__c,
                        Registration_Country__c,
                        Rsin_Number__c,
                        Sbi_Collection__c,
                        Secondary_Sbi_Code_1__c,
                        Secondary_Sbi_Code_1_Text__c,
                        Secondary_Sbi_Code_2__c,
                        Secondary_Sbi_Code_2_Text__c,
                        Status__c,
                        Structure__c,
                        Telephone_Number__c,
                        Trade_Name_45__c,
                        Trade_Name_Full__c,
                        Trade_Names__c,
                        Turnover__c,
                        Type__c,
                        Ultimate_Parent_Chamber_Of_Commerce_Nr__c,
                        VAT_Number__c,
                        Year__c,
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        RecordTypeId,
                        SystemModstamp
                FROM Business_Dossier__c];

        // when
        // we run the batch
        Test.startTest();
        Database.Batchable<Business_Dossier__c> batch = new UpdateDossiersBatch();
        Database.executeBatch(batch, 100);
        Test.stopTest();

        // then
        // the matching dossiers in the DB should be changed
        List<Business_Dossier__c> dossiersToBeAsserted = [
                SELECT
                        Annual_Financial_Statement_Summary__c,
                        Assets__c,
                        Authorized_Share_Capital__c,
                        Authorized_Share_Capital_Currency__c,
                        Chamber_Code__c,
                        Chamber_Number__c,
                        Class_Personnel__c,
                        Class_Personnel_CI__c,
                        Class_Personnel_Fulltime__c,
                        Contact_Gender__c,
                        Contact_Initials__c,
                        Contact_Prefix__c,
                        Contact_Surname__c,
                        Contact_Title1__c,
                        Contact_Title2__c,
                        Continuation_Date__c,
                        Creditsafe_Id__c,
                        Date_of_Last_Account__c,
                        Date_of_Last_Change__c,
                        Discontinuation_Date__c,
                        Domain_Name__c,
                        Dossier_Number__c,
                        Establishment_Date__c,
                        Establishment_Number__c,
                        Founding_Date__c,
                        Indication_Bankruptcy__c,
                        Indication_Dip__c,
                        Indication_Economically_Active__c,
                        Indication_Export__c,
                        Indication_Import__c,
                        Indication_Main_Establishment__c,
                        Indication_Non_Mailing__c,
                        Indication_Organisation_Code__c,
                        Insolvencies__c,
                        Is_Removed__c,
                        Issued_Share_Capital__c,
                        Issued_Share_Capital_Currency__c,
                        Legal_Form_Code__c,
                        Legal_Form_Text__c,
                        Main_Establishment_Number__c,
                        Mobile_Number__c,
                        Number_Of_Subsidiaries__c,
                        Office_Type__c,
                        Paid_Up_Share_Capital__c,
                        Paid_Up_Share_Capital_Currency__c,
                        Parent_Chamber_Of_Commerce_Number__c,
                        Personnel__c,
                        Personnel_CI__c,
                        Personnel_CI_Reference_Date__c,
                        Personnel_Fulltime__c,
                        Personnel_Reference_Date__c,
                        Primary_Sbi_Code__c,
                        Primary_Sbi_Code_Text__c,
                        Profit__c,
                        Registration_Country__c,
                        Rsin_Number__c,
                        Sbi_Collection__c,
                        Secondary_Sbi_Code_1__c,
                        Secondary_Sbi_Code_1_Text__c,
                        Secondary_Sbi_Code_2__c,
                        Secondary_Sbi_Code_2_Text__c,
                        Status__c,
                        Structure__c,
                        Telephone_Number__c,
                        Trade_Name_45__c,
                        Trade_Name_Full__c,
                        Trade_Names__c,
                        Turnover__c,
                        Type__c,
                        Ultimate_Parent_Chamber_Of_Commerce_Nr__c,
                        VAT_Number__c,
                        Year__c,
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        RecordTypeId,
                        SystemModstamp
                FROM Business_Dossier__c WHERE Trade_Name_Full__c = 'test'];
        System.assert(dossiers.size() == dossiersToBeAsserted.size());

    }

    /**
     * Returns a mock DutchBusinessUpdateReferencePagedResult based on the given parameters
     *
     * @param nrOfDossiersPerPage the number of dossiers on the page
     * @param startDossierNr the offset for the dossier number
     * @param startEstablishmentNr the offset for the establishment number
     * @param nrOfEstablishmentsPerDossierNr the number of establishments per dossier
     * @param maxPages the max number of pages that can be returned
     *
     * @return a mocked DutchBusinessUpdateReferencePagedResult
     */
    @TestVisible
    private static DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult getDutchBusinessUpdateReferencePagedResultMock(Integer nrOfDossiersPerPage, Integer startDossierNr, Integer startEstablishmentNr, Integer nrOfEstablishmentsPerDossierNr, Integer maxPages) {
        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult output = new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();
        output.paging = new DutchBusinessWsdl.ResultInfo();
        output.paging.numpages = maxPages;
        output.results = new DutchBusinessWsdl.DutchBusinessUpdateReferenceArray();
        output.results.item = new List<DutchBusinessWsdl.DutchBusinessUpdateReference>();
        for (Integer i = 0; i < nrOfDossiersPerPage / (nrOfEstablishmentsPerDossierNr == 0 ? 1 : nrOfEstablishmentsPerDossierNr) ; i++) {
            DutchBusinessWsdl.DutchBusinessUpdateReference a1 =  new DutchBusinessWsdl.DutchBusinessUpdateReference();
            a1.dossier_number = '' + (startDossierNr + i);
            for (Integer i2 = 0; i2 < nrOfEstablishmentsPerDossierNr; i2++) {
                a1.establishment_number = '' + (startEstablishmentNr + i2);
            }
            a1.update_types = new DutchBusinessWsdl.stringArray();
            a1.update_types.item = new List<String>{'ChamberNo', 'Legalform', 'Name', 'EstablishmentAddress', 'CorrespondenceAddress'};
            output.results.item.add(a1);
        }
        return output;
    }

    /**
     * Returns a list of business dossiers with the given dossier and establishment numbers
     *
     * @param nrOfDossiers the number of dossiers to return
     * @param startDossierNr the offset for the dossier number
     * @param startEstablishmentNr the offset for the establishment number
     * @param nrOfEstablishmentsPerDossierNr the number of establishments per dossier to return
     *
     * @return a list of mocked business dossiers
     */
    @TestVisible
    private static List<Business_Dossier__c> getBusinessDossiersMock(Integer nrOfDossiers, Integer startDossierNr, Integer startEstablishmentNr, Integer nrOfEstablishmentsPerDossierNr) {
        List<Business_Dossier__c> dossiers = new List<Business_Dossier__c>();
        for (Integer i = 0; i < nrOfDossiers / (nrOfEstablishmentsPerDossierNr == 0 ? 1 : nrOfEstablishmentsPerDossierNr); i++) {
            Business_Dossier__c dossier = new Business_Dossier__c(Name = '' + i, Dossier_Number__c = '' + (startDossierNr + i));
            for (Integer i2 = 0; i2 < nrOfEstablishmentsPerDossierNr; i2++) {
                dossier.Establishment_Number__c = '' + (startEstablishmentNr + i2);
            }
            dossiers.add(dossier);
        }
        return dossiers;
    }

    /**
     * Returns a mock dutch business dossier with a trade name set to test
     *
     * @param dossierNumber the dossier number to get a mock for
     * @param establishmentNumber the establisthment number to get a mock for
     *
     * @return a mock DutchBusinessDossierV3
     */
    @TestVisible
    private static DutchBusinessWsdl.DutchBusinessDossierV3 getWsDutchBusinessDossierV3Mock(String dossierNumber, String establishmentNumber) {
        DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessDossierV3 = new DutchBusinessWsdl.DutchBusinessDossierV3();
        dutchBusinessDossierV3.dossier_number = dossierNumber;
        dutchBusinessDossierV3.establishment_number = establishmentNumber;
        dutchBusinessDossierV3.trade_name_full = 'test';
        return dutchBusinessDossierV3;
    }
}