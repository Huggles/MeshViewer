/**
 * Created by tejaswinidandi on 09/01/2020.
 */

public with sharing class CreditSafeCompanyReportDTO {

    public CreditsafeWsdl.CreditsafeCompanyAdditionalInformationV2 additional_information;
    public CreditsafeWsdl.CreditsafeCompanyIdentificationV2 company_identification;
    public CreditsafeWsdl.CreditsafeCompanySummaryV2 company_summary;
    public CreditsafeWsdl.CreditsafeCompanyContactInformationV2 contact_information;
    public CreditsafeWsdl.CreditsafeCompanyCreditScoreV2 credit_score;
    public CreditsafeWsdl.CreditsafePersonDirectorsV2 directors;
    public CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2Array financial_statements;
    public CreditsafeWsdl.CreditsafeCompanyGroupStructureV2 group_structure;
    public CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2Array local_financial_statements;
    public CreditsafeWsdl.CreditsafeCompanyNegativeInformationV2 negative_information;
    public String order_number;
    public CreditsafeWsdl.CreditsafeCompanyOtherInformationV2 other_information;
    public CreditsafeWsdl.CreditsafeCompanyShareCapitalStructureV2 share_capital_structure;
    public CreditsafeWsdl.CreditsafeCompanyPaymentDataV2 payment_data;
    public String company_id;
    public String language;

    public CreditSafeCompanyReportDTO(CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2){

    }

}