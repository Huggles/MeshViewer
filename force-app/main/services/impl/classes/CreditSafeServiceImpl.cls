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

    public Creditsafe_Company_Report_Full__c getCreditsafeReportFullV2(String company_id, String language, String reason) {
       //check input
    /*  if (String.isEmpty(company_id) || String.isEmpty(language)) {
           throw new CCInputException(Label.Error_Input_Incorrect);
       }

       CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2 = WsCreditsafe.creditsafeGetReportFullV2(company_id, language, reason);
       fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
       Creditsafe_Company_Report_Full__c companyReportFull = new Creditsafe_Company_Report_Full__c();
       unitOfWork.registerNew(companyReportFull);

       companyReportFull = mapAdditionalInfo(companyReportFull, reportFullV2, unitOfWork);
       companyReportFull = mapCompanyIdentification(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapCompanySummary(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapContactInfo(companyReportFull, reportFullV2, unitOfWork);
//
//        companyReportFull = mapCreditScore(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapDirectors(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapFinancialStatements(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapGroupStructure(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapLocalFinancialStatements(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapNegativeInformation(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapOtherInformation(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapShareCapital(companyReportFull, reportFullV2, unitOfWork);
//        companyReportFull = mapPaymentData(companyReportFull, reportFullV2, unitOfWork);

       companyReportFull.Order_Number__c = reportFullV2.order_number != null &&  reportFullV2.order_number != 'N/A'? Integer.valueOf(reportFullV2.order_number) : null;
       companyReportFull.Company_Id__c = reportFullV2.company_id;
       companyReportFull.Language__c = reportFullV2.language;

       unitOfWork.commitWork();*/

       return null;

   }

 /*  private Creditsafe_Company_Report_Full__c mapPaymentData(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.payment_data != null && reportFullV2.payment_data.generic != null && reportFullV2.payment_data.generic.item != null) {
           for (CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 :reportFullV2.payment_data.generic.item) {
               Creditsafe_Company_Key_Value__c keyValue = new Creditsafe_Company_Key_Value__c();
               keyValue.Key__c = keyValueV2.key;
               keyValue.Value__c = keyValueV2.value;
               unitOfWork.registerNew(keyValue, Creditsafe_Company_Key_Value__c.Creditsafe_Company_Report_Full__c, companyReportFull);
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapShareCapital(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.share_capital_structure != null) {
           companyReportFull.Issued_Share_Capital__c = reportFullV2.share_capital_structure.issued_share_capital;
           companyReportFull.Nominal_Share_Capital__c = reportFullV2.share_capital_structure.nominal_share_capital;
           if (reportFullV2.share_capital_structure.share_holders != null && reportFullV2.share_capital_structure.share_holders.item != null) {
               for (CreditsafeWsdl.CreditsafeCompanyShareHolderV2 shareHolderV2 :reportFullV2.share_capital_structure.share_holders.item) {
                   Creditsafe_Company_Share_Holder__c shareHolder = new Creditsafe_Company_Share_Holder__c();
                   Dossier_Address__c address = mapCreditSafeAddress(shareHolderV2.address, new Dossier_Address__c());
                   shareHolder.Name__c = shareHolderV2.name;
                   shareHolder.Share_Percent__c = String.valueOf(shareHolderV2.share_percent);
                   unitOfWork.registerNew(shareHolder, Creditsafe_Company_Share_Holder__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                   unitOfWork.registerNew(address, Dossier_Address__c.Creditsafe_Company_Share_Holder__c, shareHolder);
               }
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapOtherInformation(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.other_information != null) {
           if (reportFullV2.other_information.bankers != null && reportFullV2.other_information.bankers.item != null) {
               for (CreditsafeWsdl.CreditsafeCompanyBankerV2 bankerV2 :reportFullV2.other_information.bankers.item) {
                   Creditsafe_Company_Banker__c banker = new Creditsafe_Company_Banker__c();
                   Dossier_Address__c address = mapCreditSafeAddress(bankerV2.address, new Dossier_Address__c());
                   banker.Bank_Code__c = bankerV2.bank_code;
                   banker.Name__c = bankerV2.name;
                   unitOfWork.registerNew(banker, Creditsafe_Company_Banker__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                   unitOfWork.registerNew(address, Dossier_Address__c.Creditsafe_Company_Banker__c, banker);
               }
           }
           if (reportFullV2.other_information.advisors != null && reportFullV2.other_information.advisors.item != null) {
               for (CreditsafeWsdl.CreditsafeCompanyAdvisorV2 advisorV2 :reportFullV2.other_information.advisors.item) {
                   Creditsafe_Company_Advisor__c advisor = new Creditsafe_Company_Advisor__c();
                   advisor.Auditor_Name__c = advisorV2.auditor_name;
                   advisor.Solicitor_Name__c = advisorV2.solicitor_name;
                   unitOfWork.registerNew(advisor, Creditsafe_Company_Advisor__c.Creditsafe_Company_Report_Full__c, companyReportFull);
               }
           }
           if (reportFullV2.other_information.employees_information != null && reportFullV2.other_information.employees_information.item != null) {
               for (CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2 employeeInformationV2 :reportFullV2.other_information.employees_information.item) {
                   Creditsafe_Company_Employee_Information__c employeeInformation = new Creditsafe_Company_Employee_Information__c();
                   employeeInformation.Number_Of_Employees__c = employeeInformationV2.number_of_employees;
                   employeeInformation.Year__c = employeeInformationV2.year;
                   unitOfWork.registerNew(employeeInformation, Creditsafe_Company_Employee_Information__c.Creditsafe_Company_Report_Full__c, companyReportFull);
               }
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapNegativeInformation(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.negative_information != null) {
           if (reportFullV2.negative_information.nl != null && reportFullV2.negative_information.nl.court_items != null) {
               for (CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2 negativeInformationNLCourtItemV2 :reportFullV2.negative_information.nl.court_items.item) {
                   Creditsafe_Company_Negative_Info_NL__c negativeInfoNL = new Creditsafe_Company_Negative_Info_NL__c();
                   negativeInfoNL.Address__c = negativeInformationNLCourtItemV2.address;
                   negativeInfoNL.Date_Of_Bankruptcy__c = getDate(negativeInformationNLCourtItemV2.date_of_bankruptcy);
                   negativeInfoNL.Court_Action__c = negativeInformationNLCourtItemV2.court_action;
                   unitOfWork.registerNew(negativeInfoNL, Creditsafe_Company_Negative_Info_NL__c.Creditsafe_Company_Report_Full__c, companyReportFull);
               }
           }
           if (reportFullV2.negative_information.de != null) {
               Creditsafe_Company_Negative_Info_DE__c negativeInfoDE = new Creditsafe_Company_Negative_Info_DE__c();
               if (reportFullV2.negative_information.de.bankruptcy != null) {
                   negativeInfoDE.Has_Bankruptcy__c = reportFullV2.negative_information.de.bankruptcy.has_bankruptcy;
               }
               if (reportFullV2.negative_information.de.insolvency_information != null) {
                   negativeInfoDE.Date_Of_Insolvency__c = reportFullV2.negative_information.de.insolvency_information.dateof_insolvency;
                   if (reportFullV2.negative_information.de.insolvency_information.trustee != null) {
                       negativeInfoDE.Trustee_City__c = reportFullV2.negative_information.de.insolvency_information.trustee.city;
                       negativeInfoDE.Trustee_Code__c = reportFullV2.negative_information.de.insolvency_information.trustee.code;
                       negativeInfoDE.Trustee_Email_Address__c = reportFullV2.negative_information.de.insolvency_information.trustee.email_address;
                       negativeInfoDE.Trustee_Fax_Number__c = reportFullV2.negative_information.de.insolvency_information.trustee.fax_number;
                       negativeInfoDE.Trustee_First_Name__c = reportFullV2.negative_information.de.insolvency_information.trustee.first_name;
                       negativeInfoDE.Trustee_Last_Name__c = reportFullV2.negative_information.de.insolvency_information.trustee.last_name;
                       negativeInfoDE.Trustee_Name__c = reportFullV2.negative_information.de.insolvency_information.trustee.name;
                       negativeInfoDE.Trustee_Telephone_Number__c = reportFullV2.negative_information.de.insolvency_information.trustee.telephone_number;
                       negativeInfoDE.Trustee_Title__c = reportFullV2.negative_information.de.insolvency_information.trustee.title;
                   }
                   if (reportFullV2.negative_information.de.insolvency_information.insolvency_events != null && reportFullV2.negative_information.de.insolvency_information.insolvency_events.item != null) {
                       for (CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2 insolvencyEventV2 : reportFullV2.negative_information.de.insolvency_information.insolvency_events.item) {
                           Negative_Information_DE_Insolvency_Event__c insolvencyEvent = new Negative_Information_DE_Insolvency_Event__c();
                           insolvencyEvent.Reference_Number_Court__c = insolvencyEventV2.reference_number_court;
                           insolvencyEvent.Created_At__c = getDate(insolvencyEventV2.created_at);
                           unitOfWork.registerNew(insolvencyEvent, Negative_Information_DE_Insolvency_Event__c.Creditsafe_Company_Negative_Info_DE__c , negativeInfoDE);
                       }
                   }
               }
               if (reportFullV2.negative_information.de.director_events != null && reportFullV2.negative_information.de.director_events.item != null) {
                   for (CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2 directorEventV2 : reportFullV2.negative_information.de.director_events.item) {
                       Negative_Information_DE_Director_Event__c directorEvent = new Negative_Information_DE_Director_Event__c();
                       directorEvent.Name__c = directorEventV2.name;
                       directorEvent.Type__c = directorEventV2.type_x;
                       directorEvent.Date__c = getDate(directorEventV2.date_x);
                       directorEvent.Description__c = directorEventV2.description;
                       directorEvent.Code__c = directorEventV2.code;
                       unitOfWork.registerNew(directorEvent, Negative_Information_DE_Director_Event__c.Creditsafe_Company_Negative_Info_DE__c , negativeInfoDE);
                   }
               }
               unitOfWork.registerNew(negativeInfoDE, Creditsafe_Company_Negative_Info_DE__c.Creditsafe_Company_Report_Full__c, companyReportFull);
           }
           if (reportFullV2.negative_information.generic != null && reportFullV2.negative_information.generic.item != null) {
               for (CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 :reportFullV2.negative_information.generic.item) {
                   Creditsafe_Company_Key_Value__c keyValue = new Creditsafe_Company_Key_Value__c();
                   keyValue.Key__c = keyValueV2.key;
                   keyValue.Value__c = keyValueV2.value;
                   unitOfWork.registerNew(keyValue, Creditsafe_Company_Key_Value__c.Creditsafe_Company_Report_Full__c, companyReportFull);
               }
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapLocalFinancialStatements(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.local_financial_statements != null && reportFullV2.local_financial_statements.item != null) {
           Id recordTypeId = Schema.SObjectType.Creditsafe_Company_Financial_Statement__c.getRecordTypeInfosByDeveloperName().get('Local_Financial_Statements').getRecordTypeId();
           for (CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 financialStatementV2 :reportFullV2.local_financial_statements.item) {
               Creditsafe_Company_Financial_Statement__c financialStatement = mapFinancialStatement(financialStatementV2, new Creditsafe_Company_Financial_Statement__c(), recordTypeId);
               unitOfWork.registerNew(financialStatement, Creditsafe_Company_Financial_Statement__c.Creditsafe_Company_Report_Full__c, companyReportFull);
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapGroupStructure(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.group_structure != null) {
           if (reportFullV2.group_structure.ultimate_parent != null) {
               Id recordTypeId = Schema.SObjectType.Creditsafe_Company__c.getRecordTypeInfosByDeveloperName().get('Ultimate_Parent').getRecordTypeId();
               Creditsafe_Company__c creditsafeCompany = mapCreditsafeCompany(new Creditsafe_Company__c(), reportFullV2.group_structure.ultimate_parent, recordTypeId);
               unitOfWork.registerNew(creditsafeCompany, Creditsafe_Company__c.Creditsafe_Company_Report_Full__c, companyReportFull);
           }
           if (reportFullV2.group_structure.immediate_parent != null) {
               Id recordTypeId = Schema.SObjectType.Creditsafe_Company__c.getRecordTypeInfosByDeveloperName().get('Immediate_Parent').getRecordTypeId();
               Creditsafe_Company__c creditsafeCompany = mapCreditsafeCompany(new Creditsafe_Company__c(), reportFullV2.group_structure.immediate_parent, recordTypeId);
               unitOfWork.registerNew(creditsafeCompany, Creditsafe_Company__c.Creditsafe_Company_Report_Full__c, companyReportFull);
           }
           if (reportFullV2.group_structure.subsidiary_companies != null && reportFullV2.group_structure.subsidiary_companies.item != null) {
               Id recordTypeId = Schema.SObjectType.Creditsafe_Company__c.getRecordTypeInfosByDeveloperName().get('Subsidiary_Companies').getRecordTypeId();
               for (CreditsafeWsdl.CreditsafeCompanyCompanyV2 creditsafeCompanyV2 :reportFullV2.group_structure.subsidiary_companies.item) {
                   Creditsafe_Company__c creditsafeCompany = mapCreditsafeCompany(new Creditsafe_Company__c(), creditsafeCompanyV2, recordTypeId);
                   unitOfWork.registerNew(creditsafeCompany, Creditsafe_Company__c.Creditsafe_Company_Report_Full__c, companyReportFull);
               }
           }
           if (reportFullV2.group_structure.affiliated_companies != null && reportFullV2.group_structure.affiliated_companies.item != null) {
               Id recordTypeId = Schema.SObjectType.Creditsafe_Company__c.getRecordTypeInfosByDeveloperName().get('Affiliated_Companies').getRecordTypeId();
               for (CreditsafeWsdl.CreditsafeCompanyCompanyV2 creditsafeCompanyV2 :reportFullV2.group_structure.affiliated_companies.item) {
                   Creditsafe_Company__c creditsafeCompany = mapCreditsafeCompany(new Creditsafe_Company__c(), creditsafeCompanyV2, recordTypeId);
                   unitOfWork.registerNew(creditsafeCompany, Creditsafe_Company__c.Creditsafe_Company_Report_Full__c, companyReportFull);
               }
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapFinancialStatements(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.financial_statements != null && reportFullV2.financial_statements.item != null) {
           Id recordTypeId = Schema.SObjectType.Creditsafe_Company_Financial_Statement__c.getRecordTypeInfosByDeveloperName().get('Financial_Statements').getRecordTypeId();
           for (CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 financialStatementV2 :reportFullV2.financial_statements.item) {
               Creditsafe_Company_Financial_Statement__c financialStatement = mapFinancialStatement(financialStatementV2, new Creditsafe_Company_Financial_Statement__c(), recordTypeId);
               unitOfWork.registerNew(financialStatement, Creditsafe_Company_Financial_Statement__c.Creditsafe_Company_Report_Full__c, companyReportFull);
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapContactInfo(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.contact_information != null) {
           if (reportFullV2.contact_information.main_address != null) {
               Dossier_Address__c mainAddress = mapCreditSafeAddress(reportFullV2.contact_information.main_address, new Dossier_Address__c());
               unitOfWork.registerNew(mainAddress, Dossier_Address__c.Creditsafe_Company_Report_Full__c, companyReportFull);
           }
           if (reportFullV2.contact_information.other_addresses != null && reportFullV2.contact_information.other_addresses.item != null) {
               for (CreditsafeWsdl.CreditsafeAddressV2 otherAddressV2 :reportFullV2.contact_information.other_addresses.item) {
                   Dossier_Address__c contactInfoAddress = mapCreditSafeAddress(otherAddressV2, new Dossier_Address__c());
                   unitOfWork.registerNew(contactInfoAddress, Dossier_Address__c.Creditsafe_Company_Report_Full__c, companyReportFull);
               }
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapDirectors(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.directors != null) {
           if (reportFullV2.directors.current_directors != null && reportFullV2.directors.current_directors.item != null) {
               Id currentDirectorRecordId = Schema.SObjectType.Creditsafe_Person_Director__c.getRecordTypeInfosByDeveloperName().get('Current_Director').getRecordTypeId();
               for (CreditsafeWsdl.CreditsafePersonDirectorV2 currentDirectorV2 :reportFullV2.directors.current_directors.item) {
                   Creditsafe_Person_Director__c personDirector = new Creditsafe_Person_Director__c();
                   personDirector.Director_Type__c = currentDirectorV2.director_type;
                   personDirector.Director_Id__c = currentDirectorV2.id;
                   personDirector.Name = currentDirectorV2.name;
                   personDirector.Date_of_Birth__c = getDate(currentDirectorV2.date_of_birth);
                   personDirector.Gender__c = currentDirectorV2.gender;
                   personDirector.RecordTypeId = currentDirectorRecordId;
                   //TODO add position
                   Dossier_Address__c address = mapCreditSafeAddress(currentDirectorV2.address, new Dossier_Address__c());
                   unitOfWork.registerNew(personDirector, Creditsafe_Person_Director__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                   unitOfWork.registerNew(address, Dossier_Address__c.Creditsafe_Person_Director__c, personDirector);
               }
           }

           if (reportFullV2.directors.previous_directors != null && reportFullV2.directors.previous_directors.item != null) {
               Id previousDirectorRecordId = Schema.SObjectType.Creditsafe_Person_Director__c.getRecordTypeInfosByDeveloperName().get('Previous_Director').getRecordTypeId();
               for (CreditsafeWsdl.CreditsafePersonPreviousDirectorV2 previousDirectorV2 :reportFullV2.directors.previous_directors.item) {
                   Creditsafe_Person_Director__c personDirector = new Creditsafe_Person_Director__c();
                   personDirector.Director_Type__c = previousDirectorV2.director_type;
                   personDirector.Director_Id__c = previousDirectorV2.id;
                   personDirector.Name = previousDirectorV2.name;
                   personDirector.Date_of_Birth__c = getDate(previousDirectorV2.date_of_birth);
                   personDirector.Gender__c = previousDirectorV2.gender;
                   personDirector.RecordTypeId = previousDirectorRecordId;
                   Dossier_Address__c address = mapCreditSafeAddress(previousDirectorV2.address, new Dossier_Address__c());
                   unitOfWork.registerNew(personDirector, Creditsafe_Person_Director__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                   unitOfWork.registerNew(address, Dossier_Address__c.Creditsafe_Person_Director__c, personDirector);
               }
           }
           //add these related list to companyReportFull
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapCreditScore(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork){
       if (reportFullV2.credit_score != null) {
           Creditsafe_Company_Credit_Score__c creditScore = new Creditsafe_Company_Credit_Score__c();
           if (reportFullV2.credit_score.current_credit_rating != null) {
               creditScore.Current_CR_Limit__c = reportFullV2.credit_score.current_credit_rating.credit_limit;
               creditScore.Current_CR_Common_Description__c = reportFullV2.credit_score.current_credit_rating.common_description;
               creditScore.Current_CR_Common_Value__c = reportFullV2.credit_score.current_credit_rating.common_value;
               creditScore.Current_CR_Provider_Description__c = reportFullV2.credit_score.current_credit_rating.provider_description;
               if (reportFullV2.credit_score.current_credit_rating.provider_value != null) {
                   creditScore.Current_CR_Provider_Value__c = reportFullV2.credit_score.current_credit_rating.provider_value.value;
                   creditScore.Current_CR_Provider_Value_Max__c = reportFullV2.credit_score.current_credit_rating.provider_value.max_value;
                   creditScore.Current_CR_Provider_Value_Min__c = reportFullV2.credit_score.current_credit_rating.provider_value.min_value;
               }
           }
           if (reportFullV2.credit_score.previous_credit_rating != null) {
               creditScore.Previous_CR_Limit__c = reportFullV2.credit_score.previous_credit_rating.credit_limit;
               creditScore.Previous_CR_Common_Description__c = reportFullV2.credit_score.previous_credit_rating.common_description;
               creditScore.Previous_CR_Common_Value__c = reportFullV2.credit_score.previous_credit_rating.common_value;
               creditScore.Previous_CR_Provider_Description__c = reportFullV2.credit_score.previous_credit_rating.provider_description;
               if (reportFullV2.credit_score.previous_credit_rating.provider_value != null) {
                   creditScore.Previous_CR_Provider_Value__c = reportFullV2.credit_score.previous_credit_rating.provider_value.value;
                   creditScore.Previous_CR_Provider_Value_Max__c = reportFullV2.credit_score.previous_credit_rating.provider_value.max_value;
                   creditScore.Previous_CR_Provider_Value_Min__c = reportFullV2.credit_score.previous_credit_rating.provider_value.min_value;
               }
           }
           //companyReportFull.Creditsafe_Company_Credit_Score__c = creditScore.Id;
           unitOfWork.registerNew(creditScore, Creditsafe_Company_Credit_Score__c.Creditsafe_Company_Report_Full__c, companyReportFull);
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapCompanySummary(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.company_summary != null) {
           Creditsafe_Company_Summary__c companySummary = new Creditsafe_Company_Summary__c();
           if (reportFullV2.company_summary.company_status != null) {
               companySummary.Company_Status__c = reportFullV2.company_summary.company_status.status;
               companySummary.Company_Status_Description__c = reportFullV2.company_summary.company_status.description;
           }
           if (reportFullV2.company_summary.credit_rating != null) {
               companySummary.Credit_Rating_Common_Description__c = reportFullV2.company_summary.credit_rating.common_description;
               companySummary.Credit_Rating_Common_Value__c = reportFullV2.company_summary.credit_rating.common_value;
               companySummary.Credit_Rating_Limit__c = reportFullV2.company_summary.credit_rating.credit_limit;
               companySummary.Credit_Rating_Provider_Description__c = reportFullV2.company_summary.credit_rating.provider_description;
               if (reportFullV2.company_summary.credit_rating.provider_value != null) {
                   companySummary.Credit_Rating_Provider_Value__c = reportFullV2.company_summary.credit_rating.provider_value.value;
                   companySummary.Credit_Rating_Provider_Value_Max__c = reportFullV2.company_summary.credit_rating.provider_value.max_value;
                   companySummary.Credit_Rating_Provider_Value_Min__c = reportFullV2.company_summary.credit_rating.provider_value.min_value;
               }
           }
           if (reportFullV2.company_summary.main_activity != null) {
               companySummary.Main_Activity_Code__c = reportFullV2.company_summary.main_activity.activity_code;
               companySummary.Main_Activity_Classification__c = reportFullV2.company_summary.main_activity.classification;
               companySummary.Main_Activity_Description__c = reportFullV2.company_summary.main_activity.activity_description;
           }
           companySummary.Latest_Shareholders_Equity_Figure__c = String.valueOf(reportFullV2.company_summary.latest_shareholders_equity_figure);
           companySummary.Latest_Turnover_Figure__c = String.valueOf(reportFullV2.company_summary.latest_turnover_figure);
           companySummary.Number__c = reportFullV2.company_summary.number_x;
           companySummary.Company_Registration_Number__c = reportFullV2.company_summary.company_registration_number;
           companySummary.Business_Name__c = reportFullV2.company_summary.business_name;
           companySummary.Country__c = reportFullV2.company_summary.country;
           //companyReportFull.Creditsafe_Company_Summary__c = companySummary.Id;
           unitOfWork.registerNew(companySummary, Creditsafe_Company_Summary__c.Creditsafe_Company_Report_Full__c, companyReportFull);
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapCompanyIdentification(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
       if (reportFullV2.company_identification != null) {
           if (reportFullV2.company_identification.basic_information != null) {
               CreditsafeWsdl.CreditsafeCompanyBasicInformationV2 basicInformationV2 = reportFullV2.company_identification.basic_information;
               Creditsafe_Company_Basic_Information__c basicInformation = new Creditsafe_Company_Basic_Information__c();
               if (basicInformationV2.company_status != null) {
                   basicInformation.Company_Status__c = basicInformationV2.company_status.status;
                   basicInformation.Company_Status_Description__c = basicInformationV2.company_status.description;
               }
               if (basicInformationV2.legal_form != null) {
                   basicInformation.Legal_Form_Code__c = basicInformationV2.legal_form.code;
                   basicInformation.Legal_Form_Description__c = basicInformationV2.legal_form.description;
                   basicInformation.Legal_Form_Value__c = basicInformationV2.legal_form.value;
               }
               if (basicInformationV2.principal_activity != null) {
                   basicInformation.Principal_Activity_Code__c = basicInformationV2.principal_activity.code;
                   basicInformation.Principal_Activity_Description__c = basicInformationV2.principal_activity.description;
                   basicInformation.Principal_Activity_Value__c = basicInformationV2.principal_activity.value;
               }
               basicInformation.Company_Registration_Number__c = basicInformationV2.company_registration_number;
               basicInformation.Business_Name__c = basicInformationV2.business_name;
               basicInformation.Country__c = basicInformationV2.country;
               basicInformation.Dateof_Company_Registration__c = basicInformationV2.dateof_company_registration;
               basicInformation.Dateof_Starting_Operations__c = basicInformationV2.dateof_starting_operations;
               basicInformation.Registered_Company_Name__c = basicInformationV2.registered_company_name;
               basicInformation.VAT_Registration_Number__c = basicInformationV2.vat_registration_number;
               unitOfWork.registerNew(basicInformation, Creditsafe_Company_Basic_Information__c.Creditsafe_Company_Report_Full__c, companyReportFull);

//                if (basicInformationV2.contact_address != null) { //TODO change the lookup
//                    Dossier_Address__c contactAddress = mapCreditSafeAddress(basicInformationV2.contact_address, new Dossier_Address__c());
//                    unitOfWork.registerRelationship(basicInformation, Creditsafe_Company_Basic_Information__c.Contact_Address__c, contactAddress);
//                }
           }
           if (reportFullV2.company_identification.activity_classifications != null && reportFullV2.company_identification.activity_classifications.item != null) {
               for (CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2 activityClassificationV2 : reportFullV2.company_identification.activity_classifications.item) {
                   Creditsafe_Comp_Activity_Classifications__c activityClassification = new Creditsafe_Comp_Activity_Classifications__c();
                   activityClassification.Classification__c = activityClassificationV2.classification;

                   for (CreditsafeWsdl.CreditsafeCompanyActivityV2 companyActivityV2 : activityClassificationV2.activities.item) {
                       Creditsafe_Company_Activity__c companyActivity = new Creditsafe_Company_Activity__c();
                       companyActivity.Classification__c = companyActivityV2.classification;
                       companyActivity.Activity_Code__c = companyActivityV2.activity_code;
                       companyActivity.Activity_Description__c = companyActivityV2.activity_description;
                       //companyActivity.Creditsafe_Comp_Activity_Classification__c = activityClassification.Id;
                       unitOfWork.registerNew(companyActivity, Creditsafe_Company_Activity__c.Creditsafe_Comp_Activity_Classification__c, activityClassification);
                   }
                   //activityClassification.Creditsafe_Company_Report_Full__c = companyReportFull.Id;
                   unitOfWork.registerNew(activityClassification, Creditsafe_Comp_Activity_Classifications__c.Creditsafe_Company_Report_Full__c, companyReportFull);
               }
           }
       }

       return companyReportFull;
   }

   private Creditsafe_Company_Report_Full__c mapAdditionalInfo(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
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

               if (additionalInformationDEAdditionalInformationV2.comments != null && additionalInformationDEAdditionalInformationV2.comments.item != null) {
                   for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 : additionalInformationDEAdditionalInformationV2.comments.item) {
                       Creditsafe_Comp_Additional_Info_Comment__c additionalInfoComment = new Creditsafe_Comp_Additional_Info_Comment__c();
                       additionalInfoComment.Text__c = commentV2.text;
                       additionalInfoComment.Sentiment__c = commentV2.sentiment;
                       //additionalInfoComment.Creditsafe_Company_Additional_Info_DE__c = additionalInfoDE.Id;
                       unitOfWork.registerNew(additionalInfoComment, Creditsafe_Comp_Additional_Info_Comment__c.Creditsafe_Company_Additional_Info_DE__c, additionalInfoDE);
                   }
               }

               if (additionalInformationDEAdditionalInformationV2.historical_events != null && additionalInformationDEAdditionalInformationV2.historical_events.item != null) {
                   for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 : additionalInformationDEAdditionalInformationV2.historical_events.item) {
                       Additional_Information_Historical_Event__c additionalInformationHistoricalEvent = new Additional_Information_Historical_Event__c();
                       additionalInformationHistoricalEvent.Date__c = getDate(historicalEventV2.date_x);
                       additionalInformationHistoricalEvent.Description__c = historicalEventV2.description;
                       additionalInformationHistoricalEvent.Previous_Value__c = historicalEventV2.previous_value;
                       additionalInformationHistoricalEvent.Current_Value__c = historicalEventV2.current_value;
                       //additionalInformationHistoricalEvent.Creditsafe_Company_Additional_Info_DE__c = additionalInfoDE.Id;
                       unitOfWork.registerNew(additionalInformationHistoricalEvent, Additional_Information_Historical_Event__c.Creditsafe_Company_Additional_Info_DE__c, additionalInfoDE);
                   }
               }
               //companyReportFull.Creditsafe_Company_Additional_Info_DE__c = additionalInfoDE.Id;
               unitOfWork.registerNew(additionalInfoDE, Creditsafe_Company_Additional_Info_DE__c.Creditsafe_Company_Report_Full__c, companyReportFull);
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

               if (additionalInformationNLAdditionalInformationV2.financial_items != null && additionalInformationNLAdditionalInformationV2.financial_items.item != null) {
                   for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2 financialItemV2 :additionalInformationNLAdditionalInformationV2.financial_items.item) {
                       Additional_Information_NL_Financial_Item__c additionalInformationNLFinancialItem = new Additional_Information_NL_Financial_Item__c();
                       additionalInformationNLFinancialItem.Date_Year_End__c = getDate(financialItemV2.date_year_end);
                       additionalInformationNLFinancialItem.Judgement__c = financialItemV2.judgement;
                       additionalInformationNLFinancialItem.Consolidated_Subsidiaries__c = financialItemV2.consolidated_subsidiaries;
                       //additionalInformationNLFinancialItem.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                       unitOfWork.registerNew(additionalInformationNLFinancialItem, Additional_Information_NL_Financial_Item__c.Creditsafe_Company_Additional_Info_NL__c, additionalInfoNL);
                   }
               }

               if (additionalInformationNLAdditionalInformationV2.kvk_filings != null && additionalInformationNLAdditionalInformationV2.kvk_filings.item != null) {
                   for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2 kvkFilingV2 : additionalInformationNLAdditionalInformationV2.kvk_filings.item) {
                       Additional_Information_NL_Kvk_Filing__c additionalInformationNLKvkFiling = new Additional_Information_NL_Kvk_Filing__c();
                       additionalInformationNLKvkFiling.Date__c = getDate(kvkFilingV2.date_x);
                       additionalInformationNLKvkFiling.Event__c = kvkFilingV2.event;
                       //additionalInformationNLKvkFiling.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                       unitOfWork.registerNew(additionalInformationNLKvkFiling, Additional_Information_NL_Kvk_Filing__c.Creditsafe_Company_Additional_Info_NL__c, additionalInfoNL);
                   }
               }

               if (additionalInformationNLAdditionalInformationV2.letters_of_liablility_information403 != null && additionalInformationNLAdditionalInformationV2.letters_of_liablility_information403.item != null) {
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
                       unitOfWork.registerNew(additionalInfoNLLetterOfLiability, Additional_Info_NL_Letter_Of_Liability__c.Creditsafe_Company_Additional_Info_NL__c, additionalInfoNL);
                   }
               }

               if (additionalInformationNLAdditionalInformationV2.comments != null && additionalInformationNLAdditionalInformationV2.comments.item != null) {
                   for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 : additionalInformationNLAdditionalInformationV2.comments.item) {
                       Creditsafe_Comp_Additional_Info_Comment__c additionalInfoComment = new Creditsafe_Comp_Additional_Info_Comment__c();
                       additionalInfoComment.Text__c = commentV2.text;
                       additionalInfoComment.Sentiment__c = commentV2.sentiment;
                       //additionalInfoComment.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                       unitOfWork.registerNew(additionalInfoComment, Creditsafe_Comp_Additional_Info_Comment__c.Creditsafe_Company_Additional_Info_NL__c, additionalInfoNL);
                   }
               }

               if (additionalInformationNLAdditionalInformationV2.historical_events != null && additionalInformationNLAdditionalInformationV2.historical_events.item != null) {
                   for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 : additionalInformationNLAdditionalInformationV2.historical_events.item) {
                       Additional_Information_Historical_Event__c additionalInformationHistoricalEvent = new Additional_Information_Historical_Event__c();
                       additionalInformationHistoricalEvent.Date__c = getDate(historicalEventV2.date_x);
                       additionalInformationHistoricalEvent.Description__c = historicalEventV2.description;
                       additionalInformationHistoricalEvent.Previous_Value__c = historicalEventV2.previous_value;
                       additionalInformationHistoricalEvent.Current_Value__c = historicalEventV2.current_value;
                       //additionalInformationHistoricalEvent.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                       unitOfWork.registerNew(additionalInformationHistoricalEvent, Additional_Information_Historical_Event__c.Creditsafe_Company_Additional_Info_NL__c, additionalInfoNL);
                   }
               }
               //companyReportFull.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
               unitOfWork.registerNew(additionalInfoNL, Creditsafe_Company_Additional_Info_NL__c.Creditsafe_Company_Report_Full__c, companyReportFull);
           }

           if (reportFullV2.additional_information.generic != null && reportFullV2.additional_information.generic.item != null) {
                   for (CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 : reportFullV2.additional_information.generic.item) {
                       Creditsafe_Company_Key_Value__c creditsafeCompanyKeyValue = new Creditsafe_Company_Key_Value__c();
                       creditsafeCompanyKeyValue.Key__c = keyValueV2.key;
                       creditsafeCompanyKeyValue.Value__c = keyValueV2.value;
                       //creditsafeCompanyKeyValue.Creditsafe_Company_Report_Full__c = companyReportFull.Id;
                       unitOfWork.registerNew(creditsafeCompanyKeyValue, Creditsafe_Company_Key_Value__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                   }
           }
           //insert order additionalInfoDE, additionalInfoNL, additionalInfoComments, additionalInformationHistoricalEvents,
           // additionalInformationNLFinancialItems, additionalInformationNLKvkFilings, additionalInfoNLLetterOfLiabilities, additionalInfoComments, additionalInformationHistoricalEvents,
           // companyReportFull, creditsafeCompanyKeyValues
       }

       return companyReportFull;
   }

   private Creditsafe_Company__c mapCreditsafeCompany(Creditsafe_Company__c creditsafeCompany, CreditsafeWsdl.CreditsafeCompanyCompanyV2 creditsafeCompanyV2, Id recordTypeId) {
       creditsafeCompany.Creditsafe_Number__c = creditsafeCompanyV2.creditsafe_number;
       creditsafeCompany.Date_Last_Account__c = getDate(creditsafeCompanyV2.date_last_account);
       creditsafeCompany.Date_Last_Change__c = getDate(creditsafeCompanyV2.date_last_change);
       if (creditsafeCompanyV2.trade_names != null && creditsafeCompanyV2.trade_names.item != null) {
           String trade_names = '';
           for (Integer i = 0; i < creditsafeCompanyV2.trade_names.item.size(); i++) {
               trade_names += creditsafeCompanyV2.trade_names.item[i] + (i == creditsafeCompanyV2.trade_names.item.size()-1 ? '' : ', ');
           }
           creditsafeCompany.Trade_Names__c = trade_names;
       }
       if (creditsafeCompanyV2.vat_numbers != null && creditsafeCompanyV2.vat_numbers.item != null) {
           String vat_numbers = '';
           for (Integer i = 0; i < creditsafeCompanyV2.vat_numbers.item.size(); i++) {
               vat_numbers += creditsafeCompanyV2.vat_numbers.item[i] + (i == creditsafeCompanyV2.vat_numbers.item.size()-1 ? '' : ', ');
           }
           creditsafeCompany.VAT_Numbers__c = vat_numbers;
       }
       creditsafeCompany.Country__c = creditsafeCompanyV2.country;
       creditsafeCompany.Registration_Number__c = creditsafeCompanyV2.registration_number;
       creditsafeCompany.Name__c = creditsafeCompanyV2.name;
       creditsafeCompany.Company_Id__c = creditsafeCompanyV2.id;
       creditsafeCompany.Type__c = creditsafeCompanyV2.type_x;
       creditsafeCompany.Status__c = creditsafeCompanyV2.status;
       creditsafeCompany.Office_Type__c = creditsafeCompanyV2.office_type;
       creditsafeCompany.RecordTypeId = recordTypeId;

       return creditsafeCompany;

   }

   private Creditsafe_Company_Financial_Statement__c mapFinancialStatement(CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 financialStatementV2, Creditsafe_Company_Financial_Statement__c financialStatement, Id recordTypeId) {
       if (financialStatementV2.balance_sheet != null) {
           financialStatement.Balance_Sheets_Consolidated_Accounts__c = String.valueOf(financialStatementV2.balance_sheet.consolidated_accounts);
           financialStatement.Bank_Liabilities__c = String.valueOf(financialStatementV2.balance_sheet.bank_liabilities);
           financialStatement.Bank_Liabilities_Due_After1year__c = String.valueOf(financialStatementV2.balance_sheet.bank_liabilities_due_after1year);
           financialStatement.Called_Up_Share_Capital__c = String.valueOf(financialStatementV2.balance_sheet.called_up_share_capital);
           financialStatement.Cash__c = String.valueOf(financialStatementV2.balance_sheet.cash);
           financialStatement.Finished_Goods__c = String.valueOf(financialStatementV2.balance_sheet.finished_goods);
           financialStatement.Goodwill__c = String.valueOf(financialStatementV2.balance_sheet.goodwill);
           financialStatement.Group_Payables__c = String.valueOf(financialStatementV2.balance_sheet.group_payables);
           financialStatement.Group_Payables_Due_After1year__c = String.valueOf(financialStatementV2.balance_sheet.group_payables_due_after1year);
           financialStatement.Group_Receivables__c = String.valueOf(financialStatementV2.balance_sheet.group_receivables);
           financialStatement.Investments__c = String.valueOf(financialStatementV2.balance_sheet.investments);
           financialStatement.Land_And_Buildings__c = String.valueOf(financialStatementV2.balance_sheet.land_and_buildings);
           financialStatement.Loans_To_Group__c = String.valueOf(financialStatementV2.balance_sheet.loans_to_group);
           financialStatement.Miscellaneous_Fixed_Assets__c = String.valueOf(financialStatementV2.balance_sheet.miscellaneous_fixed_assets);
           financialStatement.Miscellaneous_Liabilities__c = String.valueOf(financialStatementV2.balance_sheet.miscellaneous_liabilities);
           financialStatement.Miscellaneous_Liabilities_Due_After1year__c = String.valueOf(financialStatementV2.balance_sheet.miscellaneous_liabilities_due_after1_year);
           financialStatement.Miscellaneous_Receivables__c = String.valueOf(financialStatementV2.balance_sheet.miscellaneous_receivables);
           financialStatement.Other_Current_Assets__c = String.valueOf(financialStatementV2.balance_sheet.other_current_assets);
           financialStatement.Other_Intangible_Assets__c = String.valueOf(financialStatementV2.balance_sheet.other_intangible_assets);
           financialStatement.Other_Inventories__c = String.valueOf(financialStatementV2.balance_sheet.other_inventories);
           financialStatement.Other_Loans__c = String.valueOf(financialStatementV2.balance_sheet.other_loans);
           financialStatement.Other_Loans_Or_Finance__c = String.valueOf(financialStatementV2.balance_sheet.other_loans_or_finance);
           financialStatement.Other_Loans_Or_Finance_Due_After1year__c = String.valueOf(financialStatementV2.balance_sheet.other_loans_or_finance_due_after1_year);
           financialStatement.Other_Reserves__c = String.valueOf(financialStatementV2.balance_sheet.other_reserves);
           financialStatement.Other_Tangible_Assets__c = String.valueOf(financialStatementV2.balance_sheet.other_tangible_assets);
           financialStatement.Plant_And_Machinery__c = String.valueOf(financialStatementV2.balance_sheet.plant_and_machinery);
           financialStatement.Raw_Materials__c = String.valueOf(financialStatementV2.balance_sheet.raw_materials);
           financialStatement.Receivables_Due_After1year__c = String.valueOf(financialStatementV2.balance_sheet.receivables_due_after1year);
           financialStatement.Revenue_Reserves__c = String.valueOf(financialStatementV2.balance_sheet.revenue_reserves);
           financialStatement.Share_Premium__c = String.valueOf(financialStatementV2.balance_sheet.share_premium);
           financialStatement.Total_Assets__c = String.valueOf(financialStatementV2.balance_sheet.total_assets);
           financialStatement.Total_Current_Assets__c = String.valueOf(financialStatementV2.balance_sheet.total_current_assets);
           financialStatement.Total_Current_Liabilities__c = String.valueOf(financialStatementV2.balance_sheet.total_current_liabilities);
           financialStatement.Total_Fixed_Assets__c = String.valueOf(financialStatementV2.balance_sheet.total_fixed_assets);
           financialStatement.Total_Liabilities__c = String.valueOf(financialStatementV2.balance_sheet.total_liabilities);
           financialStatement.Total_Inventories__c = String.valueOf(financialStatementV2.balance_sheet.total_inventories);
           financialStatement.Total_Intangible_Assets__c = String.valueOf(financialStatementV2.balance_sheet.total_intangible_assets);
           financialStatement.Total_Long_Term_Liabilities__c = String.valueOf(financialStatementV2.balance_sheet.total_long_term_liabilities);
           financialStatement.Total_Other_Fixed_Assets__c = String.valueOf(financialStatementV2.balance_sheet.total_other_fixed_assets);
           financialStatement.Total_Receivables__c = String.valueOf(financialStatementV2.balance_sheet.total_receivables);
           financialStatement.Total_Shareholders_Equity__c = String.valueOf(financialStatementV2.balance_sheet.total_shareholders_equity);
           financialStatement.Total_Tangible_Assets__c = String.valueOf(financialStatementV2.balance_sheet.total_tangible_assets);
           financialStatement.Trade_Payables__c = String.valueOf(financialStatementV2.balance_sheet.trade_payables);
           financialStatement.Trade_Payables_Due_After1year__c = String.valueOf(financialStatementV2.balance_sheet.trade_payables_due_after1year);
           financialStatement.Trade_Receivables__c = String.valueOf(financialStatementV2.balance_sheet.trade_receivables);
           financialStatement.Work_In_Progress__c = String.valueOf(financialStatementV2.balance_sheet.work_in_progress);
       }
       financialStatement.Consolidated_Accounts__c = financialStatementV2.consolidated_accounts != null ? financialStatementV2.consolidated_accounts : false;
       financialStatement.Currency__c = financialStatementV2.currency_x;
       financialStatement.Number_Of_Weeks__c = String.valueOf(financialStatementV2.number_of_weeks);
       financialStatement.Net_Worth__c = financialStatementV2.other_financials != null ? String.valueOf(financialStatementV2.other_financials.net_worth) : null;
       financialStatement.Working_Capital__c = financialStatementV2.other_financials != null ? String.valueOf(financialStatementV2.other_financials.working_capital) : null;
       if(financialStatementV2.profit_and_loss != null) {
           financialStatement.Depreciation__c = String.valueOf(financialStatementV2.profit_and_loss.depreciation);
           financialStatement.Dividends__c = String.valueOf(financialStatementV2.profit_and_loss.dividends);
           financialStatement.Financial_Expenses__c = String.valueOf(financialStatementV2.profit_and_loss.financial_expenses);
           financialStatement.Financial_Income__c = String.valueOf(financialStatementV2.profit_and_loss.financial_income);
           financialStatement.Operating_Costs__c = String.valueOf(financialStatementV2.profit_and_loss.operating_costs);
           financialStatement.Operating_Profit__c = String.valueOf(financialStatementV2.profit_and_loss.operating_profit);
           financialStatement.Other_Appropriations__c = String.valueOf(financialStatementV2.profit_and_loss.other_appropriations);
           financialStatement.Pension_Costs__c = String.valueOf(financialStatementV2.profit_and_loss.pension_costs);
           financialStatement.Profit_After_Tax__c = String.valueOf(financialStatementV2.profit_and_loss.profit_after_tax);
           financialStatement.Profit_Before_Tax__c = String.valueOf(financialStatementV2.profit_and_loss.profit_before_tax);
           financialStatement.Retained_Profit__c = String.valueOf(financialStatementV2.profit_and_loss.retained_profit);
           financialStatement.Revenue__c = String.valueOf(financialStatementV2.profit_and_loss.revenue);
           financialStatement.Tax__c = String.valueOf(financialStatementV2.profit_and_loss.tax);
           financialStatement.Wages_And_Salaries__c = String.valueOf(financialStatementV2.profit_and_loss.wages_and_salaries);
       }
       if (financialStatementV2.ratios != null) {
           financialStatement.Creditor_Days__c = String.valueOf(financialStatementV2.ratios.creditor_days);
           financialStatement.Current_Debt_Ratio__c = String.valueOf(financialStatementV2.ratios.current_debt_ratio);
           financialStatement.Current_Ratio__c = String.valueOf(financialStatementV2.ratios.current_ratio);
           financialStatement.Debtor_Days__c = String.valueOf(financialStatementV2.ratios.debtor_days);
           financialStatement.Equity_In_Percentage__c = String.valueOf(financialStatementV2.ratios.equity_in_percentage);
           financialStatement.Gearing__c = String.valueOf(financialStatementV2.ratios.gearing);
           financialStatement.Liquidity_Ratio_Or_Acid_Test__c = String.valueOf(financialStatementV2.ratios.liquidity_ratio_or_acid_test);
           financialStatement.Pre_Tax_Profit_Margin__c = String.valueOf(financialStatementV2.ratios.pre_tax_profit_margin);
           financialStatement.Return_On_Capital_Employed__c = String.valueOf(financialStatementV2.ratios.return_on_capital_employed);
           financialStatement.Return_On_Net_Assets_Employed__c = String.valueOf(financialStatementV2.ratios.return_on_net_assets_employed);
           financialStatement.Return_On_Total_Assets_Employed__c = String.valueOf(financialStatementV2.ratios.return_on_total_assets_employed);
           financialStatement.Sales_Or_Net_Working_Capital__c = String.valueOf(financialStatementV2.ratios.sales_or_net_working_capital);
           financialStatement.Stock_Turnover_Ratio__c = String.valueOf(financialStatementV2.ratios.stock_turnover_ratio);
           financialStatement.Total_Debt_Ratio__c = String.valueOf(financialStatementV2.ratios.total_debt_ratio);
       }
       financialStatement.Type__c = financialStatementV2.type_x;
       financialStatement.Year_End_Date__c = getDate(financialStatementV2.year_end_date);

       return financialStatement;
   }

   private Dossier_Address__c mapCreditSafeAddress(CreditsafeWsdl.CreditsafeAddressV2 dataVendorDossier, Dossier_Address__c addressDB) {
       addressDB.Name = dataVendorDossier.full_address != null ? dataVendorDossier.full_address.abbreviate(79) : '';
       addressDB.Full_Address__c = dataVendorDossier.full_address;
       addressDB.Postcode__c = dataVendorDossier.postal_code;
       addressDB.Street__c = dataVendorDossier.street;
       addressDB.City__c = dataVendorDossier.city;
       addressDB.House_Number__c = dataVendorDossier.house_number;
       addressDB.Country__c = dataVendorDossier.country;
       addressDB.Telephone__c = dataVendorDossier.telephone;
       addressDB.RecordTypeId = Schema.SObjectType.Dossier_Address__c.getRecordTypeInfosByDeveloperName().get('Creditsafe_Address').getRecordTypeId();

       return addressDB;
   }


   private Date getDate(Datetime dateTimeObject) {
       return dateTimeObject != null ? Date.newInstance(dateTimeObject.year(), dateTimeObject.month(), dateTimeObject.day()) : null;
   }

   private Integer getInteger(String value) {
       return value != null ? Integer.valueOf(value) : null;
   }*/

}