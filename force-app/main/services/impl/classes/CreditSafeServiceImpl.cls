/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public inherited sharing class CreditSafeServiceImpl implements ICreditSafeService {



    //  CreditsafeWsdl.CreditsafeSearchResultV2 creditsafeSearchV2(CreditsafeWsdl.stringArray countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {

    // reuse the searchresultdossierdto??
    public List<SearchForDossiersResultDto> searchForCreditSafeDossiers(List<CreditSafe.Country> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        // check the input
        if (countries == null || countries.isEmpty()) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }
        // no checks needed so commented
        List<SearchForDossiersResultDto> resultValue = new List<SearchForDossiersResultDto>();
        CreditsafeWsdl.stringArray creditSafeCountries = new CreditsafeWsdl.stringArray();
        creditSafeCountries.item = new List<String>();
        for (CreditSafe.Country country : countries) {
            creditSafeCountries.item.add(country.name());
        }

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResult = WsCreditsafe.creditsafeSearchV2(creditSafeCountries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
        for (CreditsafeWsdl.CreditsafeCompanyV2 company : searchResult.companies.item) {
            resultValue.add(new SearchForDossiersResultDto(company));
        }
        return resultValue;
    }

    public CreditSafeCompanyReportDTO getCreditsafeReportFullV2(String company_id, String language, String reason) {
        //check input
        if (String.isEmpty(company_id) || String.isEmpty(language)) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }

        CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2 = WsCreditsafe.creditsafeGetReportFullV2(company_id, language, reason);
        System.debug('============='+ reportFullV2);

        Creditsafe_Company_Report_Full__c companyReportFull = new Creditsafe_Company_Report_Full__c();
        if (reportFullV2.additional_information != null) {

            if (reportFullV2.additional_information.de != null) {
                Creditsafe_Company_Additional_Info_DE__c additionalInfoDE = new Creditsafe_Company_Additional_Info_DE__c();

                CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEAdditionalInformationV2 additionalInformationDEAdditionalInformationV2 = reportFullV2.additional_information.de;
                if (additionalInformationDEAdditionalInformationV2.miscellaneous != null) {
                    additionalInfoDE.Miscellaneous_Turnover_Range__c = additionalInformationDEAdditionalInformationV2.miscellaneous.turnover_range;
                    additionalInfoDE.Commercial_Register_City__c = additionalInformationDEAdditionalInformationV2.miscellaneous.commercial_register_city;
                    additionalInfoDE.Commercial_Register_Zip__c = additionalInformationDEAdditionalInformationV2.miscellaneous.commercial_register_zip;
                    additionalInfoDE.Financials_Quality__c = additionalInformationDEAdditionalInformationV2.miscellaneous.financials_quality;
                    if (additionalInformationDEAdditionalInformationV2.miscellaneous.current_rating != null) {
                        additionalInfoDE.Current_Rating_Max_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.current_rating.max_value;
                        additionalInfoDE.Current_Rating_Min_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.current_rating.min_value;
                        additionalInfoDE.Current_Rating_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.current_rating.value;
                    }
                    if (additionalInformationDEAdditionalInformationV2.miscellaneous.previous_rating != null) {
                        additionalInfoDE.Previous_Rating_Max_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.previous_rating.max_value;
                        additionalInfoDE.Previous_Rating_Min_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.previous_rating.min_value;
                        additionalInfoDE.Previous_Rating_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.previous_rating.value;
                    }
                    additionalInfoDE.Premise_Type__c = additionalInformationDEAdditionalInformationV2.miscellaneous.premise_type;
                    additionalInfoDE.Small_Office__c = additionalInformationDEAdditionalInformationV2.miscellaneous.small_office;
                    additionalInfoDE.Fax_Number__c = getInteger(additionalInformationDEAdditionalInformationV2.miscellaneous.fax_number);
                    additionalInfoDE.Company_Type__c = additionalInformationDEAdditionalInformationV2.miscellaneous.company_type;
                    additionalInfoDE.Negative_Rating__c = additionalInformationDEAdditionalInformationV2.miscellaneous.negative_rating;
                    additionalInfoDE.Complementary_Company__c = additionalInformationDEAdditionalInformationV2.miscellaneous.complementary_company;
                    additionalInfoDE.Business_Purpose__c = additionalInformationDEAdditionalInformationV2.miscellaneous.business_purpose;
                }

                if (additionalInformationDEAdditionalInformationV2.image_accounts != null) {
                    additionalInfoDE.Image_Account_Serial_Number__c = additionalInformationDEAdditionalInformationV2.image_accounts.serial_number;
                    additionalInfoDE.Image_Account_Document_Type__c = additionalInformationDEAdditionalInformationV2.image_accounts.document_type;
                    additionalInfoDE.Image_Account_End_Date__c = getDate(additionalInformationDEAdditionalInformationV2.image_accounts.end_date);
                    additionalInfoDE.Image_Account_Financials_Type__c = additionalInformationDEAdditionalInformationV2.image_accounts.financials_type;
                    additionalInfoDE.Image_Account_Published_Date__c = getDate(additionalInformationDEAdditionalInformationV2.image_accounts.published_date);
                    additionalInfoDE.Image_Account_Start_Date__c = getDate(additionalInformationDEAdditionalInformationV2.image_accounts.start_date);
                }

                if (additionalInformationDEAdditionalInformationV2.beneficiary_owners != null) {
                    additionalInfoDE.Beneficiary_Owners_Name__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.name;
                    additionalInfoDE.Beneficiary_Owners_City__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.city;
                    additionalInfoDE.Beneficiary_Owners_Postal_Code__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.postal_code;
                    additionalInfoDE.Beneficiary_Owners_Country__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.country;
                    additionalInfoDE.Beneficiary_Owners_Share_Percent__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.share_percent;
                }

                if (additionalInformationDEAdditionalInformationV2.turnover_ranges != null) {
                    additionalInfoDE.Turnover_Range_Year__c = additionalInformationDEAdditionalInformationV2.turnover_ranges.year;
                    additionalInfoDE.Turnover_Ranges__c = additionalInformationDEAdditionalInformationV2.turnover_ranges.range;
                }

                if (additionalInformationDEAdditionalInformationV2.comments != null) {
                    List<Creditsafe_Comp_Additional_Info_Comment__c> additionalInfoComments = new List<Creditsafe_Comp_Additional_Info_Comment__c>();
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 : additionalInformationDEAdditionalInformationV2.comments.item) {
                        Creditsafe_Comp_Additional_Info_Comment__c additionalInfoComment = new Creditsafe_Comp_Additional_Info_Comment__c();
                        additionalInfoComment.Text__c = commentV2.text;
                        additionalInfoComment.Sentiment__c = commentV2.sentiment;
                        additionalInfoComment.Creditsafe_Company_Additional_Info_DE__c = additionalInfoDE.Id;
                        additionalInfoComments.add(additionalInfoComment);
                    }
                }

                if (additionalInformationDEAdditionalInformationV2.historical_events != null) {
                    List<Additional_Information_Historical_Event__c> additionalInformationHistoricalEvents = new List<Additional_Information_Historical_Event__c>();
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 : additionalInformationDEAdditionalInformationV2.historical_events.item) {
                        Additional_Information_Historical_Event__c additionalInformationHistoricalEvent = new Additional_Information_Historical_Event__c();
                        additionalInformationHistoricalEvent.Date__c = getDate(historicalEventV2.date_x);
                        additionalInformationHistoricalEvent.Description__c = historicalEventV2.description;
                        additionalInformationHistoricalEvent.Previous_Value__c = historicalEventV2.previous_value;
                        additionalInformationHistoricalEvent.Current_Value__c = historicalEventV2.current_value;
                        additionalInformationHistoricalEvent.Creditsafe_Company_Additional_Info_DE__c = additionalInfoDE.Id;
                        additionalInformationHistoricalEvents.add(additionalInformationHistoricalEvent);
                    }
                }
                companyReportFull.Creditsafe_Company_Additional_Info_DE__c = additionalInfoDE.Id;
            }

            if (reportFullV2.additional_information.nl != null) {
                Creditsafe_Company_Additional_Info_NL__c additionalInfoNL = new Creditsafe_Company_Additional_Info_NL__c();

                CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLAdditionalInformationV2 additionalInformationNLAdditionalInformationV2 = reportFullV2.additional_information.nl;
                if (additionalInformationNLAdditionalInformationV2.payment_expectations_summary != null) {
                    additionalInfoNL.Suspension_Of_Payments_Mora__c = additionalInformationNLAdditionalInformationV2.payment_expectations_summary.suspension_of_payments_mora;
                    additionalInfoNL.Payment_Expectation_Days__c = String.valueOf(additionalInformationNLAdditionalInformationV2.payment_expectations_summary.payment_expectation_days);
                    additionalInfoNL.Day_Sales_Outstanding__c = String.valueOf(additionalInformationNLAdditionalInformationV2.payment_expectations_summary.day_sales_outstanding);
                    additionalInfoNL.Industry_Average_Payment_Expectation_Day__c = String.valueOf(additionalInformationNLAdditionalInformationV2.payment_expectations_summary.industry_average_payment_expectation_days);
                    additionalInfoNL.Industry_Average_Day_Sales_Outstanding__c = String.valueOf(additionalInformationNLAdditionalInformationV2.payment_expectations_summary.industry_average_day_sales_outstanding);
                }

                if (additionalInformationNLAdditionalInformationV2.miscellaneous != null) {
                    additionalInfoNL.Date_Of_Legal_Form__c = getDate(additionalInformationNLAdditionalInformationV2.miscellaneous.date_of_legal_form);
                    additionalInfoNL.Date_Of_Cessation_Trading__c = getDate(additionalInformationNLAdditionalInformationV2.miscellaneous.date_of_cessation_trading);
                    additionalInfoNL.Exporter__c = additionalInformationNLAdditionalInformationV2.miscellaneous.exporter;
                    additionalInfoNL.Importer__c = additionalInformationNLAdditionalInformationV2.miscellaneous.importer;
                    additionalInfoNL.Rsin_Number__c = additionalInformationNLAdditionalInformationV2.miscellaneous.rsin_number;
                    additionalInfoNL.Branch_Number__c = additionalInformationNLAdditionalInformationV2.miscellaneous.branch_number;
                    additionalInfoNL.Negative_Rating__c = String.valueOf(additionalInformationNLAdditionalInformationV2.miscellaneous.negative_rating);
                }

                if (additionalInformationNLAdditionalInformationV2.industy_comparison != null) {
                    additionalInfoNL.Industry_Average_Credit_Limit__c = String.valueOf(additionalInformationNLAdditionalInformationV2.industy_comparison.industry_average_credit_limit);
                    additionalInfoNL.Industry_Average_Credit_Rating__c = String.valueOf(additionalInformationNLAdditionalInformationV2.industy_comparison.industry_average_credit_rating);
                }

                if (additionalInformationNLAdditionalInformationV2.industry_quartile_analysis != null) {
                    if (additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.payment_expectation_days != null) {
                        additionalInfoNL.Payment_Expectation_Days_Lower__c = String.valueOf(additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.payment_expectation_days.lower);
                        additionalInfoNL.Payment_Expectation_Days_Median__c = String.valueOf(additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.payment_expectation_days.median);
                        additionalInfoNL.Payment_Expectation_Days_Upper__c = String.valueOf(additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.payment_expectation_days.upper);
                    }

                    if (additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.day_sales_outstanding != null) {
                        additionalInfoNL.Day_Sales_Outstanding_Lower__c = String.valueOf(additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.day_sales_outstanding.lower);
                        additionalInfoNL.Day_Sales_Outstanding_Median__c = String.valueOf(additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.day_sales_outstanding.median);
                        additionalInfoNL.Day_Sales_Outstanding_Upper__c = String.valueOf(additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.day_sales_outstanding.upper);
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.financial_items != null) {
                    List<Additional_Information_NL_Financial_Item__c> additionalInformationNLFinancialItems = new List<Additional_Information_NL_Financial_Item__c>();
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2 financialItemV2 :additionalInformationNLAdditionalInformationV2.financial_items.item) {
                        Additional_Information_NL_Financial_Item__c additionalInformationNLFinancialItem = new Additional_Information_NL_Financial_Item__c();
                        additionalInformationNLFinancialItem.Date_Year_End__c = getDate(financialItemV2.date_year_end);
                        additionalInformationNLFinancialItem.Judgement__c = financialItemV2.judgement;
                        additionalInformationNLFinancialItem.Consolidated_Subsidiaries__c = financialItemV2.consolidated_subsidiaries;
                        additionalInformationNLFinancialItem.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                        additionalInformationNLFinancialItems.add(additionalInformationNLFinancialItem);
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.kvk_filings != null) {
                    List<Additional_Information_NL_Kvk_Filing__c> additionalInformationNLKvkFilings = new List<Additional_Information_NL_Kvk_Filing__c>();
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2 kvkFilingV2 : additionalInformationNLAdditionalInformationV2.kvk_filings.item) {
                        Additional_Information_NL_Kvk_Filing__c additionalInformationNLKvkFiling = new Additional_Information_NL_Kvk_Filing__c();
                        additionalInformationNLKvkFiling.Date__c = getDate(kvkFilingV2.date_x);
                        additionalInformationNLKvkFiling.Event__c = kvkFilingV2.event;
                        additionalInformationNLKvkFiling.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                        additionalInformationNLKvkFilings.add(additionalInformationNLKvkFiling);
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.letters_of_liablility_information403 != null) {
                    List<Additional_Info_NL_Letter_Of_Liability__c> additionalInfoNLLetterOfLiabilities = new List<Additional_Info_NL_Letter_Of_Liability__c>();
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2 letterOfLiabilityInformation403V2 : additionalInformationNLAdditionalInformationV2.letters_of_liablility_information403.item) {
                        Additional_Info_NL_Letter_Of_Liability__c additionalInfoNLLetterOfLiability = new Additional_Info_NL_Letter_Of_Liability__c();
                        additionalInfoNLLetterOfLiability.Financial_Year__c = String.valueOf(letterOfLiabilityInformation403V2.financial_year);
                        additionalInfoNLLetterOfLiability.Company_Name__c = letterOfLiabilityInformation403V2.company_name;
                        additionalInfoNLLetterOfLiability.Company_Number__c = letterOfLiabilityInformation403V2.company_number;
                        additionalInfoNLLetterOfLiability.Date_Submitted__c = getDate(letterOfLiabilityInformation403V2.date_submitted);
                        additionalInfoNLLetterOfLiability.Liability1_Start_Date__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability1_start_date);
                        additionalInfoNLLetterOfLiability.Liability1_Submitted_Date__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability1_submitted_date);
                        additionalInfoNLLetterOfLiability.Liability1_Removal_Submitted__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability1_removal_submitted);
                        additionalInfoNLLetterOfLiability.Liability1_Removal_Date__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability1_removal_date);
                        additionalInfoNLLetterOfLiability.Liability2_Start_Date__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability2_start_date);
                        additionalInfoNLLetterOfLiability.Liability2_Submitted_Date__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability2_submitted_date);
                        additionalInfoNLLetterOfLiability.Liability2_Removal_Submitted__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability2_removal_submitted);
                        additionalInfoNLLetterOfLiability.Liability2_Removal_Date__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability2_removal_date);
                        additionalInfoNLLetterOfLiability.Liability1_Start_Date_Parent2__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability1_start_date_parent2);
                        additionalInfoNLLetterOfLiability.Liability1_Submitted_Date_Parent2__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability1_submitted_date_parent2);
                        additionalInfoNLLetterOfLiability.Liability1_Removal_Submitted_Parent2__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability1_removal_submitted_parent2);
                        additionalInfoNLLetterOfLiability.Liability1_Removal_Date_Parent2__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability1_removal_date_parent2);
                        additionalInfoNLLetterOfLiability.Liability2_Start_Date_Parent2__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability2_start_date_parent2);
                        additionalInfoNLLetterOfLiability.Liability2_Submitted_Date_Parent2__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability2_submitted_date_parent2);
                        additionalInfoNLLetterOfLiability.Liability2_Removal_Submitted_Parent2__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability2_removal_submitted_parent2);
                        additionalInfoNLLetterOfLiability.Liability2_Removal_Date_Parent2__c = getDate(letterOfLiabilityInformation403V2.letter_of_liability2_removal_date_parent2);
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.comments != null) {
                    List<Creditsafe_Comp_Additional_Info_Comment__c> additionalInfoComments = new List<Creditsafe_Comp_Additional_Info_Comment__c>();
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 : additionalInformationNLAdditionalInformationV2.comments.item) {
                        Creditsafe_Comp_Additional_Info_Comment__c additionalInfoComment = new Creditsafe_Comp_Additional_Info_Comment__c();
                        additionalInfoComment.Text__c = commentV2.text;
                        additionalInfoComment.Sentiment__c = commentV2.sentiment;
                        additionalInfoComment.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                        additionalInfoComments.add(additionalInfoComment);
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.historical_events != null) {
                    List<Additional_Information_Historical_Event__c> additionalInformationHistoricalEvents = new List<Additional_Information_Historical_Event__c>();
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 : additionalInformationNLAdditionalInformationV2.historical_events.item) {
                        Additional_Information_Historical_Event__c additionalInformationHistoricalEvent = new Additional_Information_Historical_Event__c();
                        additionalInformationHistoricalEvent.Date__c = getDate(historicalEventV2.date_x);
                        additionalInformationHistoricalEvent.Description__c = historicalEventV2.description;
                        additionalInformationHistoricalEvent.Previous_Value__c = historicalEventV2.previous_value;
                        additionalInformationHistoricalEvent.Current_Value__c = historicalEventV2.current_value;
                        additionalInformationHistoricalEvent.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                        additionalInformationHistoricalEvents.add(additionalInformationHistoricalEvent);
                    }
                }
                companyReportFull.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
            }

            if (reportFullV2.additional_information.generic != null) {
                List<Creditsafe_Company_Key_Value__c> creditsafeCompanyKeyValues = new List<Creditsafe_Company_Key_Value__c>();
                for (CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 : reportFullV2.additional_information.generic.item) {
                    Creditsafe_Company_Key_Value__c creditsafeCompanyKeyValue = new Creditsafe_Company_Key_Value__c();
                    creditsafeCompanyKeyValue.Key__c = keyValueV2.key;
                    creditsafeCompanyKeyValue.Value__c = keyValueV2.value;
                    creditsafeCompanyKeyValue.Creditsafe_Company_Report_Full__c = companyReportFull.Id;
                }
            }
            //insert order additionalInfoDE, additionalInfoNL, additionalInfoComments, additionalInformationHistoricalEvents,
            // additionalInformationNLFinancialItems, additionalInformationNLKvkFilings, additionalInfoNLLetterOfLiabilities, additionalInfoComments, additionalInformationHistoricalEvents,
            // companyReportFull, creditsafeCompanyKeyValues
        }

        if (reportFullV2.company_identification != null) {
            if (reportFullV2.company_identification.basic_information != null) {
                Creditsafe_Company_Basic_Information__c basicInformation = new Creditsafe_Company_Basic_Information__c();
                
            }

        }

        return new CreditSafeCompanyReportDTO(reportFullV2);

    }

    private Date getDate(Datetime dateTimeObject) {
        return dateTimeObject != null ? Date.newInstance(dateTimeObject.year(), dateTimeObject.month(), dateTimeObject.day()) : null;
    }

    private Integer getInteger(String value) {
        return value != null ? Integer.valueOf(value) : null;
    }

}