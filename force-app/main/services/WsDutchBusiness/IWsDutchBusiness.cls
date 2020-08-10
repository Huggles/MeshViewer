/**
 * Created by jaapbranderhorst on 2019-06-29.
 * See https://webview.webservices.nl/documentation/files/service_dutchbusiness-php.html#Dutch_Business
 *
 * Uncomment the methods you need and implement them
 */

public interface IWsDutchBusiness {

//    DutchBusinessWsdl.DutchBusinessExtractHistory dutchBusinessGetExtractHistory(String dossier_number,Date period_start_date,Date period_end_date);
//    String login(String username,String password);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentData dutchBusinessGetExtractHistoryDocumentData(String extract_id);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentData dutchBusinessGetExtractDocumentData(String dossier_number,Boolean allow_caching);
//    DutchBusinessWsdl.DutchBusinessUBOInvestigationToken dutchBusinessUBOStartInvestigation(String dossier_number,Date oldest_extract_date,Boolean use_updates);
//    DutchBusinessWsdl.DutchBusinessLegalEntityData dutchBusinessGetLegalEntity(String dossier_number);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentDataV3 dutchBusinessGetExtractDocumentDataV3(String dossier_number,Boolean include_source);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentDataV2 dutchBusinessGetExtractDocumentDataV2(String dossier_number);
//    DutchBusinessWsdl.dutchBusinessUBOCostsInvestigationResult dutchBusinessUBOCostsInvestigation(String token);
//    DutchBusinessWsdl.DutchBusinessExtractDocument dutchBusinessGetExtractDocument(String dossier_number,Boolean allow_caching);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentDataV2 dutchBusinessGetExtractHistoryDocumentDataV2(String extract_id);
//    DutchBusinessWsdl.DutchBusinessUBOInvestigationResult dutchBusinessUBOPickupInvestigation(String token,Boolean include_source);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentDataV3 dutchBusinessGetExtractHistoryDocumentDataV3(String extract_id,Boolean include_source);
//    DutchBusinessWsdl.DutchBusinessUpdateReference dutchBusinessUpdateCheckDossier(String dossier_number,String establishment_number,DutchBusinessWsdl.stringArray update_types);
//    void logout();
    DutchBusinessWsdl.DutchBusinessVatNumber dutchBusinessGetVatNumber(String dossier_number);
//    DutchBusinessWsdl.DutchBusinessDossier dutchBusinessGetDossier(String dossier_number,String establishment_number);
//    DutchBusinessWsdl.DutchBusinessSBICollection dutchBusinessGetSBI(String dossier_number,String establishment_number,String language);
//    DutchBusinessWsdl.DutchBusinessGetConcernRelationsDetailsResult dutchBusinessGetConcernRelationsDetails(String dossier_number,Boolean include_source);
//    DutchBusinessWsdl.DutchBusinessNewsItemPagedResult dutchBusinessSearchNewsByDossier(String dossier_number,DateTime period_start,DateTime period_end,String sort_order,Integer page_x);
    DutchBusinessWsdl.DutchBusinessExtractHistory dutchBusinessGetExtractHistoryChanged(String dossier_number,Date period_start_date,Date period_end_date);
//    DutchBusinessWsdl.DutchBusinessGetConcernRelationsOverviewResult dutchBusinessGetConcernRelationsOverview(String dossier_number);
//    DutchBusinessWsdl.DutchBusinessDossierHistory dutchBusinessGetDossierHistory(String dossier_number,Date period_start_date,Date period_end_date);
//    DutchBusinessWsdl.DutchBusinessOrganizationTree dutchBusinessGetOrganizationTree(String dossier_number);
//    DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult dutchBusinessSearchEstablishments(String dossier_number,String establishment_number,String rsin_number,Integer page_x);
//    DutchBusinessWsdl.DutchBusinessReferencePagedResult dutchBusinessSearchPostcode(String postcode,Integer house_number,String house_number_addition,Integer page_x);
//    DutchBusinessWsdl.DutchBusinessAnnualFinancialStatement dutchBusinessGetAnnualFinancialStatement(String dossier_number,Integer year,String type_x);
//    DutchBusinessWsdl.DutchBusinessReferencePagedResult dutchBusinessSearchDossierNumber(String dossier_number,String establishment_number,String rsin_number,Integer page_x);
//    DutchBusinessWsdl.DutchBusinessReferencePagedResult dutchBusinessSearchParameters(String trade_name,String city,String street,String postcode,Integer house_number,String house_number_addition,String telephone_number,String domain_name,Boolean strict_search,Integer page_x);
//    DutchBusinessWsdl.DutchBusinessUBOInvestigationStatus dutchBusinessUBOCheckInvestigation(String token);
    void dutchBusinessUpdateRemoveDossier(String dossier_number,String establishment_number);
    DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult dutchBusinessSearch(String dossier_number,String trade_name,String city,String street,String postcode,Integer house_number,String house_number_addition,String telephone_number,String domain_name,Boolean strict_search,Integer page_x);
//    void dutchBusinessUpdateAddDossier(String dossier_number,String establishment_number);
//    DutchBusinessWsdl.DutchBusinessGetLeiResult dutchBusinessGetLei(String dossier_number);
    DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult dutchBusinessUpdateGetChangedDossiers(Date changed_since,DutchBusinessWsdl.stringArray update_types,Integer page_x);
//    DutchBusinessWsdl.DutchBusinessUBOClassificationResult dutchBusinessUBOClassifyInvestigation(String token,String scenario);
//    DutchBusinessWsdl.DutchBusinessReferencePagedResult dutchBusinessSearchSelectionSimple(DutchBusinessWsdl.stringArray city,DutchBusinessWsdl.stringArray postcode,DutchBusinessWsdl.stringArray sbi,Boolean primary_sbi_only,DutchBusinessWsdl.intArray legal_form,Integer employees_min,Integer employees_max,String economically_active,String financial_status,String changed_since,String new_since,Integer page_x,DutchBusinessWsdl.stringArray provinces);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentDataV3 dutchBusinessGetLegalExtractDocumentDataV3(String dossier_number,Boolean include_source);
//    DutchBusinessWsdl.DutchBusinessSBICodeInfo dutchBusinessGetSBIDescription(String sbi_code,String language);
    DutchBusinessWsdl.DutchBusinessReferencePagedResult dutchBusinessSearchSelection(DutchBusinessWsdl.stringArray city,DutchBusinessWsdl.stringArray postcode,DutchBusinessWsdl.stringArray sbi,Boolean primary_sbi_only,DutchBusinessWsdl.intArray legal_form,Integer employees_min,Integer employees_max,String economically_active,String financial_status,String changed_since,String new_since,Integer page_x,DutchBusinessWsdl.stringArray provinces,String sbi_match_type);
//    DutchBusinessWsdl.DutchBusinessDossierV2 dutchBusinessGetDossierV2(String dossier_number,String establishment_number);
    DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult dutchBusinessSearchParametersV2(String trade_name,String city,String street,String postcode,Integer house_number,String house_number_addition,String telephone_number,String domain_name,Boolean strict_search,Integer page_x);
    DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessGetDossierV3(String dossier_number,String establishment_number);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentDataV2 dutchBusinessGetLegalExtractDocumentDataV2(String dossier_number);
//    DutchBusinessWsdl.DutchBusinessExtractDocumentDataV3 dutchBusinessGetExtractHistoryDocumentDataV3ByDossier(String dossier_number,Boolean include_source,Date period_start,Date period_end);
//    DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult dutchBusinessUpdateGetDossiers(DutchBusinessWsdl.stringArray update_types,Integer page_x);
//    DutchBusinessWsdl.DutchBusinessUpdateSubscriptionPagedResult dutchBusinessUpdateGetOverview(Integer page_x);
    DutchBusinessWsdl.DutchBusinessPositions dutchBusinessGetPositions(String dossier_number);

}