/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

@IsTest
private class CreditSafeWsdlTest {

    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {
            if (request instanceof CreditsafeWsdl.creditsafeMonitorGetUpdatedCompaniesRequestType)
                response.put('response_x', new CreditsafeWsdl.creditsafeMonitorGetUpdatedCompaniesResponseType());
            if (request instanceof CreditsafeWsdl.creditsafeSearchV2RequestType)
                response.put('response_x', new CreditsafeWsdl.creditsafeSearchV2ResponseType());
            if (request instanceof CreditsafeWsdl.creditsafeSearchCriteriaRequestType)
                response.put('response_x', new CreditsafeWsdl.creditsafeSearchCriteriaResponseType());
            if (request instanceof CreditsafeWsdl.loginRequestType)
                response.put('response_x', new CreditsafeWsdl.loginResponseType());
            if (request instanceof CreditsafeWsdl.creditsafeGetReportFullV2RequestType)
                response.put('response_x', new CreditsafeWsdl.creditsafeGetReportFullV2ResponseType());
            if (request instanceof CreditsafeWsdl.creditsafeSearchRequestType)
                response.put('response_x', new CreditsafeWsdl.creditsafeSearchResponseType());
            if (request instanceof CreditsafeWsdl.creditsafeMonitorAddCompanyRequestType)
                response.put('response_x', new CreditsafeWsdl.creditsafeMonitorAddCompanyResponseType());
            if (request instanceof CreditsafeWsdl.logoutRequestType)
                response.put('response_x', new CreditsafeWsdl.logoutResponseType());
            if (request instanceof CreditsafeWsdl.creditsafeGetReportFullRequestType)
                response.put('response_x', new CreditsafeWsdl.creditsafeGetReportFullResponseType());
            if (request instanceof CreditsafeWsdl.creditsafeMonitorRemoveCompanyRequestType)
                response.put('response_x', new CreditsafeWsdl.creditsafeMonitorRemoveCompanyResponseType());
        }
    }

    @IsTest
    private static void testCoverMethods1() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new CreditsafeWsdl.Webservices_nlPort().creditsafeMonitorGetUpdatedCompanies(null,null);
        new CreditsafeWsdl.Webservices_nlPort().creditsafeSearchV2(null,null, null, null, null, null, null, null, null, null, null);
        new CreditsafeWsdl.Webservices_nlPort().creditsafeSearch(null,null, null, null, null, null, null, null, null,null, null, null, null, null, null, null);
        new CreditsafeWsdl.Webservices_nlPort().creditsafeSearchCriteria(null);
        new CreditsafeWsdl.Webservices_nlPort().login(null,null);
        new CreditsafeWsdl.Webservices_nlPort().creditsafeGetReportFullV2(null,null , null);
        new CreditsafeWsdl.Webservices_nlPort().creditsafeMonitorAddCompany(null);
        new CreditsafeWsdl.Webservices_nlPort().logout();
        new CreditsafeWsdl.Webservices_nlPort().creditsafeGetReportFull(null,null, null);
        new CreditsafeWsdl.Webservices_nlPort().creditsafeMonitorRemoveCompany(null);
    }

    @IsTest
    static void testCoverTypes() {
        new CreditsafeWsdl.CreditsafeSearchCriteriaCombination();
        new CreditsafeWsdl.CreditsafeCompanyCreditScoreV2Array();
        new CreditsafeWsdl.CreditsafeCompanyKeyValueV2();
        new CreditsafeWsdl.CreditsafeCompanyOtherInformationV2();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLV2();
        new CreditsafeWsdl.CreditsafeAdvisorArray();
        new CreditsafeWsdl.CreditsafeCompanyUpdateArray();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEV2();
        new CreditsafeWsdl.CreditsafeDescriptionV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2Array();
        new CreditsafeWsdl.CreditsafePreviousDirector();
        new CreditsafeWsdl.CreditsafeDirectorArray();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2Array();
        new CreditsafeWsdl.CreditsafeCompany();
        new CreditsafeWsdl.creditsafeMonitorAddCompanyRequestType();
        new CreditsafeWsdl.CreditsafeLtdDirectors();
        new CreditsafeWsdl.CreditsafeBanker();
        new CreditsafeWsdl.CreditsafeCompanyProfitAndLossV2();
        new CreditsafeWsdl.CreditsafeCompanyBankerV2();
        new CreditsafeWsdl.CreditsafeBeBankruptcyEvent();
        new CreditsafeWsdl.CreditsafeBeEventArray();
        new CreditsafeWsdl.CreditsafeCompanyProfitAndLossV2Array();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationV2();
        new CreditsafeWsdl.CreditsafeOtherFinancials();
        new CreditsafeWsdl.CreditsafeEmployeeInformationArray();
        new CreditsafeWsdl.CreditsafeNlCourtDataFacts();
        new CreditsafeWsdl.CreditsafeBeEvent();
        new CreditsafeWsdl.loginResponseType();
        new CreditsafeWsdl.CreditsafeIndustryQuartilyAnalysis();
        new CreditsafeWsdl.ResultInfo();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEImageAccountV2Array();
        new CreditsafeWsdl.creditsafeSearchV2RequestType();
        new CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2Array();
        new CreditsafeWsdl.CreditsafeLtdCompanyBasicInformation();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2();
        new CreditsafeWsdl.creditsafeGetReportFullV2RequestType();
        new CreditsafeWsdl.CreditsafeBeMisc();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEBankruptcyV2Array();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2Array();
        new CreditsafeWsdl.CreditsafeValueV2();
        new CreditsafeWsdl.CreditsafeCompanyArray();
        new CreditsafeWsdl.CreditsafePersonPreviousDirectorV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisDayV2Array();
        new CreditsafeWsdl.CreditsafeCompanyPaymentDataV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLMiscellaneousV2();
        new CreditsafeWsdl.CreditsafeCompanyCreditScoreV2();
        new CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLMiscellaneousV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEOwnerV2();
        new CreditsafeWsdl.CreditsafeCompanyReportFullV2Array();
        new CreditsafeWsdl.CreditsafeBeNegativeInformation();
        new CreditsafeWsdl.CreditsafeNlLettersOfLiabilityArray();
        new CreditsafeWsdl.CreditsafeSearchCriteriaParamArray();
        new CreditsafeWsdl.CreditsafeDirector();
        new CreditsafeWsdl.CreditsafeCompanyListEntryArray();
        new CreditsafeWsdl.CreditsafeCompanyCreditRatingV2();
        new CreditsafeWsdl.CreditsafeCompanyReportFull();
        new CreditsafeWsdl.CreditsafeBankerArray();
        new CreditsafeWsdl.CreditsafePersonDirectorsV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2Array();
        new CreditsafeWsdl.CreditsafeCompanyPaymentDataV2Array();
        new CreditsafeWsdl.CreditsafeLtdFinancialStatement();
        new CreditsafeWsdl.CreditsafeNlNegativeInformation();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2();
        new CreditsafeWsdl.creditsafeGetReportFullResponseType();
        new CreditsafeWsdl.CreditsafeChangedString();
        new CreditsafeWsdl.creditsafeMonitorGetUpdatedCompaniesRequestType();
        new CreditsafeWsdl.stringArray();
        new CreditsafeWsdl.CreditsafeBeProtestedBillArray();
        new CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2Array();
        new CreditsafeWsdl.CreditsafeCompanyIdentificationV2Array();
        new CreditsafeWsdl.CreditsafeNlCourtDataReceiver();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2();
        new CreditsafeWsdl.CreditsafeCompanyCreditRatingV2Array();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDETrusteeV2Array();
        new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        new CreditsafeWsdl.creditsafeSearchCriteriaRequestType();
        new CreditsafeWsdl.CreditsafeCompanyContactInformationV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2();
        new CreditsafeWsdl.loginRequestType();
        new CreditsafeWsdl.CreditsafeBeNSSODetailArray();
        new CreditsafeWsdl.CreditsafeCompanyActivity();
        new CreditsafeWsdl.CreditsafeSearchCriteria();
        new CreditsafeWsdl.HeaderAuthenticateType();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisV2();
        new CreditsafeWsdl.CreditsafePersonDirectorV2Array();
        new CreditsafeWsdl.CreditsafeCompanyGroupStructureV2();
        new CreditsafeWsdl.CreditsafeCompanyOtherInformationV2Array();
        new CreditsafeWsdl.CreditsafeCompanyBalanceSheetV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisDayV2();
        new CreditsafeWsdl.CreditsafeLtdGroupStructure();
        new CreditsafeWsdl.CreditsafeCompanyReportFullV2();
        new CreditsafeWsdl.logoutRequestType();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisV2Array();
        new CreditsafeWsdl.CreditsafePersonPreviousDirectorV2();
        new CreditsafeWsdl.CreditsafeStreetAddress();
        new CreditsafeWsdl.CreditsafeCompanyAdvisorV2();
        new CreditsafeWsdl.creditsafeSearchV2ResponseType();
        new CreditsafeWsdl.CreditsafeFinancialRatios();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEV2Array();
        new CreditsafeWsdl.CreditsafeCompanyCompanyV2Array();
        new CreditsafeWsdl.CreditsafeLtdContactInformation();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyInformationV2Array();
        new CreditsafeWsdl.creditsafeGetReportFullRequestType();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryComparisonV2Array();
        new CreditsafeWsdl.CreditsafeCompanySummaryV2Array();
        new CreditsafeWsdl.CreditsafeSearchCriteriaParam();
        new CreditsafeWsdl.CreditsafeCompanyV2();
        new CreditsafeWsdl.CreditsafeBePaymentExpectationsSummary();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLV2Array();
        new CreditsafeWsdl.CreditsafeCompanyActivityV2Array();
        new CreditsafeWsdl.CreditsafeCompanyListEntry();
        new CreditsafeWsdl.CreditsafeAddressV2();
        new CreditsafeWsdl.CreditsafeProfitAndLossFigures();
        new CreditsafeWsdl.CreditsafeCompanyOtherFinancialsV2Array();
        new CreditsafeWsdl.CreditsafeCompanyBalanceSheetV2();
        new CreditsafeWsdl.CreditsafeSearchResultV2();
        new CreditsafeWsdl.CreditsafeQuartiles();
        new CreditsafeWsdl.CreditsafeBeRegisteredContractor();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLPaymentExpectationsSummaryV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEImageAccountV2();
        new CreditsafeWsdl.CreditsafeCompanyStatusV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2Array();
        new CreditsafeWsdl.CreditsafeCompanyBankerV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDETurnoverRangeV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2();
        new CreditsafeWsdl.CreditsafeShareHolderArray();
        new CreditsafeWsdl.CreditsafeCompanyBasicInformationV2();
        new CreditsafeWsdl.CreditsafeCompanyContactInformationV2();
        new CreditsafeWsdl.CreditsafeLtdCreditScore();
        new CreditsafeWsdl.CreditsafeCompanyV2Array();
        new CreditsafeWsdl.CreditsafeBeAdditionalInformation();
        new CreditsafeWsdl.creditsafeMonitorGetUpdatedCompaniesResponseType();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEBankruptcyV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2Array();
        new CreditsafeWsdl.CreditsafeEmployeeInformation();
        new CreditsafeWsdl.CreditsafeCompanyActivityArray();
        new CreditsafeWsdl.CreditsafeCompanyShareHolderV2Array();
        new CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2();
        new CreditsafeWsdl.CreditsafePersonPositionV2();
        new CreditsafeWsdl.CreditsafeDescriptionV2Array();
        new CreditsafeWsdl.creditsafeSearchCriteriaResponseType();
        new CreditsafeWsdl.CreditsafeNlMisc();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDETurnoverRangeV2Array();
        new CreditsafeWsdl.CreditsafeCompanyShareHolderV2();
        new CreditsafeWsdl.HeaderLoginType();
        new CreditsafeWsdl.CreditsafeChangedStringArray();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2();
        new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2();
        new CreditsafeWsdl.CreditsafeValueV2Array();
        new CreditsafeWsdl.creditsafeGetReportFullV2ResponseType();
        new CreditsafeWsdl.CreditsafePreviousDirectorArray();
        new CreditsafeWsdl.CreditsafeStreetAddressWithTelephoneArray();
        new CreditsafeWsdl.CreditsafeCompanyBasicInformationV2Array();
        new CreditsafeWsdl.CreditsafeNlLettersOfLiabilityInformation403();
        new CreditsafeWsdl.CreditsafeCompanyGroupStructureV2Array();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDETrusteeV2();
        new CreditsafeWsdl.CreditsafeLtdShareCapitalStructure();
        new CreditsafeWsdl.CreditsafeShareHolder();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEMiscellaneousV2();
        new CreditsafeWsdl.CreditsafeCompanyStatusV2Array();
        new CreditsafeWsdl.CreditsafeAddressV2Array();
        new CreditsafeWsdl.CreditsafeCompanyOtherFinancialsV2();
        new CreditsafeWsdl.CreditsafeStreetAddressWithTelephone();
        new CreditsafeWsdl.CreditsafeCompanyShareCapitalStructureV2Array();
        new CreditsafeWsdl.creditsafeMonitorRemoveCompanyResponseType();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEAdditionalInformationV2Array();
        new CreditsafeWsdl.CreditsafeCompanyUpdate();
        new CreditsafeWsdl.CreditsafeCompanyUpdatePagedResult();
        new CreditsafeWsdl.CreditsafeAdditionalInformation();
        new CreditsafeWsdl.creditsafeMonitorRemoveCompanyRequestType();
        new CreditsafeWsdl.CreditsafeBalanceSheet();
        new CreditsafeWsdl.CreditsafeCompanyRatiosV2Array();
        new CreditsafeWsdl.CreditsafeBeProtestedBill();
        new CreditsafeWsdl.CreditsafeNlAdditionalInformation();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEMiscellaneousV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationV2();
        new CreditsafeWsdl.logoutResponseType();
        new CreditsafeWsdl.CreditsafePersonDirectorV2();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyInformationV2();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationV2Array();
        new CreditsafeWsdl.CreditsafeCompanyIdentificationV2();
        new CreditsafeWsdl.CreditsafeBeBankruptcyEventArray();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLAdditionalInformationV2();
        new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2Array();
        new CreditsafeWsdl.CreditsafeLtdOtherInformation();
        new CreditsafeWsdl.creditsafeSearchRequestType();
        new CreditsafeWsdl.CreditsafePersonDirectorsV2Array();
        new CreditsafeWsdl.CreditsafeNlPaymentExpectationsSummary();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEAdditionalInformationV2();
        new CreditsafeWsdl.CreditsafeNlCourtData();
        new CreditsafeWsdl.CreditsafePersonPositionV2Array();
        new CreditsafeWsdl.creditsafeSearchResponseType();
        new CreditsafeWsdl.CreditsafeCompanyRatiosV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLPaymentExpectationsSummaryV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationV2Array();
        new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEOwnerV2Array();
        new CreditsafeWsdl.CreditsafeBeNSSODetail();
        new CreditsafeWsdl.CreditsafeLtdCompanySummary();
        new CreditsafeWsdl.CreditsafeCompanyKeyValueV2Array();
        new CreditsafeWsdl.CreditsafeCompanyAdvisorV2Array();
        new CreditsafeWsdl.CreditsafeCompanyShareCapitalStructureV2();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLAdditionalInformationV2Array();
        new CreditsafeWsdl.CreditsafeBeRegisteredContractorArray();
        new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryComparisonV2();
        new CreditsafeWsdl.CreditsafeSearchCriteriaCombinationArray();
        new CreditsafeWsdl.CreditsafeLtdCompanyIdentification();
        new CreditsafeWsdl.CreditsafeCompanySummaryV2();
        new CreditsafeWsdl.CreditsafeLtdFinancialStatementArray();
        new CreditsafeWsdl.CreditsafeAdvisor();
        new CreditsafeWsdl.CreditsafeCompanyPagedResult();
        new CreditsafeWsdl.CreditsafeBeIndustryComparison();
        new CreditsafeWsdl.CreditsafeCompanyActivityV2();
        new CreditsafeWsdl.creditsafeMonitorAddCompanyResponseType();
        new CreditsafeWsdl.CreditsafeNlLettersOfLiability();
        new CreditsafeWsdl.CreditsafeStreetAddressArray();
    }

}