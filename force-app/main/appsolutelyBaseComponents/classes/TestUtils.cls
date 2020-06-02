/**
 * Created by jaapbranderhorst on 04/02/2018.
 * Class containing utility methods for testing
 */

@IsTest
public inherited sharing class TestUtils {

    private static final Integer SIZE = 900000000;

    private static Map<String, User> usersByProfileName = new Map<String, User>();

    private static Map<String, Id> permissionSetIdsByName = new Map<String, Id>();

    private static User AdminUser {
        get {
            if (AdminUser == null) {
                AdminUser = createUniqueUser('System Administrator');
                System.runAs(getSystemAdminUser()) {
                    insert AdminUser;
                    giveUserPermissionSet('Company_info_user', AdminUser);
                }
            }
            return AdminUser;
        }
        set;
    }

private static User createUserWithPermissionSet(String profileName, String PermissionSetName){
        User u = usersByProfileName.get(profileName);
        if (u == null) {
            u = createUniqueUser(profileName);
            usersByProfileName.put(profileName, u);
            insert u;
            System.runAs(getSystemAdminUserNotInserted()) {
                giveUserPermissionSet('Company_info_user', u);
            }
        }
        return u;
}


    /**
     * Helper method to create a user (not insert it!) with the given profilename.
     *
     * @param profileName
     *
     * @return new User object
     */
    private static User createUser(String profileName) {
        User u = usersByProfileName.get(profileName);
        if (u == null) {
            u = createUniqueUser(profileName);
            usersByProfileName.put(profileName, u);
            System.runAs(getSystemAdminUserNotInserted()) {
                insert u;
                //giveUserPermissionSet('Company_info_user', AdminUser);
            }
        }
        return u;
    }

    private static User createUniqueUser(String profileName) {
        Double d = Math.random() * SIZE;
        Integer randomInt = d.intValue();
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='appsolutely' + randomInt + '@appsolutely.nl');
        return u;
    }

    /**
     * Assigns a permission set with the given name to the user. In Testvisible context so this is not used outside of test context
     *
     * @param user
     * @param permissionSetName
     */
    private static void giveUserPermissionSet(String permissionSetName, User u) {
        Id permissionSetId = permissionSetIdsByName.get(permissionSetName);
        if (permissionSetId == null) {
            PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];
            permissionSetIdsByName.put(permissionSetName, permissionSet.Id);
            permissionSetId = permissionSet.Id;
        }
        PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = permissionSetId);
        insert permissionSetAssignment;
    }

    /**
     * Creates a user with the Standard User profile and gives BDS permission set profile
     *
     * @return
     */
    public static User getCompanyConnectUser() {
        return createUserWithPermissionSet('Standard User', 'Company_info_user');
    }

    public static User getUniqueCompanyConnectUser() {
        return createUniqueUser('Standard User');
    }

    public static User getSystemAdminUser() {
        return createUser('System Administrator');
    }

    public static User getAdminUser() {
        return AdminUser;
    }

    private static User getSystemAdminUserNotInserted() {
        return createUniqueUser('System Administrator');
    }

    public static CreditsafeWsdl.CreditsafeCompanyReportFullV2 createCompanyReportFullV2Mock() {
        CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2 = new CreditsafeWsdl.CreditsafeCompanyReportFullV2();
        reportFullV2.additional_information = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationV2();
        reportFullV2.additional_information.de = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEAdditionalInformationV2();

        reportFullV2.additional_information.de.miscellaneous = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEMiscellaneousV2();
        reportFullV2.additional_information.de.miscellaneous.fax_number = '1';
        reportFullV2.additional_information.de.miscellaneous.negative_rating = '12';
        reportFullV2.additional_information.de.miscellaneous.business_purpose = 'business_purpose';
        reportFullV2.additional_information.de.miscellaneous.complementary_company = 'complementary_company';
        reportFullV2.additional_information.de.miscellaneous.company_type = 'company_type';
        reportFullV2.additional_information.de.miscellaneous.small_office = 'small';
        reportFullV2.additional_information.de.miscellaneous.financials_quality = '2';
        reportFullV2.additional_information.de.miscellaneous.commercial_register_zip = '123';
        reportFullV2.additional_information.de.miscellaneous.commercial_register_city = 'commercial_register_city';
        reportFullV2.additional_information.de.miscellaneous.turnover_range = '1234';
        reportFullV2.additional_information.de.miscellaneous.current_rating = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.additional_information.de.miscellaneous.current_rating.value = '1';
        reportFullV2.additional_information.de.miscellaneous.current_rating.min_value = '0';
        reportFullV2.additional_information.de.miscellaneous.current_rating.max_value = '5';
        reportFullV2.additional_information.de.miscellaneous.previous_rating = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.additional_information.de.miscellaneous.previous_rating.value = '0';
        reportFullV2.additional_information.de.miscellaneous.previous_rating.min_value = '0';
        reportFullV2.additional_information.de.miscellaneous.previous_rating.max_value = '5';
        reportFullV2.additional_information.de.miscellaneous.premise_type = 'premise';

        reportFullV2.additional_information.de.image_accounts = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEImageAccountV2();
        reportFullV2.additional_information.de.image_accounts.start_date = Datetime.newInstance(2020, 02, 13 );
        reportFullV2.additional_information.de.image_accounts.published_date = Datetime.newInstance(2020, 02, 14);
        reportFullV2.additional_information.de.image_accounts.financials_type = 'financials_type';
        reportFullV2.additional_information.de.image_accounts.end_date = Datetime.newInstance(2020, 12, 31);
        reportFullV2.additional_information.de.image_accounts.document_type = 'document_type';
        reportFullV2.additional_information.de.image_accounts.serial_number = '123123';

        reportFullV2.additional_information.de.beneficiary_owners = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEOwnerV2();
        reportFullV2.additional_information.de.beneficiary_owners.share_percent = '10';
        reportFullV2.additional_information.de.beneficiary_owners.name = 'beneficiary_owners_name';
        reportFullV2.additional_information.de.beneficiary_owners.city = 'beneficiary_owners_city';
        reportFullV2.additional_information.de.beneficiary_owners.country = 'beneficiary_owners_country';
        reportFullV2.additional_information.de.beneficiary_owners.postal_code = 'beneficiary_owners_postal_code';

        reportFullV2.additional_information.de.turnover_ranges = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDETurnoverRangeV2();
        reportFullV2.additional_information.de.turnover_ranges.year = 2020;
        reportFullV2.additional_information.de.turnover_ranges.range = '1000-5000';

        reportFullV2.additional_information.de.comments = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2Array();
        reportFullV2.additional_information.de.comments.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2();
            commentV2.sentiment = 'sentiment' + i;
            commentV2.text = 'text' + i;
            reportFullV2.additional_information.de.comments.item.add(commentV2);
        }

        reportFullV2.additional_information.de.historical_events = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2Array();
        reportFullV2.additional_information.de.historical_events.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2();
            historicalEventV2.description = 'description';
            historicalEventV2.date_x = Datetime.newInstance(2020, 1, 1);
            historicalEventV2.current_value = 'current_value';
            historicalEventV2.previous_value = 'previous_value';
            reportFullV2.additional_information.de.historical_events.item.add(historicalEventV2);
        }

        reportFullV2.additional_information.nl = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLAdditionalInformationV2();
        reportFullV2.additional_information.nl.payment_expectations_summary = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLPaymentExpectationsSummaryV2();
        reportFullV2.additional_information.nl.payment_expectations_summary.day_sales_outstanding = 20;
        reportFullV2.additional_information.nl.payment_expectations_summary.payment_expectation_days = 10;
        reportFullV2.additional_information.nl.payment_expectations_summary.industry_average_day_sales_outstanding = 21;
        reportFullV2.additional_information.nl.payment_expectations_summary.industry_average_payment_expectation_days = 25;
        reportFullV2.additional_information.nl.payment_expectations_summary.suspension_of_payments_mora = 'mora';

        reportFullV2.additional_information.nl.miscellaneous = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLMiscellaneousV2();
        reportFullV2.additional_information.nl.miscellaneous.negative_rating = 0;
        reportFullV2.additional_information.nl.miscellaneous.branch_number = '10';
        reportFullV2.additional_information.nl.miscellaneous.rsin_number = '11';
        reportFullV2.additional_information.nl.miscellaneous.importer = '12';
        reportFullV2.additional_information.nl.miscellaneous.exporter = '13';
        reportFullV2.additional_information.nl.miscellaneous.date_of_cessation_trading = Datetime.newInstance(2020, 1, 2);
        reportFullV2.additional_information.nl.miscellaneous.date_of_legal_form = Datetime.newInstance(2020, 2, 2);

        reportFullV2.additional_information.nl.industy_comparison = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryComparisonV2();
        reportFullV2.additional_information.nl.industy_comparison.industry_average_credit_rating = 2;
        reportFullV2.additional_information.nl.industy_comparison.industry_average_credit_limit = 5;

        reportFullV2.additional_information.nl.industry_quartile_analysis = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisV2();
        reportFullV2.additional_information.nl.industry_quartile_analysis.payment_expectation_days = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisDayV2();
        reportFullV2.additional_information.nl.industry_quartile_analysis.payment_expectation_days.upper = 10;
        reportFullV2.additional_information.nl.industry_quartile_analysis.payment_expectation_days.median = 5;
        reportFullV2.additional_information.nl.industry_quartile_analysis.payment_expectation_days.lower = 0;
        reportFullV2.additional_information.nl.industry_quartile_analysis.day_sales_outstanding = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisDayV2();
        reportFullV2.additional_information.nl.industry_quartile_analysis.day_sales_outstanding.upper = 10;
        reportFullV2.additional_information.nl.industry_quartile_analysis.day_sales_outstanding.median = 5;
        reportFullV2.additional_information.nl.industry_quartile_analysis.day_sales_outstanding.lower = 0;

        reportFullV2.additional_information.nl.comments = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2Array();
        reportFullV2.additional_information.nl.comments.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2();
            commentV2.sentiment = 'sentiment' + i;
            commentV2.text = 'text' + i;
            reportFullV2.additional_information.nl.comments.item.add(commentV2);
        }

        reportFullV2.additional_information.nl.historical_events = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2Array();
        reportFullV2.additional_information.nl.historical_events.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2();
            historicalEventV2.description = 'description';
            historicalEventV2.date_x = Datetime.newInstance(2020, 1, 1);
            historicalEventV2.current_value = 'current_value';
            historicalEventV2.previous_value = 'previous_value';
            reportFullV2.additional_information.nl.historical_events.item.add(historicalEventV2);
        }

        reportFullV2.additional_information.nl.financial_items = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2Array();
        reportFullV2.additional_information.nl.financial_items.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2 financialItemV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2();
            financialItemV2.consolidated_subsidiaries = 'consolidated_subsidiaries' + i;
            financialItemV2.judgement = 'judgement' + i;
            financialItemV2.date_year_end = Datetime.newInstance(2020, 5, 5);
            reportFullV2.additional_information.nl.financial_items.item.add(financialItemV2);
        }

        reportFullV2.additional_information.nl.kvk_filings = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2Array();
        reportFullV2.additional_information.nl.kvk_filings.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2 kvkFilingV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2();
            kvkFilingV2.date_x = Datetime.newInstance(2020, 1, 11);
            kvkFilingV2.event = 'event';
            reportFullV2.additional_information.nl.kvk_filings.item.add(kvkFilingV2);
        }

        reportFullV2.additional_information.nl.letters_of_liablility_information403 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2Array();
        reportFullV2.additional_information.nl.letters_of_liablility_information403.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2 liabilityInformation403V2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2();
            liabilityInformation403V2.financial_year = 2020;
            liabilityInformation403V2.date_submitted = Datetime.newInstance(2020, 1, 1);
            liabilityInformation403V2.company_number = '12' + i;
            liabilityInformation403V2.company_name = 'company_name' + i;
            liabilityInformation403V2.letter_of_liability1_removal_submitted_parent2 = Datetime.newInstance(2020, 1, 2);
            liabilityInformation403V2.letter_of_liability1_removal_submitted = Datetime.newInstance(2020, 1, 3);
            liabilityInformation403V2.letter_of_liability1_submitted_date_parent2 = Datetime.newInstance(2020, 1, 4);
            liabilityInformation403V2.letter_of_liability1_submitted_date = Datetime.newInstance(2020, 1, 5);
            liabilityInformation403V2.letter_of_liability1_start_date_parent2 = Datetime.newInstance(2020, 1, 6);
            liabilityInformation403V2.letter_of_liability1_start_date = Datetime.newInstance(2020, 1, 7);
            liabilityInformation403V2.letter_of_liability1_removal_date = Datetime.newInstance(2020, 1, 8);
            liabilityInformation403V2.letter_of_liability1_removal_date_parent2 = Datetime.newInstance(2020, 1, 9);
            liabilityInformation403V2.letter_of_liability2_removal_date = Datetime.newInstance(2020, 1, 10);
            liabilityInformation403V2.letter_of_liability2_removal_date_parent2 = Datetime.newInstance(2020, 1, 11);
            liabilityInformation403V2.letter_of_liability2_removal_submitted_parent2 = Datetime.newInstance(2020, 1, 12);
            liabilityInformation403V2.letter_of_liability2_start_date = Datetime.newInstance(2020, 1, 13);
            liabilityInformation403V2.letter_of_liability2_start_date_parent2 = Datetime.newInstance(2020, 1, 14);
            liabilityInformation403V2.letter_of_liability2_submitted_date_parent2 = Datetime.newInstance(2020, 1, 15);
            liabilityInformation403V2.letter_of_liability2_removal_submitted = Datetime.newInstance(2020, 1, 16);
            liabilityInformation403V2.letter_of_liability2_submitted_date = Datetime.newInstance(2020, 1, 17);
            reportFullV2.additional_information.nl.letters_of_liablility_information403.item.add(liabilityInformation403V2);
        }

        reportFullV2.additional_information.generic = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2Array();
        reportFullV2.additional_information.generic.item = new List<CreditsafeWsdl.CreditsafeCompanyKeyValueV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2();
            keyValueV2.value = 'value'+ i;
            keyValueV2.key = 'key' + i;
            reportFullV2.additional_information.generic.item.add(keyValueV2);
        }

        reportFullV2.company_identification = new CreditsafeWsdl.CreditsafeCompanyIdentificationV2();
        reportFullV2.company_identification.basic_information = new CreditsafeWsdl.CreditsafeCompanyBasicInformationV2();
        reportFullV2.company_identification.basic_information.country = 'country';
        reportFullV2.company_identification.basic_information.business_name = 'business_name';
        reportFullV2.company_identification.basic_information.company_registration_number = '111';
        reportFullV2.company_identification.basic_information.dateof_company_registration = Datetime.newInstance(2010, 1,1);
        reportFullV2.company_identification.basic_information.vat_registration_number = '1212';
        reportFullV2.company_identification.basic_information.registered_company_name = 'registered_company_name';
        reportFullV2.company_identification.basic_information.dateof_starting_operations = Datetime.newInstance(2010, 1,1);
        reportFullV2.company_identification.basic_information.company_status = new CreditsafeWsdl.CreditsafeCompanyStatusV2();
        reportFullV2.company_identification.basic_information.company_status.description = 'company_status.description';
        reportFullV2.company_identification.basic_information.company_status.status = 'company_status.status';
        reportFullV2.company_identification.basic_information.principal_activity = new CreditsafeWsdl.CreditsafeDescriptionV2();
        reportFullV2.company_identification.basic_information.principal_activity.description = 'principal_activity.description';
        reportFullV2.company_identification.basic_information.principal_activity.value = 'principal_activity.value';
        reportFullV2.company_identification.basic_information.principal_activity.code = 'principal_activity.code';
        reportFullV2.company_identification.basic_information.contact_address = new CreditsafeWsdl.CreditsafeAddressV2();
        reportFullV2.company_identification.basic_information.contact_address.country = 'contact_address.country';
        reportFullV2.company_identification.basic_information.contact_address.postal_code = 'contact_address.postal_code';
        reportFullV2.company_identification.basic_information.contact_address.city = 'contact_address.city';
        reportFullV2.company_identification.basic_information.contact_address.street = 'contact_address.street';
        reportFullV2.company_identification.basic_information.contact_address.telephone = '121212121212';
        reportFullV2.company_identification.basic_information.contact_address.full_address = 'contact_address.full_address';
        reportFullV2.company_identification.basic_information.contact_address.house_number = '123';
        reportFullV2.company_identification.basic_information.legal_form = new  CreditsafeWsdl.CreditsafeDescriptionV2();
        reportFullV2.company_identification.basic_information.legal_form.code = 'legal_form.code';
        reportFullV2.company_identification.basic_information.legal_form.value = 'legal_form.value';
        reportFullV2.company_identification.basic_information.legal_form.description = 'legal_form.description';

        reportFullV2.company_identification.activity_classifications = new CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2Array();
        reportFullV2.company_identification.activity_classifications.item = new List<CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2>();
        CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2 activityClassificationV2 = new CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2();
        activityClassificationV2.classification = 'classification';
        activityClassificationV2.activities = new CreditsafeWsdl.CreditsafeCompanyActivityV2Array();
        activityClassificationV2.activities.item = new List<CreditsafeWsdl.CreditsafeCompanyActivityV2>();
        CreditsafeWsdl.CreditsafeCompanyActivityV2 companyActivityV2 = new CreditsafeWsdl.CreditsafeCompanyActivityV2();
        companyActivityV2.classification = 'classification';
        companyActivityV2.activity_description = 'activity_description';
        companyActivityV2.activity_code = 'activity_code';
        activityClassificationV2.activities.item.add(companyActivityV2);
        reportFullV2.company_identification.activity_classifications.item.add(activityClassificationV2);

        reportFullV2.company_summary = new CreditsafeWsdl.CreditsafeCompanySummaryV2();
        reportFullV2.company_summary.company_status = new CreditsafeWsdl.CreditsafeCompanyStatusV2();
        reportFullV2.company_summary.company_status.description = 'company_status.description';
        reportFullV2.company_summary.company_status.status = 'company_status.status';
        reportFullV2.company_summary.credit_rating = new CreditsafeWsdl.CreditsafeCompanyCreditRatingV2();
        reportFullV2.company_summary.credit_rating.credit_limit = '100';
        reportFullV2.company_summary.credit_rating.common_description = 'credit_rating.common_description';
        reportFullV2.company_summary.credit_rating.common_value = 'credit_rating.common_value';
        reportFullV2.company_summary.credit_rating.provider_description = 'credit_rating.provider_description';
        reportFullV2.company_summary.credit_rating.provider_value = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.company_summary.credit_rating.provider_value.value = '10';
        reportFullV2.company_summary.credit_rating.provider_value.max_value = '20';
        reportFullV2.company_summary.credit_rating.provider_value.min_value = '0';
        reportFullV2.company_summary.main_activity = new CreditsafeWsdl.CreditsafeCompanyActivityV2();
        reportFullV2.company_summary.main_activity.activity_code = '1212';
        reportFullV2.company_summary.main_activity.activity_description = 'activity_description';
        reportFullV2.company_summary.main_activity.classification = 'classification';
        reportFullV2.company_summary.country = 'country';
        reportFullV2.company_summary.company_registration_number = '202020';
        reportFullV2.company_summary.latest_turnover_figure = 2;
        reportFullV2.company_summary.latest_shareholders_equity_figure = 3;
        reportFullV2.company_summary.number_x = '9';
        reportFullV2.company_summary.business_name = 'business_name';

        reportFullV2.contact_information = new CreditsafeWsdl.CreditsafeCompanyContactInformationV2();
        reportFullV2.contact_information.main_address = new CreditsafeWsdl.CreditsafeAddressV2();
        reportFullV2.contact_information.main_address.country = 'country';
        reportFullV2.contact_information.main_address.house_number = '1';
        reportFullV2.contact_information.main_address.full_address = 'full_address';
        reportFullV2.contact_information.main_address.telephone = '987654321';
        reportFullV2.contact_information.main_address.street = 'street';
        reportFullV2.contact_information.main_address.city = 'city';
        reportFullV2.contact_information.main_address.postal_code = '1212';
        reportFullV2.contact_information.other_addresses = new CreditsafeWsdl.CreditsafeAddressV2Array();
        reportFullV2.contact_information.other_addresses.item = new List<CreditsafeWsdl.CreditsafeAddressV2>();
        CreditsafeWsdl.CreditsafeAddressV2 addressV2 = new CreditsafeWsdl.CreditsafeAddressV2();
        addressV2.country = 'country';
        addressV2.house_number = '1';
        addressV2.full_address = 'full_address';
        addressV2.telephone = '987654321';
        addressV2.street = 'street';
        addressV2.city = 'city';
        addressV2.postal_code = '1212';
        reportFullV2.contact_information.other_addresses.item.add(addressV2);

        reportFullV2.credit_score = new CreditsafeWsdl.CreditsafeCompanyCreditScoreV2();
        reportFullV2.credit_score.current_credit_rating = new CreditsafeWsdl.CreditsafeCompanyCreditRatingV2();
        reportFullV2.credit_score.current_credit_rating.credit_limit = '1000';
        reportFullV2.credit_score.current_credit_rating.common_description = 'current_credit_rating.common_description';
        reportFullV2.credit_score.current_credit_rating.common_value = 'current_credit_rating.common_value';
        reportFullV2.credit_score.current_credit_rating.provider_description = 'current_credit_rating.provider_description';
        reportFullV2.credit_score.current_credit_rating.provider_value = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.credit_score.current_credit_rating.provider_value.value = '100';
        reportFullV2.credit_score.current_credit_rating.provider_value.max_value = '200';
        reportFullV2.credit_score.current_credit_rating.provider_value.min_value = '0';
        reportFullV2.credit_score.previous_credit_rating = new CreditsafeWsdl.CreditsafeCompanyCreditRatingV2();
        reportFullV2.credit_score.previous_credit_rating.credit_limit = '1000';
        reportFullV2.credit_score.previous_credit_rating.common_description = 'previous_credit_rating.common_description';
        reportFullV2.credit_score.previous_credit_rating.common_value = 'previous_credit_rating.common_value';
        reportFullV2.credit_score.previous_credit_rating.provider_description = 'previous_credit_rating.provider_description';
        reportFullV2.credit_score.previous_credit_rating.provider_value = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.credit_score.previous_credit_rating.provider_value.value = '101';
        reportFullV2.credit_score.previous_credit_rating.provider_value.max_value = '201';
        reportFullV2.credit_score.previous_credit_rating.provider_value.min_value = '0';

        reportFullV2.directors = new CreditsafeWsdl.CreditsafePersonDirectorsV2();
        reportFullV2.directors.current_directors = new CreditsafeWsdl.CreditsafePersonDirectorV2Array();
        reportFullV2.directors.current_directors.item = new List<CreditsafeWsdl.CreditsafePersonDirectorV2>();
        CreditsafeWsdl.CreditsafePersonDirectorV2 currentDirectorV2 = new CreditsafeWsdl.CreditsafePersonDirectorV2();
        currentDirectorV2.name = 'cr name';
        currentDirectorV2.id = 'cr id';
        currentDirectorV2.gender = 'cr gender';
        currentDirectorV2.date_of_birth = Datetime.newInstance(1970, 2, 1);
        currentDirectorV2.director_type = 'ceo';
        currentDirectorV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        currentDirectorV2.address.country = 'cr country';
        currentDirectorV2.address.house_number = '1';
        currentDirectorV2.address.full_address = 'cr full_address';
        currentDirectorV2.address.telephone = '987654321';
        currentDirectorV2.address.street = 'cr street';
        currentDirectorV2.address.city = 'cr city';
        currentDirectorV2.address.postal_code = '1212';
        currentDirectorV2.positions = new CreditsafeWsdl.CreditsafePersonPositionV2Array();
        currentDirectorV2.positions.item = new List<CreditsafeWsdl.CreditsafePersonPositionV2>();
        CreditsafeWsdl.CreditsafePersonPositionV2 positionV2 = new CreditsafeWsdl.CreditsafePersonPositionV2();
        positionV2.name = 'current dir';
        positionV2.date_appointed = Datetime.newInstance(2001, 1,1);
        currentDirectorV2.positions.item.add(positionV2);
        reportFullV2.directors.current_directors.item.add(currentDirectorV2);

        reportFullV2.directors.previous_directors = new CreditsafeWsdl.CreditsafePersonPreviousDirectorV2Array();
        reportFullV2.directors.previous_directors.item = new List<CreditsafeWsdl.CreditsafePersonPreviousDirectorV2>();
        CreditsafeWsdl.CreditsafePersonPreviousDirectorV2 previousDirectorV2 = new CreditsafeWsdl.CreditsafePersonPreviousDirectorV2();
        previousDirectorV2.name = 'pr name';
        previousDirectorV2.id = 'pr id';
        previousDirectorV2.gender = 'pr gender';
        previousDirectorV2.date_of_birth = Datetime.newInstance(1970, 2, 1);
        previousDirectorV2.director_type = 'cto';
        previousDirectorV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        previousDirectorV2.address.country = 'pr country';
        previousDirectorV2.address.house_number = '1';
        previousDirectorV2.address.full_address = 'pr full_address';
        previousDirectorV2.address.telephone = '987654321';
        previousDirectorV2.address.street = 'pr street';
        previousDirectorV2.address.city = 'pr city';
        previousDirectorV2.address.postal_code = '1212';
        previousDirectorV2.positions = new CreditsafeWsdl.CreditsafePersonPositionV2Array();
        previousDirectorV2.positions.item = new List<CreditsafeWsdl.CreditsafePersonPositionV2>();
        CreditsafeWsdl.CreditsafePersonPositionV2 positionV21 = new CreditsafeWsdl.CreditsafePersonPositionV2();
        positionV21.name = 'prev dir';
        positionV21.date_appointed = Datetime.newInstance(2001, 1,1);
        previousDirectorV2.positions.item.add(positionV21);
        reportFullV2.directors.previous_directors.item.add(previousDirectorV2);

        reportFullV2.financial_statements = new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2Array();
        reportFullV2.financial_statements.item = new List<CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2>();
        CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 financialStatementV2 = new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2();
        financialStatementV2.type_x = 'fin';
        financialStatementV2.year_end_date = Datetime.newInstance(2002, 12, 9);
        financialStatementV2.ratios = new CreditsafeWsdl.CreditsafeCompanyRatiosV2();
        financialStatementV2.ratios.creditor_days = 1;
        financialStatementV2.ratios.current_debt_ratio = 2;
        financialStatementV2.ratios.current_ratio = 3;
        financialStatementV2.ratios.debtor_days = 4;
        financialStatementV2.ratios.equity_in_percentage = 5;
        financialStatementV2.ratios.gearing = 6;
        financialStatementV2.ratios.liquidity_ratio_or_acid_test = 7;
        financialStatementV2.ratios.pre_tax_profit_margin = 8;
        financialStatementV2.ratios.return_on_capital_employed = 9;
        financialStatementV2.ratios.return_on_net_assets_employed = 10;
        financialStatementV2.ratios.return_on_total_assets_employed = 11;
        financialStatementV2.ratios.sales_or_net_working_capital = 12;
        financialStatementV2.ratios.stock_turnover_ratio = 13;
        financialStatementV2.ratios.total_debt_ratio = 15;
        financialStatementV2.profit_and_loss = new CreditsafeWsdl.CreditsafeCompanyProfitAndLossV2();
        financialStatementV2.profit_and_loss.depreciation = 1;
        financialStatementV2.profit_and_loss.dividends = 2;
        financialStatementV2.profit_and_loss.financial_expenses = 3;
        financialStatementV2.profit_and_loss.financial_income = 4;
        financialStatementV2.profit_and_loss.operating_costs = 5;
        financialStatementV2.profit_and_loss.operating_profit = 6;
        financialStatementV2.profit_and_loss.other_appropriations = 7;
        financialStatementV2.profit_and_loss.pension_costs = 8;
        financialStatementV2.profit_and_loss.profit_after_tax = 9;
        financialStatementV2.profit_and_loss.profit_before_tax = 10;
        financialStatementV2.profit_and_loss.retained_profit = 11;
        financialStatementV2.profit_and_loss.revenue = 12;
        financialStatementV2.profit_and_loss.tax = 13;
        financialStatementV2.profit_and_loss.wages_and_salaries = 14;
        financialStatementV2.balance_sheet = new CreditsafeWsdl.CreditsafeCompanyBalanceSheetV2();
        financialStatementV2.balance_sheet.bank_liabilities = 1;
        financialStatementV2.balance_sheet.bank_liabilities_due_after1year = 2;
        financialStatementV2.balance_sheet.called_up_share_capital = 3;
        financialStatementV2.balance_sheet.cash = 4;
        financialStatementV2.balance_sheet.consolidated_accounts = 5;
        financialStatementV2.balance_sheet.finished_goods = 6;
        financialStatementV2.balance_sheet.goodwill = 7;
        financialStatementV2.balance_sheet.group_payables = 8;
        financialStatementV2.balance_sheet.group_payables_due_after1year = 9;
        financialStatementV2.balance_sheet.group_receivables = 10;
        financialStatementV2.balance_sheet.investments = 11;
        financialStatementV2.balance_sheet.land_and_buildings = 12;
        financialStatementV2.balance_sheet.loans_to_group = 13;
        financialStatementV2.balance_sheet.miscellaneous_fixed_assets = 14;
        financialStatementV2.balance_sheet.miscellaneous_liabilities = 15;
        financialStatementV2.balance_sheet.miscellaneous_liabilities_due_after1_year = 16;
        financialStatementV2.balance_sheet.miscellaneous_receivables = 17;
        financialStatementV2.balance_sheet.other_current_assets = 18;
        financialStatementV2.balance_sheet.other_intangible_assets = 19;
        financialStatementV2.balance_sheet.other_inventories = 20;
        financialStatementV2.balance_sheet.other_loans = 21;
        financialStatementV2.balance_sheet.other_loans_or_finance = 22;
        financialStatementV2.balance_sheet.other_loans_or_finance_due_after1_year = 23;
        financialStatementV2.balance_sheet.other_reserves = 24;
        financialStatementV2.balance_sheet.other_tangible_assets = 25;
        financialStatementV2.balance_sheet.plant_and_machinery = 26;
        financialStatementV2.balance_sheet.raw_materials = 27;
        financialStatementV2.balance_sheet.receivables_due_after1year = 28;
        financialStatementV2.balance_sheet.revenue_reserves = 29;
        financialStatementV2.balance_sheet.share_premium = 30;
        financialStatementV2.balance_sheet.total_assets = 31;
        financialStatementV2.balance_sheet.total_current_assets = 32;
        financialStatementV2.balance_sheet.total_current_liabilities = 33;
        financialStatementV2.balance_sheet.total_fixed_assets = 34;
        financialStatementV2.balance_sheet.total_intangible_assets = 35;
        financialStatementV2.balance_sheet.total_inventories = 36;
        financialStatementV2.balance_sheet.total_liabilities = 37;
        financialStatementV2.balance_sheet.total_long_term_liabilities = 38;
        financialStatementV2.balance_sheet.total_other_fixed_assets = 39;
        financialStatementV2.balance_sheet.total_receivables = 40;
        financialStatementV2.balance_sheet.total_shareholders_equity = 41;
        financialStatementV2.balance_sheet.total_tangible_assets = 42;
        financialStatementV2.balance_sheet.trade_payables = 43;
        financialStatementV2.balance_sheet.trade_payables_due_after1year = 44;
        financialStatementV2.balance_sheet.trade_receivables = 45;
        financialStatementV2.balance_sheet.work_in_progress = 46;
        financialStatementV2.other_financials = new CreditsafeWsdl.CreditsafeCompanyOtherFinancialsV2();
        financialStatementV2.other_financials.working_capital = 1;
        financialStatementV2.other_financials.net_worth = 2;
        financialStatementV2.consolidated_accounts = true;
        financialStatementV2.number_of_weeks = 3;
        financialStatementV2.currency_x = '12';
        reportFullV2.financial_statements.item.add(financialStatementV2);

        reportFullV2.group_structure = new CreditsafeWsdl.CreditsafeCompanyGroupStructureV2();
        reportFullV2.group_structure.ultimate_parent = new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        reportFullV2.group_structure.ultimate_parent.address = new CreditsafeWsdl.CreditsafeAddressV2();
        reportFullV2.group_structure.ultimate_parent.address.country = 'up country';
        reportFullV2.group_structure.ultimate_parent.address.house_number = '1';
        reportFullV2.group_structure.ultimate_parent.address.full_address = 'up full_address';
        reportFullV2.group_structure.ultimate_parent.address.telephone = '987654321';
        reportFullV2.group_structure.ultimate_parent.address.street = 'up street';
        reportFullV2.group_structure.ultimate_parent.address.city = 'up city';
        reportFullV2.group_structure.ultimate_parent.address.postal_code = '1212';
        reportFullV2.group_structure.ultimate_parent.creditsafe_number = '12';
        reportFullV2.group_structure.ultimate_parent.date_last_account = Datetime.newInstance(2020,3,23);
        reportFullV2.group_structure.ultimate_parent.date_last_change = Datetime.newInstance(2020,1,23);
        reportFullV2.group_structure.ultimate_parent.trade_names = new CreditsafeWsdl.stringArray();
        reportFullV2.group_structure.ultimate_parent.trade_names.item = new List<String>();
        reportFullV2.group_structure.ultimate_parent.trade_names.item.add('trade names');
        reportFullV2.group_structure.ultimate_parent.vat_numbers = new CreditsafeWsdl.stringArray();
        reportFullV2.group_structure.ultimate_parent.vat_numbers.item = new List<String>();
        reportFullV2.group_structure.ultimate_parent.vat_numbers.item.add('1');
        reportFullV2.group_structure.ultimate_parent.country = 'country';
        reportFullV2.group_structure.ultimate_parent.registration_number = '1';
        reportFullV2.group_structure.ultimate_parent.name = 'name';
        reportFullV2.group_structure.ultimate_parent.id = '12';
        reportFullV2.group_structure.ultimate_parent.type_x = 'parent';
        reportFullV2.group_structure.ultimate_parent.status = 'status';
        reportFullV2.group_structure.ultimate_parent.office_type = 'office';

        reportFullV2.group_structure.immediate_parent = new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        reportFullV2.group_structure.immediate_parent.address = new CreditsafeWsdl.CreditsafeAddressV2();
        reportFullV2.group_structure.immediate_parent.address.country = 'ip country';
        reportFullV2.group_structure.immediate_parent.address.house_number = '1';
        reportFullV2.group_structure.immediate_parent.address.full_address = 'ip full_address';
        reportFullV2.group_structure.immediate_parent.address.telephone = '987654321';
        reportFullV2.group_structure.immediate_parent.address.street = 'ip street';
        reportFullV2.group_structure.immediate_parent.address.city = 'ip city';
        reportFullV2.group_structure.immediate_parent.address.postal_code = '1212';
        reportFullV2.group_structure.immediate_parent.creditsafe_number = '12';
        reportFullV2.group_structure.immediate_parent.date_last_account = Datetime.newInstance(2020,3,23);
        reportFullV2.group_structure.immediate_parent.date_last_change = Datetime.newInstance(2020,1,23);
        reportFullV2.group_structure.immediate_parent.trade_names = new CreditsafeWsdl.stringArray();
        reportFullV2.group_structure.immediate_parent.trade_names.item = new List<String>();
        reportFullV2.group_structure.immediate_parent.trade_names.item.add('trade names');
        reportFullV2.group_structure.immediate_parent.vat_numbers = new CreditsafeWsdl.stringArray();
        reportFullV2.group_structure.immediate_parent.vat_numbers.item = new List<String>();
        reportFullV2.group_structure.immediate_parent.vat_numbers.item.add('1');
        reportFullV2.group_structure.immediate_parent.country = 'country';
        reportFullV2.group_structure.immediate_parent.registration_number = '1';
        reportFullV2.group_structure.immediate_parent.name = 'name';
        reportFullV2.group_structure.immediate_parent.id = '12';
        reportFullV2.group_structure.immediate_parent.type_x = 'parent';
        reportFullV2.group_structure.immediate_parent.status = 'status';
        reportFullV2.group_structure.immediate_parent.office_type = 'office';

        reportFullV2.group_structure.subsidiary_companies = new CreditsafeWsdl.CreditsafeCompanyCompanyV2Array();
        reportFullV2.group_structure.subsidiary_companies.item = new List<CreditsafeWsdl.CreditsafeCompanyCompanyV2>();
        CreditsafeWsdl.CreditsafeCompanyCompanyV2 subsidiaryCompanyV2 = new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        subsidiaryCompanyV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        subsidiaryCompanyV2.address.country = 'sub country';
        subsidiaryCompanyV2.address.house_number = '1';
        subsidiaryCompanyV2.address.full_address = 'sub full_address';
        subsidiaryCompanyV2.address.telephone = '987654321';
        subsidiaryCompanyV2.address.street = 'sub street';
        subsidiaryCompanyV2.address.city = 'sub city';
        subsidiaryCompanyV2.address.postal_code = '1212';
        subsidiaryCompanyV2.creditsafe_number = '12';
        subsidiaryCompanyV2.date_last_account = Datetime.newInstance(2020,3,23);
        subsidiaryCompanyV2.date_last_change = Datetime.newInstance(2020,1,23);
        subsidiaryCompanyV2.trade_names = new CreditsafeWsdl.stringArray();
        subsidiaryCompanyV2.trade_names.item = new List<String>();
        subsidiaryCompanyV2.trade_names.item.add('trade names');
        subsidiaryCompanyV2.vat_numbers = new CreditsafeWsdl.stringArray();
        subsidiaryCompanyV2.vat_numbers.item = new List<String>();
        subsidiaryCompanyV2.vat_numbers.item.add('1');
        subsidiaryCompanyV2.country = 'country';
        subsidiaryCompanyV2.registration_number = '1';
        subsidiaryCompanyV2.name = 'name';
        subsidiaryCompanyV2.id = '12';
        subsidiaryCompanyV2.type_x = 'parent';
        subsidiaryCompanyV2.status = 'status';
        subsidiaryCompanyV2.office_type = 'office';
        reportFullV2.group_structure.subsidiary_companies.item.add(subsidiaryCompanyV2);

        reportFullV2.group_structure.affiliated_companies = new CreditsafeWsdl.CreditsafeCompanyCompanyV2Array();
        reportFullV2.group_structure.affiliated_companies.item = new List<CreditsafeWsdl.CreditsafeCompanyCompanyV2>();
        CreditsafeWsdl.CreditsafeCompanyCompanyV2 affiliatedCompanyV2= new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        affiliatedCompanyV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        affiliatedCompanyV2.address.country = 'sub country';
        affiliatedCompanyV2.address.house_number = '1';
        affiliatedCompanyV2.address.full_address = 'sub full_address';
        affiliatedCompanyV2.address.telephone = '987654321';
        affiliatedCompanyV2.address.street = 'sub street';
        affiliatedCompanyV2.address.city = 'sub city';
        affiliatedCompanyV2.address.postal_code = '1212';
        affiliatedCompanyV2.creditsafe_number = '12';
        affiliatedCompanyV2.date_last_account = Datetime.newInstance(2020,3,23);
        affiliatedCompanyV2.date_last_change = Datetime.newInstance(2020,1,23);
        affiliatedCompanyV2.trade_names = new CreditsafeWsdl.stringArray();
        affiliatedCompanyV2.trade_names.item = new List<String>();
        affiliatedCompanyV2.trade_names.item.add('trade names');
        affiliatedCompanyV2.vat_numbers = new CreditsafeWsdl.stringArray();
        affiliatedCompanyV2.vat_numbers.item = new List<String>();
        affiliatedCompanyV2.vat_numbers.item.add('1');
        affiliatedCompanyV2.country = 'country';
        affiliatedCompanyV2.registration_number = '1';
        affiliatedCompanyV2.name = 'name';
        affiliatedCompanyV2.id = '12';
        affiliatedCompanyV2.type_x = 'parent';
        affiliatedCompanyV2.status = 'status';
        affiliatedCompanyV2.office_type = 'office';
        reportFullV2.group_structure.affiliated_companies.item.add(affiliatedCompanyV2);

        reportFullV2.local_financial_statements = new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2Array();
        reportFullV2.local_financial_statements.item = new List<CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2>();
        CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 localFinancialStatementV2 = new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2();
        localFinancialStatementV2.type_x = 'loc';
        localFinancialStatementV2.year_end_date = Datetime.newInstance(2002, 12, 9);
        localFinancialStatementV2.ratios = new CreditsafeWsdl.CreditsafeCompanyRatiosV2();
        localFinancialStatementV2.ratios.creditor_days = 1;
        localFinancialStatementV2.ratios.current_debt_ratio = 2;
        localFinancialStatementV2.ratios.current_ratio = 3;
        localFinancialStatementV2.ratios.debtor_days = 4;
        localFinancialStatementV2.ratios.equity_in_percentage = 5;
        localFinancialStatementV2.ratios.gearing = 6;
        localFinancialStatementV2.ratios.liquidity_ratio_or_acid_test = 7;
        localFinancialStatementV2.ratios.pre_tax_profit_margin = 8;
        localFinancialStatementV2.ratios.return_on_capital_employed = 9;
        localFinancialStatementV2.ratios.return_on_net_assets_employed = 10;
        localFinancialStatementV2.ratios.return_on_total_assets_employed = 11;
        localFinancialStatementV2.ratios.sales_or_net_working_capital = 12;
        localFinancialStatementV2.ratios.stock_turnover_ratio = 13;
        localFinancialStatementV2.ratios.total_debt_ratio = 15;
        localFinancialStatementV2.profit_and_loss = new CreditsafeWsdl.CreditsafeCompanyProfitAndLossV2();
        localFinancialStatementV2.profit_and_loss.depreciation = 1;
        localFinancialStatementV2.profit_and_loss.dividends = 2;
        localFinancialStatementV2.profit_and_loss.financial_expenses = 3;
        localFinancialStatementV2.profit_and_loss.financial_income = 4;
        localFinancialStatementV2.profit_and_loss.operating_costs = 5;
        localFinancialStatementV2.profit_and_loss.operating_profit = 6;
        localFinancialStatementV2.profit_and_loss.other_appropriations = 7;
        localFinancialStatementV2.profit_and_loss.pension_costs = 8;
        localFinancialStatementV2.profit_and_loss.profit_after_tax = 9;
        localFinancialStatementV2.profit_and_loss.profit_before_tax = 10;
        localFinancialStatementV2.profit_and_loss.retained_profit = 11;
        localFinancialStatementV2.profit_and_loss.revenue = 12;
        localFinancialStatementV2.profit_and_loss.tax = 13;
        localFinancialStatementV2.profit_and_loss.wages_and_salaries = 14;
        localFinancialStatementV2.balance_sheet = new CreditsafeWsdl.CreditsafeCompanyBalanceSheetV2();
        localFinancialStatementV2.balance_sheet.bank_liabilities = 1;
        localFinancialStatementV2.balance_sheet.bank_liabilities_due_after1year = 2;
        localFinancialStatementV2.balance_sheet.called_up_share_capital = 3;
        localFinancialStatementV2.balance_sheet.cash = 4;
        localFinancialStatementV2.balance_sheet.consolidated_accounts = 5;
        localFinancialStatementV2.balance_sheet.finished_goods = 6;
        localFinancialStatementV2.balance_sheet.goodwill = 7;
        localFinancialStatementV2.balance_sheet.group_payables = 8;
        localFinancialStatementV2.balance_sheet.group_payables_due_after1year = 9;
        localFinancialStatementV2.balance_sheet.group_receivables = 10;
        localFinancialStatementV2.balance_sheet.investments = 11;
        localFinancialStatementV2.balance_sheet.land_and_buildings = 12;
        localFinancialStatementV2.balance_sheet.loans_to_group = 13;
        localFinancialStatementV2.balance_sheet.miscellaneous_fixed_assets = 14;
        localFinancialStatementV2.balance_sheet.miscellaneous_liabilities = 15;
        localFinancialStatementV2.balance_sheet.miscellaneous_liabilities_due_after1_year = 16;
        localFinancialStatementV2.balance_sheet.miscellaneous_receivables = 17;
        localFinancialStatementV2.balance_sheet.other_current_assets = 18;
        localFinancialStatementV2.balance_sheet.other_intangible_assets = 19;
        localFinancialStatementV2.balance_sheet.other_inventories = 20;
        localFinancialStatementV2.balance_sheet.other_loans = 21;
        localFinancialStatementV2.balance_sheet.other_loans_or_finance = 22;
        localFinancialStatementV2.balance_sheet.other_loans_or_finance_due_after1_year = 23;
        localFinancialStatementV2.balance_sheet.other_reserves = 24;
        localFinancialStatementV2.balance_sheet.other_tangible_assets = 25;
        localFinancialStatementV2.balance_sheet.plant_and_machinery = 26;
        localFinancialStatementV2.balance_sheet.raw_materials = 27;
        localFinancialStatementV2.balance_sheet.receivables_due_after1year = 28;
        localFinancialStatementV2.balance_sheet.revenue_reserves = 29;
        localFinancialStatementV2.balance_sheet.share_premium = 30;
        localFinancialStatementV2.balance_sheet.total_assets = 31;
        localFinancialStatementV2.balance_sheet.total_current_assets = 32;
        localFinancialStatementV2.balance_sheet.total_current_liabilities = 33;
        localFinancialStatementV2.balance_sheet.total_fixed_assets = 34;
        localFinancialStatementV2.balance_sheet.total_intangible_assets = 35;
        localFinancialStatementV2.balance_sheet.total_inventories = 36;
        localFinancialStatementV2.balance_sheet.total_liabilities = 37;
        localFinancialStatementV2.balance_sheet.total_long_term_liabilities = 38;
        localFinancialStatementV2.balance_sheet.total_other_fixed_assets = 39;
        localFinancialStatementV2.balance_sheet.total_receivables = 40;
        localFinancialStatementV2.balance_sheet.total_shareholders_equity = 41;
        localFinancialStatementV2.balance_sheet.total_tangible_assets = 42;
        localFinancialStatementV2.balance_sheet.trade_payables = 43;
        localFinancialStatementV2.balance_sheet.trade_payables_due_after1year = 44;
        localFinancialStatementV2.balance_sheet.trade_receivables = 45;
        localFinancialStatementV2.balance_sheet.work_in_progress = 46;
        localFinancialStatementV2.other_financials = new CreditsafeWsdl.CreditsafeCompanyOtherFinancialsV2();
        localFinancialStatementV2.other_financials.working_capital = 1;
        localFinancialStatementV2.other_financials.net_worth = 2;
        localFinancialStatementV2.consolidated_accounts = true;
        localFinancialStatementV2.number_of_weeks = 3;
        localFinancialStatementV2.currency_x = '12';
        reportFullV2.local_financial_statements.item.add(localFinancialStatementV2);

        reportFullV2.negative_information = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationV2();
        reportFullV2.negative_information.nl = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLV2();
        reportFullV2.negative_information.nl.court_items = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2Array();
        reportFullV2.negative_information.nl.court_items.item = new List<CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2>();
        CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2 courtItemV2 = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2();
        courtItemV2.address = 'address';
        courtItemV2.court_action = 'action';
        courtItemV2.date_of_bankruptcy = Datetime.newInstance(2020,1,1);
        reportFullV2.negative_information.nl.court_items.item.add(courtItemV2);

        reportFullV2.negative_information.de = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEV2();
        reportFullV2.negative_information.de.bankruptcy = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEBankruptcyV2();
        reportFullV2.negative_information.de.bankruptcy.has_bankruptcy = 'yes';
        reportFullV2.negative_information.de.insolvency_information = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyInformationV2();
        reportFullV2.negative_information.de.insolvency_information.insolvency_events = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2Array();
        reportFullV2.negative_information.de.insolvency_information.insolvency_events.item = new List<CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2>();
        CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2 negativeInformationDEInsolvencyEventV2 = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2();
        negativeInformationDEInsolvencyEventV2.created_at = Datetime.newInstance(2020, 2,12);
        negativeInformationDEInsolvencyEventV2.reference_number_court = 'court';
        reportFullV2.negative_information.de.insolvency_information.insolvency_events.item.add(negativeInformationDEInsolvencyEventV2);
        reportFullV2.negative_information.de.insolvency_information.dateof_insolvency = 'Today';
        reportFullV2.negative_information.de.insolvency_information.trustee = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDETrusteeV2();
        reportFullV2.negative_information.de.insolvency_information.trustee.name = 'trustee.name';
        reportFullV2.negative_information.de.insolvency_information.trustee.title = 'trustee.title';
        reportFullV2.negative_information.de.insolvency_information.trustee.first_name = 'trustee.first_name';
        reportFullV2.negative_information.de.insolvency_information.trustee.last_name = 'trustee.last_name';
        reportFullV2.negative_information.de.insolvency_information.trustee.code = 'trustee.code';
        reportFullV2.negative_information.de.insolvency_information.trustee.city = 'trustee.city';
        reportFullV2.negative_information.de.insolvency_information.trustee.telephone_number = '12';
        reportFullV2.negative_information.de.insolvency_information.trustee.fax_number = '12';
        reportFullV2.negative_information.de.insolvency_information.trustee.email_address = 'trustee@gmail.com';
        reportFullV2.negative_information.de.director_events = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2Array();
        reportFullV2.negative_information.de.director_events.item = new List<CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2>();
        CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2 directorEventV2 = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2();
        directorEventV2.name = 'name';
        directorEventV2.type_x = 'type';
        directorEventV2.date_x = Datetime.newInstance(2020,1,1);
        directorEventV2.description = 'description';
        directorEventV2.code = 'code';
        reportFullV2.negative_information.de.director_events.item.add(directorEventV2);
        reportFullV2.negative_information.generic = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2Array();
        reportFullV2.negative_information.generic.item = new List<CreditsafeWsdl.CreditsafeCompanyKeyValueV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2();
            keyValueV2.value = 'value'+ i;
            keyValueV2.key = 'key' + i;
            reportFullV2.negative_information.generic.item.add(keyValueV2);
        }

        reportFullV2.order_number = '1212';
        reportFullV2.other_information = new CreditsafeWsdl.CreditsafeCompanyOtherInformationV2();
        reportFullV2.other_information.bankers = new CreditsafeWsdl.CreditsafeCompanyBankerV2Array();
        reportFullV2.other_information.bankers.item = new List<CreditsafeWsdl.CreditsafeCompanyBankerV2>();
        CreditsafeWsdl.CreditsafeCompanyBankerV2 bankerV2 = new CreditsafeWsdl.CreditsafeCompanyBankerV2();
        bankerV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        bankerV2.address.country = 'bank country';
        bankerV2.address.house_number = '1';
        bankerV2.address.full_address = 'bank full_address';
        bankerV2.address.telephone = '987654321';
        bankerV2.address.street = 'bank street';
        bankerV2.address.city = 'bank city';
        bankerV2.address.postal_code = '1212';
        bankerV2.name = 'bank';
        bankerV2.bank_code = '1212';
        reportFullV2.other_information.bankers.item.add(bankerV2);

        reportFullV2.other_information.advisors = new CreditsafeWsdl.CreditsafeCompanyAdvisorV2Array();
        reportFullV2.other_information.advisors.item = new List<CreditsafeWsdl.CreditsafeCompanyAdvisorV2>();
        CreditsafeWsdl.CreditsafeCompanyAdvisorV2 advisorV2 = new CreditsafeWsdl.CreditsafeCompanyAdvisorV2();
        advisorV2.auditor_name = 'auditor_name';
        advisorV2.solicitor_name = 'solicitor_name';
        reportFullV2.other_information.advisors.item.add(advisorV2);

        reportFullV2.other_information.employees_information = new CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2Array();
        reportFullV2.other_information.employees_information.item = new List<CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2>();
        CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2 employeeInformationV2 = new CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2();
        employeeInformationV2.number_of_employees = 21;
        employeeInformationV2.year = 2020;
        reportFullV2.other_information.employees_information.item.add(employeeInformationV2);

        reportFullV2.share_capital_structure = new CreditsafeWsdl.CreditsafeCompanyShareCapitalStructureV2();
        reportFullV2.share_capital_structure.share_holders = new CreditsafeWsdl.CreditsafeCompanyShareHolderV2Array();
        reportFullV2.share_capital_structure.share_holders.item = new List<CreditsafeWsdl.CreditsafeCompanyShareHolderV2>();
        CreditsafeWsdl.CreditsafeCompanyShareHolderV2 shareHolderV2 = new CreditsafeWsdl.CreditsafeCompanyShareHolderV2();
        shareHolderV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        shareHolderV2.address.country = 'shareholder country';
        shareHolderV2.address.house_number = '1';
        shareHolderV2.address.full_address = 'shareholder full_address';
        shareHolderV2.address.telephone = '987654321';
        shareHolderV2.address.street = 'shareholder street';
        shareHolderV2.address.city = 'shareholder city';
        shareHolderV2.address.postal_code = '1212';
        shareHolderV2.name = 'shareholder';
        shareHolderV2.share_percent = 100;
        reportFullV2.share_capital_structure.share_holders.item.add(shareHolderV2);
        reportFullV2.share_capital_structure.nominal_share_capital = 'nominal_share_capital';
        reportFullV2.share_capital_structure.issued_share_capital = 'issued_share_capital';

        reportFullV2.payment_data = new CreditsafeWsdl.CreditsafeCompanyPaymentDataV2();
        reportFullV2.payment_data.generic = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2Array();
        reportFullV2.payment_data.generic.item = new List<CreditsafeWsdl.CreditsafeCompanyKeyValueV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2();
            keyValueV2.value = 'value'+ i;
            keyValueV2.key = 'key' + i;
            reportFullV2.payment_data.generic.item.add(keyValueV2);
        }

        reportFullV2.language = 'lang';
        reportFullV2.company_id = '1212';

        return reportFullV2;
    }
}

