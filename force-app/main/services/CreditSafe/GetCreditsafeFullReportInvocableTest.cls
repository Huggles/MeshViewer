/**
 * Created by tejaswinidandi on 10/03/2020.
 */

@IsTest
private class GetCreditsafeFullReportInvocableTest {

    @IsTest
    static void testGetCreditSafeReportFullHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2 = CreditSafeServiceImplTest.createCompanyReportFullV2Mock();

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeGetReportFullV2(fflib_Match.anyString(), fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(reportFullV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);
        Creditsafe_Company_Report_Full__c reportFull;
        List<Creditsafe_Company_Report_Full__c> reportFulls;
                Test.startTest();
        {
            List<GetCreditsafeFullReportInvocable.CreditsafeReportParameters> parameters = new List<GetCreditsafeFullReportInvocable.CreditsafeReportParameters>();
            parameters.add(new GetCreditsafeFullReportInvocable.CreditsafeReportParameters('BE-X-831382050', 'EN', ''));
            reportFulls = GetCreditsafeFullReportInvocable.getCreditsafeCompanyReportFull(parameters);
        }
        Test.stopTest();
        System.assert(reportFulls.size() > 0);
        reportFull = reportFulls[0];
        System.assert(reportFull != null);

        List<Additional_Info_NL_Letter_Of_Liability__c> additionalInfoNLLetterOfLiabilities = [
                SELECT Id
                FROM Additional_Info_NL_Letter_Of_Liability__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];

        System.assert(additionalInfoNLLetterOfLiabilities.size() == 2);

        List<Additional_Information_NL_Kvk_Filing__c> kvkFilings = [
                SELECT Id
                FROM Additional_Information_NL_Kvk_Filing__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(kvkFilings.size() == 2);

        List<Additional_Information_NL_Financial_Item__c> financialItems = [
                SELECT Id
                FROM Additional_Information_NL_Financial_Item__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];

        System.assert(financialItems.size() == 2);

        List<Additional_Information_Historical_Event__c> historicalEvents = [
                SELECT Id
                FROM Additional_Information_Historical_Event__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(historicalEvents.size() == 4);

        List<Creditsafe_Address__c> addresses = [
                SELECT Id
                FROM Creditsafe_Address__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(addresses.size() == 2);

        List<Creditsafe_Company_Key_Value__c> keyValue = [
                SELECT Id
                FROM Creditsafe_Company_Key_Value__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(keyValue.size() == 6);

    }

}