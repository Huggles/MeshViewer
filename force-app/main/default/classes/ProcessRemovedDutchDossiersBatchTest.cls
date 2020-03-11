/**
 * Created by jaapbranderhorst on 04/02/2020.
 */

@IsTest
private class ProcessRemovedDutchDossiersBatchTest {

    @IsTest
    static void testNoResults() {
        // given
        // a list of updated  dossiers from the CI backend
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness wsDutchBusinessMock = (IWsDutchBusiness) mocks.mock(IWsDutchBusiness.class);
        mocks.startStubbing();

        mocks.when(wsDutchBusinessMock.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray) fflib_Match.anyObject(), fflib_Match.integerBetween(1, true, 1, true))).thenReturn(UpdateDossiersBatchTest.getDutchBusinessUpdateReferencePagedResultMock(10, 1, 1, 0, 1));
        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, wsDutchBusinessMock);
        // with no match with the dossiers currently in SF
        List<Business_Dossier__c> dossiers = UpdateDossiersBatchTest.getBusinessDossiersMock(10, 30, 1, 1);
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
        Database.Batchable<Business_Dossier__c> batch = new ProcessRemovedDutchDossiersBatch();
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
    private static void testOnePage() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness wsDutchBusinessMock = (IWsDutchBusiness) mocks.mock(IWsDutchBusiness.class);
        mocks.startStubbing();

        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult dutchBusinessUpdateReferencePagedResultMock = UpdateDossiersBatchTest.getDutchBusinessUpdateReferencePagedResultMock(10, 1, 1, 1, 1);
        mocks.when(wsDutchBusinessMock.dutchBusinessUpdateGetChangedDossiers(fflib_Match.anyDate(), (DutchBusinessWsdl.stringArray) fflib_Match.anyObject(), fflib_Match.integerBetween(1, true, 1, true))).thenReturn(dutchBusinessUpdateReferencePagedResultMock);
        mocks.stopStubbing();
        Application.Service.setMock(IWsDutchBusiness.class, wsDutchBusinessMock);
        // with a match with the dossiers currently in SF
        List<Business_Dossier__c> dossiers = UpdateDossiersBatchTest.getBusinessDossiersMock(10, 1, 1, 1);
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
        Database.Batchable<Business_Dossier__c> batch = new ProcessRemovedDutchDossiersBatch();
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
                FROM Business_Dossier__c WHERE Is_Removed__c = true];
        System.assert(dossiers.size() == dossiersToBeAsserted.size());

    }
}