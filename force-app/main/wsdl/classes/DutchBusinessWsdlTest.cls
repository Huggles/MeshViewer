/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

@IsTest
private class DutchBusinessWsdlTest {

    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractHistoryRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractHistoryResponseType());
            if (request instanceof DutchBusinessWsdl.loginRequestType)
                response.put('response_x', new DutchBusinessWsdl.loginResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUBOStartInvestigationRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUBOStartInvestigationResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetLegalEntityRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetLegalEntityResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataV3RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataV3ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataV2RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataV2ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUBOCostsInvestigationRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUBOCostsInvestigationResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractDocumentRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractDocumentResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV2RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV2ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUBOPickupInvestigationRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUBOPickupInvestigationResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV3RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV3ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUpdateCheckDossierRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUpdateCheckDossierResponseType());
            if (request instanceof DutchBusinessWsdl.logoutRequestType)
                response.put('response_x', new DutchBusinessWsdl.logoutResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetVatNumberRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetVatNumberResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetDossierRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetDossierResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetSBIRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetSBIResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetConcernRelationsDetailsRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetConcernRelationsDetailsResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchNewsByDossierRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchNewsByDossierResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractHistoryChangedRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractHistoryChangedResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetConcernRelationsOverviewRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetConcernRelationsOverviewResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetDossierHistoryRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetDossierHistoryResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetOrganizationTreeRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetOrganizationTreeResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchEstablishmentsRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchEstablishmentsResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchPostcodeRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchPostcodeResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetAnnualFinancialStatementRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetAnnualFinancialStatementResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchDossierNumberRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchDossierNumberResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchParametersRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchParametersResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUBOCheckInvestigationRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUBOCheckInvestigationResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUpdateRemoveDossierRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUpdateRemoveDossierResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUpdateAddDossierRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUpdateAddDossierResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetLeiRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetLeiResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUpdateGetChangedDossiersRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUpdateGetChangedDossiersResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUBOClassifyInvestigationRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUBOClassifyInvestigationResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchSelectionSimpleRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchSelectionSimpleResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetLegalExtractDocumentDataV3RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetLegalExtractDocumentDataV3ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetSBIDescriptionRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetSBIDescriptionResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchSelectionRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchSelectionResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetDossierV2RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetDossierV2ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessSearchParametersV2RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessSearchParametersV2ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetDossierV3RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetDossierV3ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetLegalExtractDocumentDataV2RequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetLegalExtractDocumentDataV2ResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV3ByDossierRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV3ByDossierResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUpdateGetDossiersRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUpdateGetDossiersResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessUpdateGetOverviewRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessUpdateGetOverviewResponseType());
            if (request instanceof DutchBusinessWsdl.dutchBusinessGetPositionsRequestType)
                response.put('response_x', new DutchBusinessWsdl.dutchBusinessGetPositionsResponseType());
        }
    }

    @IsTest
    private static void testCoverMethods1() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new DutchBusinessWsdl.Webservices_nlPort().login(null,null);
        new DutchBusinessWsdl.Webservices_nlPort().logout();
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractHistory(null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractDocumentData(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUBOStartInvestigation(null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetLegalEntity(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractDocumentDataV3(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractDocumentDataV2(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUBOCostsInvestigation(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractDocument(null, null);
    }

    @IsTest
    private static void testCoverMethods2() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractHistoryDocumentDataV2(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUBOPickupInvestigation(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractHistoryDocumentDataV3(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUpdateCheckDossier(null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetVatNumber(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetDossier(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetSBI(null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetConcernRelationsDetails(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearchNewsByDossier(null, null, null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractHistoryChanged(null, null, null);
    }

    @IsTest
    private static void testCoverMethods3() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetConcernRelationsOverview(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetDossierHistory(null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetOrganizationTree(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearchEstablishments(null, null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearchPostcode(null, null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetAnnualFinancialStatement(null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearchDossierNumber(null, null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearchParameters(null, null, null, null, null, null, null, null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUpdateRemoveDossier(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearch(null, null, null, null, null, null, null, null, null, null, null);
    }

    @IsTest
    private static void testCoverMethods4() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUpdateAddDossier(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetLei(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUpdateGetChangedDossiers(null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUBOClassifyInvestigation(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearchSelectionSimple(null, null, null, null, null, null, null, null, null, null, null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetLegalExtractDocumentDataV3(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetSBIDescription(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearchSelection(null, null, null, null, null, null, null, null, null, null, null, null, null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetDossierV2(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessSearchParametersV2(null, null, null, null,null,null,null,null,null,null);
    }

    @IsTest
    private static void testCoverMethods5() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetDossierV3(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetLegalExtractDocumentDataV2(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractHistoryDocumentDataV3ByDossier(null, null,null,null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUpdateGetDossiers(null, null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUpdateGetOverview(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetPositions(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessGetExtractHistoryDocumentData(null);
        new DutchBusinessWsdl.Webservices_nlPort().dutchBusinessUBOCheckInvestigation(null);
    }

    @IsTest
    static void testCoverTypes() {
        new DutchBusinessWsdl.DutchBusinessPositionV2();
        new DutchBusinessWsdl.dutchBusinessGetVatNumberResponseType();
        new DutchBusinessWsdl.dutchBusinessGetDossierV2RequestType();
        new DutchBusinessWsdl.dutchBusinessGetConcernRelationsDetailsResponseType();
        new DutchBusinessWsdl.dutchBusinessUBOCostsInvestigationRequestType();
        new DutchBusinessWsdl.dutchBusinessUBOPickupInvestigationRequestType();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV3ByDossierResponseType();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsOverviewReference();
        new DutchBusinessWsdl.DutchBusinessUBOReceiptItem();
        new DutchBusinessWsdl.DutchBusinessFormattedAddress();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsDetailsGraphNodeArray();
        new DutchBusinessWsdl.DutchBusinessSBISection();
        new DutchBusinessWsdl.dutchBusinessGetVatNumberRequestType();
        new DutchBusinessWsdl.dutchBusinessUBOCostsInvestigationResult();
        new DutchBusinessWsdl.DutchBusinessUBOClassifiedSuspect();
        new DutchBusinessWsdl.dutchBusinessUpdateRemoveDossierResponseType();
        new DutchBusinessWsdl.dutchBusinessSearchParametersResponseType();
        new DutchBusinessWsdl.DutchBusinessLeiSuccessor();
        new DutchBusinessWsdl.DutchBusinessUBOReceipt();
        new DutchBusinessWsdl.DutchBusinessNewsCompanyArray();
        new DutchBusinessWsdl.loginResponseType();
        new DutchBusinessWsdl.DutchBusinessPartnership();
        new DutchBusinessWsdl.DutchBusinessPersonV3();
        new DutchBusinessWsdl.DutchBusinessPersonV2();
        new DutchBusinessWsdl.DutchBusinessSBICollectionArray();
        new DutchBusinessWsdl.dutchBusinessGetLeiRequestType();
        new DutchBusinessWsdl.dutchBusinessGetConcernRelationsDetailsRequestType();
        new DutchBusinessWsdl.dutchBusinessGetLeiResponseType();
        new DutchBusinessWsdl.DutchBusinessExtractDocumentData();
        new DutchBusinessWsdl.ResultInfo();
        new DutchBusinessWsdl.DutchBusinessEstablishmentV3Array();
        new DutchBusinessWsdl.dutchBusinessGetLegalEntityRequestType();
        new DutchBusinessWsdl.dutchBusinessSearchSelectionSimpleResponseType();
        new DutchBusinessWsdl.DutchBusinessEnterprise();
        new DutchBusinessWsdl.DutchBusinessUBOOrganizationNode();
        new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataRequestType();
        new DutchBusinessWsdl.DutchBusinessPositionV3Array();
        new DutchBusinessWsdl.dutchBusinessSearchEstablishmentsResponseType();
        new DutchBusinessWsdl.DutchBusinessUBOClassifiedSuspectArray();
        new DutchBusinessWsdl.dutchBusinessUBOStartInvestigationRequestType();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV3ResponseType();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV3ByDossierRequestType();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV2ResponseType();
        new DutchBusinessWsdl.DutchBusinessSBICode();
        new DutchBusinessWsdl.DutchBusinessGetLeiResult();
        new DutchBusinessWsdl.dutchBusinessUpdateGetChangedDossiersRequestType();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsDetailsGraphLinkArray();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataRequestType();
        new DutchBusinessWsdl.DutchBusinessEstablishmentReference();
        new DutchBusinessWsdl.dutchBusinessGetOrganizationTreeRequestType();
        new DutchBusinessWsdl.DutchBusinessAnnualFinancialStatementSummary();
        new DutchBusinessWsdl.DutchBusinessOrganizationNodeArray();
        new DutchBusinessWsdl.DutchBusinessUBOOrganisation();
        new DutchBusinessWsdl.dutchBusinessGetSBIResponseType();
        new DutchBusinessWsdl.dutchBusinessSearchEstablishmentsRequestType();
        new DutchBusinessWsdl.DutchBusinessPosition();
        new DutchBusinessWsdl.DutchBusinessAnnualFinancialStatement();
        new DutchBusinessWsdl.DutchBusinessDateV2();
        new DutchBusinessWsdl.DutchBusinessDateV3();
        new DutchBusinessWsdl.DutchBusinessUBOOrganisationArray();
        new DutchBusinessWsdl.dutchBusinessGetLegalExtractDocumentDataV2RequestType();
        new DutchBusinessWsdl.dutchBusinessGetLegalExtractDocumentDataV2ResponseType();
        new DutchBusinessWsdl.DutchBusinessLeiLegalForm();
        new DutchBusinessWsdl.DutchBusinessPersonnelInfoV2();
        new DutchBusinessWsdl.dutchBusinessUpdateAddDossierRequestType();
        new DutchBusinessWsdl.DutchBusinessPersonnelInfoV3();
        new DutchBusinessWsdl.dutchBusinessUBOCheckInvestigationResponseType();
        new DutchBusinessWsdl.DutchBusinessOrganizationTree();
        new DutchBusinessWsdl.stringArray();
        new DutchBusinessWsdl.DutchBusinessNewsCompany();
        new DutchBusinessWsdl.dutchBusinessGetDossierV2ResponseType();
        new DutchBusinessWsdl.dutchBusinessSearchPostcodeResponseType();
        new DutchBusinessWsdl.dutchBusinessSearchNewsByDossierResponseType();
        new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataV3RequestType();
        new DutchBusinessWsdl.DutchBusinessOrganizationReferenceV3();
        new DutchBusinessWsdl.DutchBusinessExtractReference();
        new DutchBusinessWsdl.DutchBusinessOrganizationReferenceV2();
        new DutchBusinessWsdl.dutchBusinessSearchDossierNumberRequestType();
        new DutchBusinessWsdl.dutchBusinessGetDossierV3RequestType();
        new DutchBusinessWsdl.dutchBusinessGetConcernRelationsOverviewResponseType();
        new DutchBusinessWsdl.DutchBusinessNewsItem();
        new DutchBusinessWsdl.DutchBusinessNewsItemPagedResult();
        new DutchBusinessWsdl.loginRequestType();
        new DutchBusinessWsdl.DutchBusinessDossierHistory();
        new DutchBusinessWsdl.dutchBusinessSearchNewsByDossierRequestType();
        new DutchBusinessWsdl.DutchBusinessUpdateSubscriptionArray();
        new DutchBusinessWsdl.dutchBusinessGetConcernRelationsOverviewRequestType();
        new DutchBusinessWsdl.HeaderAuthenticateType();
        new DutchBusinessWsdl.DutchBusinessSBICodeInfo();
        new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataV3ResponseType();
        new DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult();
        new DutchBusinessWsdl.DutchBusinessSbiCodeV3Array();
        new DutchBusinessWsdl.dutchBusinessSearchPostcodeRequestType();
        new DutchBusinessWsdl.dutchBusinessGetDossierRequestType();
        new DutchBusinessWsdl.DutchBusinessExtractHistory();
        new DutchBusinessWsdl.logoutRequestType();
        new DutchBusinessWsdl.DutchBusinessPeriod();
        new DutchBusinessWsdl.DutchBusinessUBOReceiptItemArray();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsOverviewResult();
        new DutchBusinessWsdl.dutchBusinessGetDossierHistoryResponseType();
        new DutchBusinessWsdl.dutchBusinessSearchParametersV2ResponseType();
        new DutchBusinessWsdl.DutchBusinessUBORole();
        new DutchBusinessWsdl.dutchBusinessUBOCheckInvestigationRequestType();
        new DutchBusinessWsdl.DutchBusinessUBOClassificationResult();
        new DutchBusinessWsdl.DutchBusinessExtractDocument();
        new DutchBusinessWsdl.DutchBusinessDate();
        new DutchBusinessWsdl.dutchBusinessUpdateRemoveDossierRequestType();
        new DutchBusinessWsdl.DutchBusinessNewsItemArray();
        new DutchBusinessWsdl.dutchBusinessGetSBIDescriptionResponseType();
        new DutchBusinessWsdl.dutchBusinessGetPositionsRequestType();
        new DutchBusinessWsdl.dutchBusinessUBOCostsInvestigationResponseType();
        new DutchBusinessWsdl.dutchBusinessGetLegalEntityResponseType();
        new DutchBusinessWsdl.dutchBusinessSearchParametersV2RequestType();
        new DutchBusinessWsdl.dutchBusinessUpdateAddDossierResponseType();
        new DutchBusinessWsdl.DutchBusinessEstablishmentArray();
        new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataResponseType();
        new DutchBusinessWsdl.DutchBusinessEstablishmentV2Array();
        new DutchBusinessWsdl.DutchBusinessUpdateSubscription();
        new DutchBusinessWsdl.DutchBusinessEstablishmentV3();
        new DutchBusinessWsdl.dutchBusinessUpdateGetOverviewResponseType();
        new DutchBusinessWsdl.DutchBusinessEnterpriseV3();
        new DutchBusinessWsdl.DutchBusinessInsolvencyPublicationArray();
        new DutchBusinessWsdl.DutchBusinessLeiBusinessEntity();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryResponseType();
        new DutchBusinessWsdl.DutchBusinessEnterpriseV2();
        new DutchBusinessWsdl.DutchBusinessEstablishmentV2();
        new DutchBusinessWsdl.DutchBusinessInsolvencyArray();
        new DutchBusinessWsdl.DutchBusinessUBOPayment();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsDetailsGraphNode();
        new DutchBusinessWsdl.DutchBusinessPositionArray();
        new DutchBusinessWsdl.DutchBusinessExtractChangeForecast();
        new DutchBusinessWsdl.DutchBusinessUBOOrganizationNodeArray();
        new DutchBusinessWsdl.dutchBusinessUBOClassifyInvestigationRequestType();
        new DutchBusinessWsdl.DutchBusinessSbiCodeV3();
        new DutchBusinessWsdl.DutchBusinessSbiCodeV2();
        new DutchBusinessWsdl.DutchBusinessEstablishmentReferenceArray();
        new DutchBusinessWsdl.DutchBusinessVatNumber();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataResponseType();
        new DutchBusinessWsdl.HeaderLoginType();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsDetailsGraph();
        new DutchBusinessWsdl.DutchBusinessUBOClassifiedRole();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsDetailsGraphLink();
        new DutchBusinessWsdl.dutchBusinessSearchSelectionResponseType();
        new DutchBusinessWsdl.DutchBusinessOrganizationNode();
        new DutchBusinessWsdl.DutchBusinessChangeSet();
        new DutchBusinessWsdl.dutchBusinessUpdateGetDossiersResponseType();
        new DutchBusinessWsdl.DutchBusinessExtractDataV2();
        new DutchBusinessWsdl.DutchBusinessExtractChangeSet();
        new DutchBusinessWsdl.dutchBusinessUBOClassifyInvestigationResponseType();
        new DutchBusinessWsdl.DutchBusinessPositionV2Array();
        new DutchBusinessWsdl.dutchBusinessSearchParametersRequestType();
        new DutchBusinessWsdl.DutchBusinessUBOPersonArray();
        new DutchBusinessWsdl.DutchBusinessMoneyV3();
        new DutchBusinessWsdl.DutchBusinessMoneyV2();
        new DutchBusinessWsdl.DutchBusinessDossierReference();
        new DutchBusinessWsdl.dutchBusinessUpdateCheckDossierResponseType();
        new DutchBusinessWsdl.DutchBusinessDossierV3();
        new DutchBusinessWsdl.DutchBusinessSbiCodeV2Array();
        new DutchBusinessWsdl.DutchBusinessDossierReferenceArray();
        new DutchBusinessWsdl.DutchBusinessReferenceV2Array();
        new DutchBusinessWsdl.dutchBusinessGetSBIDescriptionRequestType();
        new DutchBusinessWsdl.dutchBusinessGetAnnualFinancialStatementRequestType();
        new DutchBusinessWsdl.DutchBusinessUpdateReferenceArray();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV2RequestType();
        new DutchBusinessWsdl.DutchBusinessLeiRegistrationAuthority();
        new DutchBusinessWsdl.DutchBusinessUpdateSubscriptionPagedResult();
        new DutchBusinessWsdl.DutchBusinessDossierV2();
        new DutchBusinessWsdl.dutchBusinessSearchResponseType();
        new DutchBusinessWsdl.DutchBusinessExtractReferenceArray();
        new DutchBusinessWsdl.DutchBusinessPartnershipArray();
        new DutchBusinessWsdl.DutchBusinessEstablishment();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsOverviewReferenceArray();
        new DutchBusinessWsdl.dutchBusinessSearchRequestType();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryDocumentDataV3RequestType();
        new DutchBusinessWsdl.dutchBusinessSearchSelectionRequestType();
        new DutchBusinessWsdl.dutchBusinessGetOrganizationTreeResponseType();
        new DutchBusinessWsdl.DutchBusinessInsolvency();
        new DutchBusinessWsdl.DutchBusinessUBORoleArray();
        new DutchBusinessWsdl.DutchBusinessExtractDataV3();
        new DutchBusinessWsdl.DutchBusinessUBOInvestigationResult();
        new DutchBusinessWsdl.DutchBusinessUBOExtract();
        new DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryRequestType();
        new DutchBusinessWsdl.DutchBusinessDossier();
        new DutchBusinessWsdl.dutchBusinessGetAnnualFinancialStatementResponseType();
        new DutchBusinessWsdl.dutchBusinessGetLegalExtractDocumentDataV3ResponseType();
        new DutchBusinessWsdl.DutchBusinessAddressV2();
        new DutchBusinessWsdl.DutchBusinessReference();
        new DutchBusinessWsdl.DutchBusinessAddressV3();
        new DutchBusinessWsdl.logoutResponseType();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryChangedResponseType();
        new DutchBusinessWsdl.dutchBusinessGetDossierHistoryRequestType();
        new DutchBusinessWsdl.DutchBusinessSBICodeArray();
        new DutchBusinessWsdl.DutchBusinessUBOInvestigationStatus();
        new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataV2ResponseType();
        new DutchBusinessWsdl.dutchBusinessGetExtractDocumentResponseType();
        new DutchBusinessWsdl.DutchBusinessReferenceV2();
        new DutchBusinessWsdl.DutchBusinessInsolvencyPublication();
        new DutchBusinessWsdl.intArray();
        new DutchBusinessWsdl.dutchBusinessGetExtractDocumentDataV2RequestType();
        new DutchBusinessWsdl.dutchBusinessUBOStartInvestigationResponseType();
        new DutchBusinessWsdl.dutchBusinessGetDossierResponseType();
        new DutchBusinessWsdl.DutchBusinessSBICollection();
        new DutchBusinessWsdl.dutchBusinessUpdateGetChangedDossiersResponseType();
        new DutchBusinessWsdl.DutchBusinessLegalEntityData();
        new DutchBusinessWsdl.dutchBusinessUpdateCheckDossierRequestType();
        new DutchBusinessWsdl.DutchBusinessLeiRegistration();
        new DutchBusinessWsdl.DutchBusinessUpdateReference();
        new DutchBusinessWsdl.DutchBusinessPartnershipV3();
        new DutchBusinessWsdl.DutchBusinessPartnershipV2();
        new DutchBusinessWsdl.dutchBusinessSearchSelectionSimpleRequestType();
        new DutchBusinessWsdl.DutchBusinessUBOPerson();
        new DutchBusinessWsdl.DutchBusinessUBOInvestigationToken();
        new DutchBusinessWsdl.DutchBusinessExtractDocumentDataV2();
        new DutchBusinessWsdl.DutchBusinessExtractDocumentDataV3();
        new DutchBusinessWsdl.DutchBusinessLegalEntityV3();
        new DutchBusinessWsdl.DutchBusinessLegalEntityV2();
        new DutchBusinessWsdl.DutchBusinessPositionV3();
        new DutchBusinessWsdl.dutchBusinessUpdateGetDossiersRequestType();
        new DutchBusinessWsdl.DutchBusinessGetConcernRelationsDetailsResult();
        new DutchBusinessWsdl.DutchBusinessPositions();
        new DutchBusinessWsdl.DutchBusinessLeiAddress();
        new DutchBusinessWsdl.dutchBusinessUBOPickupInvestigationResponseType();
        new DutchBusinessWsdl.DutchBusinessReferencePagedResult();
        new DutchBusinessWsdl.dutchBusinessGetExtractDocumentRequestType();
        new DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult();
        new DutchBusinessWsdl.DutchBusinessLegalEntity();
        new DutchBusinessWsdl.DutchBusinessUBOClassifiedPerson();
        new DutchBusinessWsdl.dutchBusinessSearchDossierNumberResponseType();
        new DutchBusinessWsdl.DutchBusinessReferenceArray();
        new DutchBusinessWsdl.dutchBusinessGetLegalExtractDocumentDataV3RequestType();
        new DutchBusinessWsdl.dutchBusinessGetExtractHistoryChangedRequestType();
        new DutchBusinessWsdl.dutchBusinessUpdateGetOverviewRequestType();
        new DutchBusinessWsdl.dutchBusinessGetSBIRequestType();
        new DutchBusinessWsdl.DutchBusinessStructure();
    }
}