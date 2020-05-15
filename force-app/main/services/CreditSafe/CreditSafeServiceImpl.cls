/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public inherited sharing class CreditSafeServiceImpl implements ICreditSafeService{

    public List<Business_Dossier__c> searchForCreditSafeDossiers(List<String> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        // check the input
        if (countries == null || countries.isEmpty()) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }
        // no checks needed so commented
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        Map<String, List<Business_Dossier__c>> businessDossiersByParameters = new Map<String, List<Business_Dossier__c>>();

        switch on countries.get(0) {
            when 'NL' {     // when country is Netherlands
                resultValue.addAll(searchCriteriaNL(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'BE' {		// when country is Belgium
                resultValue.addAll(searchCriteriaBE(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'DE' {		// when country is Germany
                resultValue.addAll(searchCriteriaDE(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'FR' {		  // when country is France
                resultValue.addAll(searchCriteriaFR(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'GB' {		  // when country is United Kingdom
                resultValue.addAll(searchCriteriaGB(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'IE' {		  // when country is Ireland
                resultValue.addAll(searchCriteriaIE(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'SE' {		  // when country is Sweden
                resultValue.addAll(searchCriteriaSE(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'DK' {		  // when country is Denmark
                resultValue.addAll(searchCriteriaDK(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'IT' {		  // when country is Italy
                resultValue.addAll(searchCriteriaIT(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'ES' {		  // when country is Spain
                resultValue.addAll(searchCriteriaES(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
            when 'NO' {		  // when country is Norway
                resultValue.addAll(searchCriteriaNO(id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name));
            }
        }

        return resultValue;
    }

    public Creditsafe_Company_Report_Full__c getCreditsafeReportFullV2(String company_id, String language, String reason) {
        //check input
        if (String.isEmpty(company_id) || String.isEmpty(language)) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }

        CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2 = WsCreditsafe.creditsafeGetReportFullV2(company_id, language, reason);
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        Creditsafe_Company_Report_Full__c companyReportFull = new Creditsafe_Company_Report_Full__c();
        unitOfWork.registerNew(companyReportFull);

        companyReportFull = mapAdditionalInfo(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapCompanyIdentification(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapCompanySummary(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapContactInfo(companyReportFull, reportFullV2, unitOfWork);

        companyReportFull = mapCreditScore(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapDirectors(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapFinancialStatements(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapGroupStructure(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapLocalFinancialStatements(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapNegativeInformation(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapOtherInformation(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapShareCapital(companyReportFull, reportFullV2, unitOfWork);
        companyReportFull = mapPaymentData(companyReportFull, reportFullV2, unitOfWork);

        companyReportFull.Order_Number__c = reportFullV2.order_number != null ? reportFullV2.order_number : null;
        companyReportFull.Company_Id__c = reportFullV2.company_id;
        companyReportFull.Language__c = reportFullV2.language;

        unitOfWork.commitWork();
        return companyReportFull;

    }

    /*********************************
     * IMPLEMENTATION METHODS
     ***********************************/

    private List<Business_Dossier__c> searchCriteriaNL(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'NL'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }
        //parameter2 - creditsafe_unique_id - not available as input parameter

        //parameter3 - registration_number
        if (String.isNotEmpty(registration_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'NL'}, '', '', registration_number, '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
            resultValue.addAll(resultValue1);
        }
        //parameter4 - name, status, street, city, postalcode
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'NL'}, '', status, '', '', '', '', city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }
        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaBE(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'BE'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - creditsafe_unique_id  - not available as input parameter

        //parameter3 - registration_number
        if (String.isNotEmpty(registration_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'BE'}, '', '', registration_number, '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
            resultValue.addAll(resultValue1);
        }

        //parameter4 - vat_number
        if (String.isNotEmpty(vat_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'BE'}, '', '', '', '', vat_number, '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'vat_number');
            resultValue.addAll(resultValue1);
        }

        //parameter5 - name, status, street, city, postalcode
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'BE'}, '', status, '', '', '', '', city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaDE(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'DE'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - creditsafe_unique_id - not available as input parameter

        //parameter3 - vat_number
        if (String.isNotEmpty(vat_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'DE'}, '', '', '', '', vat_number, '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'vat_number');
            resultValue.addAll(resultValue1);
        }

        //parameter4 - registration_number - required, registration_type, city
        if (String.isNotEmpty(registration_number)) {
            if (String.isNotEmpty(registration_type) || String.isNotEmpty(city)) {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'DE'}, '', '', registration_number, registration_type, '', '', city, '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'registration_number, registration_type, city');
                resultValue.addAll(resultValue1);
            }
            else {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'DE'}, '', '', registration_number, '', '', '', '', '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'registration_number, registration_type, city');
                resultValue.addAll(resultValue1);
            }
        }

        //parameter5 - name, status, registration_type, street, city, postalcode
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code) || String.isNotEmpty(registration_type)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'DE'}, '', status, '', registration_type, '', '', city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, registration_type, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaFR(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'FR'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - creditsafe_unique_id - not available as input parameter

        //parameter3 - registration_number - required, status, postalcode
        if (String.isNotEmpty(registration_number)) {
            if(String.isNotEmpty(status) || String.isNotEmpty(postal_code)) {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'FR'}, '', status, registration_number, '', '', '', '', '', postal_code, ''));
                resultValue1 = addSearchCriteria(resultValue1, 'registration_number, status, postalcode');
                resultValue.addAll(resultValue1);
            }
            else {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'FR'}, '', '', registration_number, '', '', '', '', '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'registration_number, status, postalcode');
                resultValue.addAll(resultValue1);
            }
        }

        //parameter4 - vat_number
        if (String.isNotEmpty(vat_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'FR'}, '', '', '', '', vat_number, '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'vat_number');
            resultValue.addAll(resultValue1);
        }

        //parameter5 - name, status, street, city, province, postalcode
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'FR'}, '', status, '', '', '', '', city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, street, city, province, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaGB(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'GB'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - creditsafe_unique_id - not available as input parameter

        //parameter3 - registration_number
        if (String.isNotEmpty(registration_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'GB'}, '', '', registration_number, '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
            resultValue.addAll(resultValue1);
        }

        //parameter4 - vat_number
        if (String.isNotEmpty(vat_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'GB'}, '', '', '', '', vat_number, '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'vat_number');
            resultValue.addAll(resultValue1);
        }

        //parameter4 - name, status, registration_type, street, city, postalcode
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code) || String.isNotEmpty(registration_type)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'GB'}, '', status, '', registration_type, '', '', city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, registration_type, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaIE(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'IE'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - creditsafe_unique_id  - not available as input parameter

        //parameter3 - registration_number
        if (String.isNotEmpty(registration_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'IE'}, '', '', registration_number, '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
            resultValue.addAll(resultValue1);
        }

        //parameter4 - name, status, registration_type, street, city, postalcode
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code) || String.isNotEmpty(registration_type)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'IE'}, '', status, '', registration_type, '', '', city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, registration_type, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaSE(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'SE'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - registration_number, registration_type
        if (String.isNotEmpty(registration_number)) {
            if(String.isNotEmpty(registration_type)) {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'SE'}, '', '', registration_number, registration_type, '', '', '', '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
                resultValue.addAll(resultValue1);
            }
            else {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'SE'}, '', '', registration_number, '', '', '', '', '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
                resultValue.addAll(resultValue1);
            }
        }

        //parameter3 - name, status, registration_type, street, city, postalcode
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code) || String.isNotEmpty(registration_type)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'SE'}, '', status, '', registration_type, '', '', city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, registration_type, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaIT(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'IT'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - registration_number
        if (String.isNotEmpty(registration_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'IT'}, '', '', registration_number, '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
            resultValue.addAll(resultValue1);
        }

        //parameter3 - vat_number, status, registration type
        if (String.isNotEmpty(vat_number)) {
            if (String.isNotEmpty(status) || String.isNotEmpty(registration_type)) {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'IT'}, '', status, '', registration_type, vat_number, '', '', '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'vat_number');
                resultValue.addAll(resultValue1);
            }
            else {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'IT'}, '', '', '', '', vat_number, '', '', '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'vat_number');
                resultValue.addAll(resultValue1);
            }
        }

        //parameter4 - name, status, registration_type, street, city, postalcode, province
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code) || String.isNotEmpty(registration_type) || String.isNotEmpty(province)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'IT'}, '', status, '', registration_type, '', province, city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, registration_type, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaDK(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'DK'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - registration_number
        if (String.isNotEmpty(registration_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'DK'}, '', '', registration_number, '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
            resultValue.addAll(resultValue1);
        }

        //parameter3 - vat_number
        if (String.isNotEmpty(vat_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'DK'}, '', '', '', '', vat_number, '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'vat_number');
            resultValue.addAll(resultValue1);
        }

        //parameter4 - name, status, street, city, postalcode, province
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code) || String.isNotEmpty(province)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'DK'}, '', status, '', '', '', province, city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, street, city, province, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaNO(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'NO'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - registration_number, registration_type
        if (String.isNotEmpty(registration_number)) {
            if(String.isNotEmpty(registration_type)) {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'NO'}, '', '', registration_number, registration_type, '', '', '', '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
                resultValue.addAll(resultValue1);
            }
            else {
                List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
                resultValue1.addAll(doSearch(new List<String>{'NO'}, '', '', registration_number, '', '', '', '', '', '', ''));
                resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
                resultValue.addAll(resultValue1);
            }
        }

        //parameter3 - name, status, registration_type, street, city, postalcode
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code) || String.isNotEmpty(registration_type)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'NO'}, '', status, '', registration_type, '', '', city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, registration_type, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> searchCriteriaES(String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        //parameter1 - companyid
        if (String.isNotEmpty(id)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'ES'}, id, '', '', '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'companyid');
            resultValue.addAll(resultValue1);
        }

        //parameter2 - registration_number
        if (String.isNotEmpty(registration_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'ES'}, '', '', registration_number, '', '', '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'registration_number');
            resultValue.addAll(resultValue1);
        }

        //parameter3 - vat_number
        if (String.isNotEmpty(vat_number)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'ES'}, '', '', '', '', vat_number, '', '', '', '', ''));
            resultValue1 = addSearchCriteria(resultValue1, 'vat_number');
            resultValue.addAll(resultValue1);
        }

        //parameter4 - name, status, registration_type, street, city, postalcode, province
        if (String.isNotEmpty(name) || String.isNotEmpty(status) || String.isNotEmpty(street) || String.isNotEmpty(city) || String.isNotEmpty(postal_code) || String.isNotEmpty(registration_type) || String.isNotEmpty(province)) {
            List<Business_Dossier__c> resultValue1 = new List<Business_Dossier__c>();
            resultValue1.addAll(doSearch(new List<String>{'ES'}, '', status, '', registration_type, '', province, city, street, postal_code, name));
            resultValue1 = addSearchCriteria(resultValue1, 'name, status, registration_type, street, city, postalcode');
            resultValue.addAll(resultValue1);
        }

        return resultValue;
    }

    private List<Business_Dossier__c> doSearch(List<String> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<Business_Dossier__c> resultValue = new List<Business_Dossier__c>();
        CreditsafeWsdl.stringArray creditSafeCountries = new CreditsafeWsdl.stringArray();
        creditSafeCountries.item = countries;
        CreditsafeWsdl.CreditsafeSearchResultV2 searchResult = WsCreditsafe.creditsafeSearchV2(creditSafeCountries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
        if (searchResult != null && searchResult.companies != null && searchResult.companies.item != null) {
            for (CreditsafeWsdl.CreditsafeCompanyV2 company : searchResult.companies.item) {
                resultValue.add(mapCreditsafeSearchResultV2ToBusinessDossier(company));
            }
        }
        return resultValue;
    }

    private List<Business_Dossier__c> addSearchCriteria(List<Business_Dossier__c> dossiers, String searchCriteria) {
        for (Business_Dossier__c dossier : dossiers) {
            dossier.Search_Criteria_Name__c = searchCriteria;
        }

        return dossiers;
    }

    private Business_Dossier__c mapCreditsafeSearchResultV2ToBusinessDossier(CreditsafeWsdl.CreditsafeCompanyV2 creditsafeCompanyV2) {
        Business_Dossier__c dossier = new Business_Dossier__c();
        dossier.Creditsafe_Id__c = creditsafeCompanyV2.creditsafe_number;
        dossier.Date_of_Last_Account__c = creditsafeCompanyV2.date_last_account;
        dossier.Date_of_Last_Change__c = creditsafeCompanyV2.date_last_change;
        if (creditsafeCompanyV2.trade_names != null && creditsafeCompanyV2.trade_names.item != null) {
            dossier.Trade_Names__c = '';
            for (Integer i = 0; i < creditsafeCompanyV2.trade_names.item.size(); i++) {
                dossier.Trade_Names__c += creditsafeCompanyV2.trade_names.item[i];
                if (String.isNotEmpty(dossier.Trade_Names__c)) {
                    if (i < creditsafeCompanyV2.trade_names.item.size() - 1) {
                        dossier.Trade_Names__c += ', ';
                    }
                }
            }
        }
        dossier.VAT_Number__c = (creditsafeCompanyV2.vat_numbers != null && creditsafeCompanyV2.vat_numbers.item != null && creditsafeCompanyV2.vat_numbers.item.size() >= 1) ? creditsafeCompanyV2.vat_numbers.item[0] : null;
        dossier.Country__c = creditsafeCompanyV2.country;
        dossier.Dossier_Number__c = creditsafeCompanyV2.registration_number;
        dossier.Name = creditsafeCompanyV2.name;
        dossier.Type__c = creditsafeCompanyV2.type_x;
        dossier.Status__c = creditsafeCompanyV2.status;
        dossier.Office_Type__c = creditsafeCompanyV2.office_type;
        dossier.Street__c = creditsafeCompanyV2.address != null ? creditsafeCompanyV2.address.street : null;
        dossier.Telephone_Number__c = creditsafeCompanyV2.address != null ? creditsafeCompanyV2.address.telephone : null;
        dossier.Postal_Code__c = creditsafeCompanyV2.address != null ? creditsafeCompanyV2.address.postal_code : null;
        dossier.House_number__c = creditsafeCompanyV2.address != null ? creditsafeCompanyV2.address.house_number : null;
        dossier.City__c = creditsafeCompanyV2.address != null ? creditsafeCompanyV2.address.city : null;
        dossier.Full_Address__c = creditsafeCompanyV2.address != null ? creditsafeCompanyV2.address.full_address : null;
        dossier.Registration_Country__c = dossier.Country__c;
        dossier.Company_Id__c = creditsafeCompanyV2.id;
        dossier.RecordTypeId = Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByName().get('Creditsafe').getRecordTypeId();
        return dossier;
    }

    private Creditsafe_Company_Report_Full__c mapPaymentData(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
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
                    shareHolder.Name__c = shareHolderV2.name;
                    shareHolder.Share_Percent__c = shareHolderV2.share_percent;
                    if (shareHolderV2.address != null) {
                        shareHolder.Full_Address__c = shareHolderV2.address.full_address;
                        shareHolder.Postcode__c = shareHolderV2.address.postal_code;
                        shareHolder.Street__c = shareHolderV2.address.street;
                        shareHolder.City__c = shareHolderV2.address.city;
                        shareHolder.House_Number__c = shareHolderV2.address.house_number;
                        shareHolder.Country__c = shareHolderV2.address.country;
                        shareHolder.Telephone__c = shareHolderV2.address.telephone;
                    }
                    unitOfWork.registerNew(shareHolder, Creditsafe_Company_Share_Holder__c.Creditsafe_Company_Report_Full__c, companyReportFull);
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
                    banker.Bank_Code__c = bankerV2.bank_code;
                    banker.Name__c = bankerV2.name;
                    if (bankerV2.address != null) {
                        banker.Full_Address__c = bankerV2.address.full_address;
                        banker.Postcode__c = bankerV2.address.postal_code;
                        banker.Street__c = bankerV2.address.street;
                        banker.City__c = bankerV2.address.city;
                        banker.House_Number__c = bankerV2.address.house_number;
                        banker.Country__c = bankerV2.address.country;
                        banker.Telephone__c = bankerV2.address.telephone;
                    }
                    unitOfWork.registerNew(banker, Creditsafe_Company_Banker__c.Creditsafe_Company_Report_Full__c, companyReportFull);
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
                //Creditsafe_Company_Negative_Info_DE__c negativeInfoDE = new Creditsafe_Company_Negative_Info_DE__c();
                if (reportFullV2.negative_information.de.bankruptcy != null) {
                    companyReportFull.Has_Bankruptcy__c = reportFullV2.negative_information.de.bankruptcy.has_bankruptcy;
                }
                if (reportFullV2.negative_information.de.insolvency_information != null) {
                    companyReportFull.Date_Of_Insolvency__c = reportFullV2.negative_information.de.insolvency_information.dateof_insolvency;
                    if (reportFullV2.negative_information.de.insolvency_information.trustee != null) {
                        companyReportFull.Trustee_City__c = reportFullV2.negative_information.de.insolvency_information.trustee.city;
                        companyReportFull.Trustee_Code__c = reportFullV2.negative_information.de.insolvency_information.trustee.code;
                        companyReportFull.Trustee_Email_Address__c = reportFullV2.negative_information.de.insolvency_information.trustee.email_address;
                        companyReportFull.Trustee_Fax_Number__c = reportFullV2.negative_information.de.insolvency_information.trustee.fax_number;
                        companyReportFull.Trustee_First_Name__c = reportFullV2.negative_information.de.insolvency_information.trustee.first_name;
                        companyReportFull.Trustee_Last_Name__c = reportFullV2.negative_information.de.insolvency_information.trustee.last_name;
                        companyReportFull.Trustee_Name__c = reportFullV2.negative_information.de.insolvency_information.trustee.name;
                        companyReportFull.Trustee_Telephone_Number__c = reportFullV2.negative_information.de.insolvency_information.trustee.telephone_number;
                        companyReportFull.Trustee_Title__c = reportFullV2.negative_information.de.insolvency_information.trustee.title;
                    }
                    if (reportFullV2.negative_information.de.insolvency_information.insolvency_events != null && reportFullV2.negative_information.de.insolvency_information.insolvency_events.item != null) {
                        for (CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2 insolvencyEventV2 : reportFullV2.negative_information.de.insolvency_information.insolvency_events.item) {
                            Negative_Information_DE_Insolvency_Event__c insolvencyEvent = new Negative_Information_DE_Insolvency_Event__c();
                            insolvencyEvent.Reference_Number_Court__c = insolvencyEventV2.reference_number_court;
                            insolvencyEvent.Created_At__c = getDate(insolvencyEventV2.created_at);
                            unitOfWork.registerNew(insolvencyEvent, Negative_Information_DE_Insolvency_Event__c.Creditsafe_Company_Report_Full__c, companyReportFull);
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
                        unitOfWork.registerNew(directorEvent, Negative_Information_DE_Director_Event__c.Creditsafe_Company_Report_Full__c , companyReportFull);
                    }
                }
                //unitOfWork.registerNew(negativeInfoDE, Creditsafe_Company_Negative_Info_DE__c.Creditsafe_Company_Report_Full__c, companyReportFull);
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
            for (CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 financialStatementV2 :reportFullV2.local_financial_statements.item) {
                Creditsafe_Company_Financial_Statement__c financialStatement = mapFinancialStatement(financialStatementV2, new Creditsafe_Company_Financial_Statement__c());
                unitOfWork.registerNew(financialStatement, Creditsafe_Company_Financial_Statement__c.Creditsafe_Company_Report_Full__c, companyReportFull);
            }
        }

        return companyReportFull;
    }

    private Creditsafe_Company_Report_Full__c mapGroupStructure(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
        if (reportFullV2.group_structure != null) {
            if (reportFullV2.group_structure.ultimate_parent != null) {
                Creditsafe_Company__c creditsafeCompany = mapCreditsafeCompany(new Creditsafe_Company__c(), reportFullV2.group_structure.ultimate_parent, 'Ultimate_Parent');
                unitOfWork.registerNew(creditsafeCompany, Creditsafe_Company__c.Creditsafe_Company_Report_Full__c, companyReportFull);
            }
            if (reportFullV2.group_structure.immediate_parent != null) {
                Creditsafe_Company__c creditsafeCompany = mapCreditsafeCompany(new Creditsafe_Company__c(), reportFullV2.group_structure.immediate_parent, 'Immediate_Parent');
                unitOfWork.registerNew(creditsafeCompany, Creditsafe_Company__c.Creditsafe_Company_Report_Full__c, companyReportFull);
            }
            if (reportFullV2.group_structure.subsidiary_companies != null && reportFullV2.group_structure.subsidiary_companies.item != null) {
                for (CreditsafeWsdl.CreditsafeCompanyCompanyV2 creditsafeCompanyV2 :reportFullV2.group_structure.subsidiary_companies.item) {
                    Creditsafe_Company__c creditsafeCompany = mapCreditsafeCompany(new Creditsafe_Company__c(), creditsafeCompanyV2, 'Subsidiary_Companies');
                    unitOfWork.registerNew(creditsafeCompany, Creditsafe_Company__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                }
            }
            if (reportFullV2.group_structure.affiliated_companies != null && reportFullV2.group_structure.affiliated_companies.item != null) {
                for (CreditsafeWsdl.CreditsafeCompanyCompanyV2 creditsafeCompanyV2 :reportFullV2.group_structure.affiliated_companies.item) {
                    Creditsafe_Company__c creditsafeCompany = mapCreditsafeCompany(new Creditsafe_Company__c(), creditsafeCompanyV2, 'Affiliated_Companies');
                    unitOfWork.registerNew(creditsafeCompany, Creditsafe_Company__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                }
            }
        }

        return companyReportFull;
    }

    private Creditsafe_Company_Report_Full__c mapFinancialStatements(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
        if (reportFullV2.financial_statements != null && reportFullV2.financial_statements.item != null) {
            for (CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 financialStatementV2 :reportFullV2.financial_statements.item) {
                Creditsafe_Company_Financial_Statement__c financialStatement = mapFinancialStatement(financialStatementV2, new Creditsafe_Company_Financial_Statement__c());
                unitOfWork.registerNew(financialStatement, Creditsafe_Company_Financial_Statement__c.Creditsafe_Company_Report_Full__c, companyReportFull);
            }
        }

        return companyReportFull;
    }

    private Creditsafe_Company_Report_Full__c mapContactInfo(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
        if (reportFullV2.contact_information != null) {
            if (reportFullV2.contact_information.main_address != null) {
                Creditsafe_Address__c mainAddress = mapCreditSafeAddress(reportFullV2.contact_information.main_address, new Creditsafe_Address__c(), 'Main Address');
                unitOfWork.registerNew(mainAddress, Creditsafe_Address__c.Creditsafe_Company_Report_Full__c, companyReportFull);
            }
            if (reportFullV2.contact_information.other_addresses != null && reportFullV2.contact_information.other_addresses.item != null) {
                for (CreditsafeWsdl.CreditsafeAddressV2 otherAddressV2 :reportFullV2.contact_information.other_addresses.item) {
                    Creditsafe_Address__c contactInfoAddress = mapCreditSafeAddress(otherAddressV2, new Creditsafe_Address__c(), 'Other Address');
                    unitOfWork.registerNew(contactInfoAddress, Creditsafe_Address__c.Creditsafe_Company_Report_Full__c, companyReportFull);
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
                    unitOfWork.registerNew(personDirector, Creditsafe_Person_Director__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                    if (currentDirectorV2.positions != null) {
                        for (CreditsafeWsdl.CreditsafePersonPositionV2 positionV2: currentDirectorV2.positions.item) {
                            Creditsafe_Person_Position__c personPosition = new Creditsafe_Person_Position__c();
                            personPosition.Date_Appointed__c = getDate(positionV2.date_appointed);
                            personPosition.Position_Name__c = positionV2.name;
                            unitOfWork.registerNew(personPosition, Creditsafe_Person_Position__c.Creditsafe_Person_Director__c, personDirector);
                        }
                    }
                    if (currentDirectorV2.address != null) {
                        personDirector.Full_Address__c = currentDirectorV2.address.full_address;
                        personDirector.Postcode__c = currentDirectorV2.address.postal_code;
                        personDirector.Street__c = currentDirectorV2.address.street;
                        personDirector.City__c = currentDirectorV2.address.city;
                        personDirector.House_Number__c = currentDirectorV2.address.house_number;
                        personDirector.Country__c = currentDirectorV2.address.country;
                        personDirector.Telephone__c = currentDirectorV2.address.telephone;
                    }
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
                    if (previousDirectorV2.address != null) {
                        personDirector.Full_Address__c = previousDirectorV2.address.full_address;
                        personDirector.Postcode__c = previousDirectorV2.address.postal_code;
                        personDirector.Street__c = previousDirectorV2.address.street;
                        personDirector.City__c = previousDirectorV2.address.city;
                        personDirector.House_Number__c = previousDirectorV2.address.house_number;
                        personDirector.Country__c = previousDirectorV2.address.country;
                        personDirector.Telephone__c = previousDirectorV2.address.telephone;
                    }
                    unitOfWork.registerNew(personDirector, Creditsafe_Person_Director__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                }
            }
            //add these related list to companyReportFull
        }

        return companyReportFull;
    }

    private Creditsafe_Company_Report_Full__c mapCreditScore(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork){
        if (reportFullV2.credit_score != null) {
            if (reportFullV2.credit_score.current_credit_rating != null) {
                companyReportFull.Current_CR_Limit__c = reportFullV2.credit_score.current_credit_rating.credit_limit;
                companyReportFull.Current_CR_Common_Description__c = reportFullV2.credit_score.current_credit_rating.common_description;
                companyReportFull.Current_CR_Common_Value__c = reportFullV2.credit_score.current_credit_rating.common_value;
                companyReportFull.Current_CR_Provider_Description__c = reportFullV2.credit_score.current_credit_rating.provider_description;
                if (reportFullV2.credit_score.current_credit_rating.provider_value != null) {
                    companyReportFull.Current_CR_Provider_Value__c = reportFullV2.credit_score.current_credit_rating.provider_value.value;
                    companyReportFull.Current_CR_Provider_Value_Max__c = reportFullV2.credit_score.current_credit_rating.provider_value.max_value;
                    companyReportFull.Current_CR_Provider_Value_Min__c = reportFullV2.credit_score.current_credit_rating.provider_value.min_value;
                }
            }
            if (reportFullV2.credit_score.previous_credit_rating != null) {
                companyReportFull.Previous_CR_Limit__c = reportFullV2.credit_score.previous_credit_rating.credit_limit;
                companyReportFull.Previous_CR_Common_Description__c = reportFullV2.credit_score.previous_credit_rating.common_description;
                companyReportFull.Previous_CR_Common_Value__c = reportFullV2.credit_score.previous_credit_rating.common_value;
                companyReportFull.Previous_CR_Provider_Description__c = reportFullV2.credit_score.previous_credit_rating.provider_description;
                if (reportFullV2.credit_score.previous_credit_rating.provider_value != null) {
                    companyReportFull.Previous_CR_Provider_Value__c = reportFullV2.credit_score.previous_credit_rating.provider_value.value;
                    companyReportFull.Previous_CR_Provider_Value_Max__c = reportFullV2.credit_score.previous_credit_rating.provider_value.max_value;
                    companyReportFull.Previous_CR_Provider_Value_Min__c = reportFullV2.credit_score.previous_credit_rating.provider_value.min_value;
                }
            }
            //companyReportFull.Creditsafe_Company_Credit_Score__c = creditScore.Id;
            //unitOfWork.registerNew(creditScore, Creditsafe_Company_Credit_Score__c.Creditsafe_Company_Report_Full__c, companyReportFull);
        }

        return companyReportFull;
    }

    private Creditsafe_Company_Report_Full__c mapCompanySummary(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
        if (reportFullV2.company_summary != null) {
            if (reportFullV2.company_summary.company_status != null) {
                companyReportFull.Company_Status__c = reportFullV2.company_summary.company_status.status;
                companyReportFull.Company_Status_Description__c = reportFullV2.company_summary.company_status.description;
            }
            if (reportFullV2.company_summary.credit_rating != null) {
                companyReportFull.Credit_Rating_Common_Description__c = reportFullV2.company_summary.credit_rating.common_description;
                companyReportFull.Credit_Rating_Common_Value__c = reportFullV2.company_summary.credit_rating.common_value;
                companyReportFull.Credit_Rating_Limit__c = reportFullV2.company_summary.credit_rating.credit_limit;
                companyReportFull.Credit_Rating_Provider_Description__c = reportFullV2.company_summary.credit_rating.provider_description;
                if (reportFullV2.company_summary.credit_rating.provider_value != null) {
                    companyReportFull.Credit_Rating_Provider_Value__c = reportFullV2.company_summary.credit_rating.provider_value.value;
                    companyReportFull.Credit_Rating_Provider_Value_Max__c = reportFullV2.company_summary.credit_rating.provider_value.max_value;
                    companyReportFull.Credit_Rating_Provider_Value_Min__c = reportFullV2.company_summary.credit_rating.provider_value.min_value;
                }
            }
            if (reportFullV2.company_summary.main_activity != null) {
                companyReportFull.Main_Activity_Code__c = reportFullV2.company_summary.main_activity.activity_code;
                companyReportFull.Main_Activity_Classification__c = reportFullV2.company_summary.main_activity.classification;
                companyReportFull.Main_Activity_Description__c = reportFullV2.company_summary.main_activity.activity_description;
            }
            companyReportFull.Latest_Shareholders_Equity_Figure__c = reportFullV2.company_summary.latest_shareholders_equity_figure;
            companyReportFull.Latest_Turnover_Figure__c = reportFullV2.company_summary.latest_turnover_figure;
            companyReportFull.Number__c = reportFullV2.company_summary.number_x;
            companyReportFull.Company_Registration_Number__c = reportFullV2.company_summary.company_registration_number;
            companyReportFull.Business_Name__c = reportFullV2.company_summary.business_name;
            companyReportFull.Country__c = reportFullV2.company_summary.country;
            //companyReportFull.Creditsafe_Company_Summary__c = companySummary.Id;
            //unitOfWork.registerNew(companySummary, Creditsafe_Company_Summary__c.Creditsafe_Company_Report_Full__c, companyReportFull);
        }

        return companyReportFull;
    }

    private Creditsafe_Company_Report_Full__c mapCompanyIdentification(Creditsafe_Company_Report_Full__c companyReportFull, CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2, fflib_ISObjectUnitOfWork unitOfWork) {
        if (reportFullV2.company_identification != null) {
            if (reportFullV2.company_identification.basic_information != null) {
                CreditsafeWsdl.CreditsafeCompanyBasicInformationV2 basicInformationV2 = reportFullV2.company_identification.basic_information;
                //Creditsafe_Company_Basic_Information__c basicInformation = new Creditsafe_Company_Basic_Information__c();
                if (basicInformationV2.company_status != null) {
                    companyReportFull.Company_Status__c = basicInformationV2.company_status.status;
                    companyReportFull.Company_Status_Description__c = basicInformationV2.company_status.description;
                }
                if (basicInformationV2.legal_form != null) {
                    companyReportFull.Legal_Form_Code__c = basicInformationV2.legal_form.code;
                    companyReportFull.Legal_Form_Description__c = basicInformationV2.legal_form.description;
                    companyReportFull.Legal_Form_Value__c = basicInformationV2.legal_form.value;
                }
                if (basicInformationV2.principal_activity != null) {
                    companyReportFull.Principal_Activity_Code__c = basicInformationV2.principal_activity.code;
                    companyReportFull.Principal_Activity_Description__c = basicInformationV2.principal_activity.description;
                    companyReportFull.Principal_Activity_Value__c = basicInformationV2.principal_activity.value;
                }
                companyReportFull.Company_Registration_Number__c = basicInformationV2.company_registration_number;
                companyReportFull.Business_Name__c = basicInformationV2.business_name;
                companyReportFull.Country__c = basicInformationV2.country;
                companyReportFull.Dateof_Company_Registration__c = basicInformationV2.dateof_company_registration;
                companyReportFull.Dateof_Starting_Operations__c = basicInformationV2.dateof_starting_operations;
                companyReportFull.Registered_Company_Name__c = basicInformationV2.registered_company_name;
                companyReportFull.VAT_Registration_Number__c = basicInformationV2.vat_registration_number;
                //unitOfWork.registerNew(basicInformation, Creditsafe_Company_Basic_Information__c.Creditsafe_Company_Report_Full__c, companyReportFull);

                if (basicInformationV2.contact_address != null) {
                    Creditsafe_Address__c contactAddress = mapCreditSafeAddress(basicInformationV2.contact_address, new Creditsafe_Address__c(), 'Contact Address');
                    unitOfWork.registerRelationship(contactAddress, Creditsafe_Address__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                }
            }
            if (reportFullV2.company_identification.activity_classifications != null && reportFullV2.company_identification.activity_classifications.item != null) {
                for (CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2 activityClassificationV2 : reportFullV2.company_identification.activity_classifications.item) {
                    Creditsafe_Comp_Activity_Classifications__c activityClassification = new Creditsafe_Comp_Activity_Classifications__c();
                    activityClassification.Classification__c = activityClassificationV2.classification;

                    for (CreditsafeWsdl.CreditsafeCompanyActivityV2 companyActivityV2 : activityClassificationV2.activities.item) {
                        Creditsafe_Company_Activity__c companyActivity = new Creditsafe_Company_Activity__c();
                        companyActivity.Classification__c = companyActivityV2.classification;
                        companyActivity.Activity_Code__c = companyActivityV2.activity_code.abbreviate(255);
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
                //Creditsafe_Company_Additional_Info_DE__c additionalInfoDE = new Creditsafe_Company_Additional_Info_DE__c();

                CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEAdditionalInformationV2 additionalInformationDEAdditionalInformationV2 = reportFullV2.additional_information.de;
                if (additionalInformationDEAdditionalInformationV2.miscellaneous != null) {
                    companyReportFull.Miscellaneous_Turnover_Range__c = additionalInformationDEAdditionalInformationV2.miscellaneous.turnover_range;
                    companyReportFull.Commercial_Register_City__c = additionalInformationDEAdditionalInformationV2.miscellaneous.commercial_register_city;
                    companyReportFull.Commercial_Register_Zip__c = additionalInformationDEAdditionalInformationV2.miscellaneous.commercial_register_zip;
                    companyReportFull.Financials_Quality__c = additionalInformationDEAdditionalInformationV2.miscellaneous.financials_quality;
                    if (additionalInformationDEAdditionalInformationV2.miscellaneous.current_rating != null) {
                        companyReportFull.Current_Rating_Max_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.current_rating.max_value;
                        companyReportFull.Current_Rating_Min_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.current_rating.min_value;
                        companyReportFull.Current_Rating_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.current_rating.value;
                    }
                    if (additionalInformationDEAdditionalInformationV2.miscellaneous.previous_rating != null) {
                        companyReportFull.Previous_Rating_Max_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.previous_rating.max_value;
                        companyReportFull.Previous_Rating_Min_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.previous_rating.min_value;
                        companyReportFull.Previous_Rating_Value__c = additionalInformationDEAdditionalInformationV2.miscellaneous.previous_rating.value;
                    }
                    companyReportFull.Premise_Type__c = additionalInformationDEAdditionalInformationV2.miscellaneous.premise_type;
                    companyReportFull.Small_Office__c = additionalInformationDEAdditionalInformationV2.miscellaneous.small_office;
                    companyReportFull.Fax_Number__c = additionalInformationDEAdditionalInformationV2.miscellaneous.fax_number;
                    companyReportFull.Company_Type__c = additionalInformationDEAdditionalInformationV2.miscellaneous.company_type;
                    companyReportFull.DE_Negative_Rating__c = getInteger(additionalInformationDEAdditionalInformationV2.miscellaneous.negative_rating);
                    companyReportFull.Complementary_Company__c = additionalInformationDEAdditionalInformationV2.miscellaneous.complementary_company;
                    companyReportFull.Business_Purpose__c = additionalInformationDEAdditionalInformationV2.miscellaneous.business_purpose;
                }

                if (additionalInformationDEAdditionalInformationV2.image_accounts != null) {
                    companyReportFull.Image_Account_Serial_Number__c = additionalInformationDEAdditionalInformationV2.image_accounts.serial_number;
                    companyReportFull.Image_Account_Document_Type__c = additionalInformationDEAdditionalInformationV2.image_accounts.document_type;
                    companyReportFull.Image_Account_End_Date__c = getDate(additionalInformationDEAdditionalInformationV2.image_accounts.end_date);
                    companyReportFull.Image_Account_Financials_Type__c = additionalInformationDEAdditionalInformationV2.image_accounts.financials_type;
                    companyReportFull.Image_Account_Published_Date__c = getDate(additionalInformationDEAdditionalInformationV2.image_accounts.published_date);
                    companyReportFull.Image_Account_Start_Date__c = getDate(additionalInformationDEAdditionalInformationV2.image_accounts.start_date);
                }

                if (additionalInformationDEAdditionalInformationV2.beneficiary_owners != null) {
                    companyReportFull.Beneficiary_Owners_Name__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.name;
                    companyReportFull.Beneficiary_Owners_City__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.city;
                    companyReportFull.Beneficiary_Owners_Postal_Code__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.postal_code;
                    companyReportFull.Beneficiary_Owners_Country__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.country;
                    companyReportFull.Beneficiary_Owners_Share_Percent__c = additionalInformationDEAdditionalInformationV2.beneficiary_owners.share_percent;
                }

                if (additionalInformationDEAdditionalInformationV2.turnover_ranges != null) {
                    companyReportFull.Turnover_Range_Year__c = String.valueOf(additionalInformationDEAdditionalInformationV2.turnover_ranges.year);
                    companyReportFull.Turnover_Ranges__c = additionalInformationDEAdditionalInformationV2.turnover_ranges.range;
                }

                if (additionalInformationDEAdditionalInformationV2.comments != null && additionalInformationDEAdditionalInformationV2.comments.item != null) {
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 : additionalInformationDEAdditionalInformationV2.comments.item) {
                        Creditsafe_Comp_Additional_Info_Comment__c additionalInfoComment = new Creditsafe_Comp_Additional_Info_Comment__c();
                        additionalInfoComment.Text__c = commentV2.text;
                        additionalInfoComment.Sentiment__c = commentV2.sentiment;
                        additionalInfoComment.Type__c = 'DE_Comments';
                        //additionalInfoComment.Creditsafe_Company_Additional_Info_DE__c = additionalInfoDE.Id;
                        unitOfWork.registerNew(additionalInfoComment, Creditsafe_Comp_Additional_Info_Comment__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                    }
                }

                if (additionalInformationDEAdditionalInformationV2.historical_events != null && additionalInformationDEAdditionalInformationV2.historical_events.item != null) {
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 : additionalInformationDEAdditionalInformationV2.historical_events.item) {
                        Additional_Information_Historical_Event__c additionalInformationHistoricalEvent = new Additional_Information_Historical_Event__c();
                        additionalInformationHistoricalEvent.Date__c = getDate(historicalEventV2.date_x);
                        additionalInformationHistoricalEvent.Description__c = historicalEventV2.description;
                        additionalInformationHistoricalEvent.Previous_Value__c = historicalEventV2.previous_value;
                        additionalInformationHistoricalEvent.Current_Value__c = historicalEventV2.current_value;
                        additionalInformationHistoricalEvent.Type__c = 'DE_Historical_Event';
                        unitOfWork.registerNew(additionalInformationHistoricalEvent, Additional_Information_Historical_Event__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                    }
                }
            }

            if (reportFullV2.additional_information.nl != null) {

                CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLAdditionalInformationV2 additionalInformationNLAdditionalInformationV2 = reportFullV2.additional_information.nl;
                if (additionalInformationNLAdditionalInformationV2.payment_expectations_summary != null) {
                    companyReportFull.Suspension_Of_Payments_Mora__c = additionalInformationNLAdditionalInformationV2.payment_expectations_summary.suspension_of_payments_mora;
                    companyReportFull.Payment_Expectation_Days__c = additionalInformationNLAdditionalInformationV2.payment_expectations_summary.payment_expectation_days;
                    companyReportFull.Day_Sales_Outstanding__c = additionalInformationNLAdditionalInformationV2.payment_expectations_summary.day_sales_outstanding;
                    companyReportFull.Industry_Average_Payment_Expectation_Day__c = additionalInformationNLAdditionalInformationV2.payment_expectations_summary.industry_average_payment_expectation_days;
                    companyReportFull.Industry_Average_Day_Sales_Outstanding__c = additionalInformationNLAdditionalInformationV2.payment_expectations_summary.industry_average_day_sales_outstanding;
                }

                if (additionalInformationNLAdditionalInformationV2.miscellaneous != null) {
                    companyReportFull.Date_Of_Legal_Form__c = getDate(additionalInformationNLAdditionalInformationV2.miscellaneous.date_of_legal_form);
                    companyReportFull.Date_Of_Cessation_Trading__c = getDate(additionalInformationNLAdditionalInformationV2.miscellaneous.date_of_cessation_trading);
                    companyReportFull.Exporter__c = additionalInformationNLAdditionalInformationV2.miscellaneous.exporter ;
                    companyReportFull.Importer__c = additionalInformationNLAdditionalInformationV2.miscellaneous.importer;
                    companyReportFull.Rsin_Number__c = additionalInformationNLAdditionalInformationV2.miscellaneous.rsin_number;
                    companyReportFull.Branch_Number__c = additionalInformationNLAdditionalInformationV2.miscellaneous.branch_number;
                    companyReportFull.NL_Negative_Rating__c = additionalInformationNLAdditionalInformationV2.miscellaneous.negative_rating;
                }

                if (additionalInformationNLAdditionalInformationV2.industy_comparison != null) {
                    companyReportFull.Industry_Average_Credit_Limit__c = additionalInformationNLAdditionalInformationV2.industy_comparison.industry_average_credit_limit;
                    companyReportFull.Industry_Average_Credit_Rating__c = additionalInformationNLAdditionalInformationV2.industy_comparison.industry_average_credit_rating;
                }

                if (additionalInformationNLAdditionalInformationV2.industry_quartile_analysis != null) {
                    if (additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.payment_expectation_days != null) {
                        companyReportFull.Payment_Expectation_Days_Lower__c = additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.payment_expectation_days.lower;
                        companyReportFull.Payment_Expectation_Days_Median__c = additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.payment_expectation_days.median;
                        companyReportFull.Payment_Expectation_Days_Upper__c = additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.payment_expectation_days.upper;
                    }

                    if (additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.day_sales_outstanding != null) {
                        companyReportFull.Day_Sales_Outstanding_Lower__c = additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.day_sales_outstanding.lower;
                        companyReportFull.Day_Sales_Outstanding_Median__c = additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.day_sales_outstanding.median;
                        companyReportFull.Day_Sales_Outstanding_Upper__c = additionalInformationNLAdditionalInformationV2.industry_quartile_analysis.day_sales_outstanding.upper;
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.financial_items != null && additionalInformationNLAdditionalInformationV2.financial_items.item != null) {
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2 financialItemV2 :additionalInformationNLAdditionalInformationV2.financial_items.item) {
                        Additional_Information_NL_Financial_Item__c additionalInformationNLFinancialItem = new Additional_Information_NL_Financial_Item__c();
                        additionalInformationNLFinancialItem.Date_Year_End__c = getDate(financialItemV2.date_year_end);
                        additionalInformationNLFinancialItem.Judgement__c = financialItemV2.judgement;
                        additionalInformationNLFinancialItem.Consolidated_Subsidiaries__c = financialItemV2.consolidated_subsidiaries;
                        //additionalInformationNLFinancialItem.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                        unitOfWork.registerNew(additionalInformationNLFinancialItem, Additional_Information_NL_Financial_Item__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.kvk_filings != null && additionalInformationNLAdditionalInformationV2.kvk_filings.item != null) {
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2 kvkFilingV2 : additionalInformationNLAdditionalInformationV2.kvk_filings.item) {
                        Additional_Information_NL_Kvk_Filing__c additionalInformationNLKvkFiling = new Additional_Information_NL_Kvk_Filing__c();
                        additionalInformationNLKvkFiling.Date__c = getDate(kvkFilingV2.date_x);
                        additionalInformationNLKvkFiling.Event__c = kvkFilingV2.event;
                        //additionalInformationNLKvkFiling.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                        unitOfWork.registerNew(additionalInformationNLKvkFiling, Additional_Information_NL_Kvk_Filing__c.Creditsafe_Company_Report_Full__c, companyReportFull);
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
                        unitOfWork.registerNew(additionalInfoNLLetterOfLiability, Additional_Info_NL_Letter_Of_Liability__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.comments != null && additionalInformationNLAdditionalInformationV2.comments.item != null) {
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 : additionalInformationNLAdditionalInformationV2.comments.item) {
                        Creditsafe_Comp_Additional_Info_Comment__c additionalInfoComment = new Creditsafe_Comp_Additional_Info_Comment__c();
                        additionalInfoComment.Text__c = commentV2.text;
                        additionalInfoComment.Sentiment__c = commentV2.sentiment;
                        additionalInfoComment.Type__c = 'NL_Comments';
                        //additionalInfoComment.Creditsafe_Company_Additional_Info_NL__c = additionalInfoNL.Id;
                        unitOfWork.registerNew(additionalInfoComment, Creditsafe_Comp_Additional_Info_Comment__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                    }
                }

                if (additionalInformationNLAdditionalInformationV2.historical_events != null && additionalInformationNLAdditionalInformationV2.historical_events.item != null) {
                    for (CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 : additionalInformationNLAdditionalInformationV2.historical_events.item) {
                        Additional_Information_Historical_Event__c additionalInformationHistoricalEvent = new Additional_Information_Historical_Event__c();
                        additionalInformationHistoricalEvent.Date__c = getDate(historicalEventV2.date_x);
                        additionalInformationHistoricalEvent.Description__c = historicalEventV2.description;
                        additionalInformationHistoricalEvent.Previous_Value__c = historicalEventV2.previous_value;
                        additionalInformationHistoricalEvent.Current_Value__c = historicalEventV2.current_value;
                        additionalInformationHistoricalEvent.Type__c = 'NL_Historical_Event';
                        unitOfWork.registerNew(additionalInformationHistoricalEvent, Additional_Information_Historical_Event__c.Creditsafe_Company_Report_Full__c, companyReportFull);
                    }
                }
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
        }

        return companyReportFull;
    }

    private Creditsafe_Company__c mapCreditsafeCompany(Creditsafe_Company__c creditsafeCompany, CreditsafeWsdl.CreditsafeCompanyCompanyV2 creditsafeCompanyV2, String type) {
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
        creditsafeCompany.Company_Type__c = type;

        return creditsafeCompany;

    }

    private Creditsafe_Company_Financial_Statement__c mapFinancialStatement(CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 financialStatementV2, Creditsafe_Company_Financial_Statement__c financialStatement) {
        if (financialStatementV2.balance_sheet != null) {
            financialStatement.Balance_Sheets_Consolidated_Accounts__c = financialStatementV2.balance_sheet.consolidated_accounts;
            financialStatement.Bank_Liabilities__c = financialStatementV2.balance_sheet.bank_liabilities;
            financialStatement.Bank_Liabilities_Due_After1year__c = financialStatementV2.balance_sheet.bank_liabilities_due_after1year;
            financialStatement.Called_Up_Share_Capital__c = financialStatementV2.balance_sheet.called_up_share_capital;
            financialStatement.Cash__c = financialStatementV2.balance_sheet.cash;
            financialStatement.Finished_Goods__c = financialStatementV2.balance_sheet.finished_goods;
            financialStatement.Goodwill__c = financialStatementV2.balance_sheet.goodwill;
            financialStatement.Group_Payables__c = financialStatementV2.balance_sheet.group_payables;
            financialStatement.Group_Payables_Due_After1year__c = financialStatementV2.balance_sheet.group_payables_due_after1year;
            financialStatement.Group_Receivables__c = financialStatementV2.balance_sheet.group_receivables;
            financialStatement.Investments__c = financialStatementV2.balance_sheet.investments;
            financialStatement.Land_And_Buildings__c = financialStatementV2.balance_sheet.land_and_buildings;
            financialStatement.Loans_To_Group__c = financialStatementV2.balance_sheet.loans_to_group;
            financialStatement.Miscellaneous_Fixed_Assets__c = financialStatementV2.balance_sheet.miscellaneous_fixed_assets;
            financialStatement.Miscellaneous_Liabilities__c = financialStatementV2.balance_sheet.miscellaneous_liabilities;
            financialStatement.Miscellaneous_Liabilities_Due_After1year__c = financialStatementV2.balance_sheet.miscellaneous_liabilities_due_after1_year;
            financialStatement.Miscellaneous_Receivables__c = financialStatementV2.balance_sheet.miscellaneous_receivables;
            financialStatement.Other_Current_Assets__c = financialStatementV2.balance_sheet.other_current_assets;
            financialStatement.Other_Intangible_Assets__c = financialStatementV2.balance_sheet.other_intangible_assets;
            financialStatement.Other_Inventories__c = financialStatementV2.balance_sheet.other_inventories;
            financialStatement.Other_Loans__c = financialStatementV2.balance_sheet.other_loans;
            financialStatement.Other_Loans_Or_Finance__c = financialStatementV2.balance_sheet.other_loans_or_finance;
            financialStatement.Other_Loans_Or_Finance_Due_After1year__c = financialStatementV2.balance_sheet.other_loans_or_finance_due_after1_year;
            financialStatement.Other_Reserves__c = financialStatementV2.balance_sheet.other_reserves;
            financialStatement.Other_Tangible_Assets__c = financialStatementV2.balance_sheet.other_tangible_assets;
            financialStatement.Plant_And_Machinery__c = financialStatementV2.balance_sheet.plant_and_machinery;
            financialStatement.Raw_Materials__c = financialStatementV2.balance_sheet.raw_materials;
            financialStatement.Receivables_Due_After1year__c = financialStatementV2.balance_sheet.receivables_due_after1year;
            financialStatement.Revenue_Reserves__c = financialStatementV2.balance_sheet.revenue_reserves;
            financialStatement.Share_Premium__c = financialStatementV2.balance_sheet.share_premium;
            financialStatement.Total_Assets__c = financialStatementV2.balance_sheet.total_assets;
            financialStatement.Total_Current_Assets__c = financialStatementV2.balance_sheet.total_current_assets;
            financialStatement.Total_Current_Liabilities__c = financialStatementV2.balance_sheet.total_current_liabilities;
            financialStatement.Total_Fixed_Assets__c = financialStatementV2.balance_sheet.total_fixed_assets;
            financialStatement.Total_Liabilities__c = financialStatementV2.balance_sheet.total_liabilities;
            financialStatement.Total_Inventories__c = financialStatementV2.balance_sheet.total_inventories;
            financialStatement.Total_Intangible_Assets__c = financialStatementV2.balance_sheet.total_intangible_assets;
            financialStatement.Total_Long_Term_Liabilities__c = financialStatementV2.balance_sheet.total_long_term_liabilities;
            financialStatement.Total_Other_Fixed_Assets__c = financialStatementV2.balance_sheet.total_other_fixed_assets;
            financialStatement.Total_Receivables__c = financialStatementV2.balance_sheet.total_receivables;
            financialStatement.Total_Shareholders_Equity__c = financialStatementV2.balance_sheet.total_shareholders_equity;
            financialStatement.Total_Tangible_Assets__c = financialStatementV2.balance_sheet.total_tangible_assets;
            financialStatement.Trade_Payables__c = financialStatementV2.balance_sheet.trade_payables;
            financialStatement.Trade_Payables_Due_After1year__c = financialStatementV2.balance_sheet.trade_payables_due_after1year;
            financialStatement.Trade_Receivables__c = financialStatementV2.balance_sheet.trade_receivables;
            financialStatement.Work_In_Progress__c = financialStatementV2.balance_sheet.work_in_progress;
        }
        financialStatement.Consolidated_Accounts__c = financialStatementV2.consolidated_accounts != null ? financialStatementV2.consolidated_accounts : false;
        financialStatement.Currency__c = financialStatementV2.currency_x;
        financialStatement.Number_Of_Weeks__c = financialStatementV2.number_of_weeks;
        financialStatement.Net_Worth__c = financialStatementV2.other_financials != null ? financialStatementV2.other_financials.net_worth : null;
        financialStatement.Working_Capital__c = financialStatementV2.other_financials != null ? financialStatementV2.other_financials.working_capital : null;
        if(financialStatementV2.profit_and_loss != null) {
            financialStatement.Depreciation__c = financialStatementV2.profit_and_loss.depreciation;
            financialStatement.Dividends__c = financialStatementV2.profit_and_loss.dividends;
            financialStatement.Financial_Expenses__c = financialStatementV2.profit_and_loss.financial_expenses;
            financialStatement.Financial_Income__c = financialStatementV2.profit_and_loss.financial_income;
            financialStatement.Operating_Costs__c = financialStatementV2.profit_and_loss.operating_costs;
            financialStatement.Operating_Profit__c = financialStatementV2.profit_and_loss.operating_profit;
            financialStatement.Other_Appropriations__c = financialStatementV2.profit_and_loss.other_appropriations;
            financialStatement.Pension_Costs__c = financialStatementV2.profit_and_loss.pension_costs;
            financialStatement.Profit_After_Tax__c = financialStatementV2.profit_and_loss.profit_after_tax;
            financialStatement.Profit_Before_Tax__c = financialStatementV2.profit_and_loss.profit_before_tax;
            financialStatement.Retained_Profit__c = financialStatementV2.profit_and_loss.retained_profit;
            financialStatement.Revenue__c = financialStatementV2.profit_and_loss.revenue;
            financialStatement.Tax__c = financialStatementV2.profit_and_loss.tax;
            financialStatement.Wages_And_Salaries__c = financialStatementV2.profit_and_loss.wages_and_salaries;
        }
        if (financialStatementV2.ratios != null) {
            financialStatement.Creditor_Days__c = financialStatementV2.ratios.creditor_days;
            financialStatement.Current_Debt_Ratio__c = financialStatementV2.ratios.current_debt_ratio;
            financialStatement.Current_Ratio__c = financialStatementV2.ratios.current_ratio;
            financialStatement.Debtor_Days__c = financialStatementV2.ratios.debtor_days;
            financialStatement.Equity_In_Percentage__c = financialStatementV2.ratios.equity_in_percentage;
            financialStatement.Gearing__c = financialStatementV2.ratios.gearing;
            financialStatement.Liquidity_Ratio_Or_Acid_Test__c = financialStatementV2.ratios.liquidity_ratio_or_acid_test;
            financialStatement.Pre_Tax_Profit_Margin__c = financialStatementV2.ratios.pre_tax_profit_margin;
            financialStatement.Return_On_Capital_Employed__c = financialStatementV2.ratios.return_on_capital_employed;
            financialStatement.Return_On_Net_Assets_Employed__c = financialStatementV2.ratios.return_on_net_assets_employed;
            financialStatement.Return_On_Total_Assets_Employed__c = financialStatementV2.ratios.return_on_total_assets_employed;
            financialStatement.Sales_Or_Net_Working_Capital__c = financialStatementV2.ratios.sales_or_net_working_capital;
            financialStatement.Stock_Turnover_Ratio__c = financialStatementV2.ratios.stock_turnover_ratio;
            financialStatement.Total_Debt_Ratio__c = financialStatementV2.ratios.total_debt_ratio;
        }
        financialStatement.Type__c = financialStatementV2.type_x;
        financialStatement.Year_End_Date__c = getDate(financialStatementV2.year_end_date);

        return financialStatement;
    }

    public Creditsafe_Address__c mapCreditSafeAddress(CreditsafeWsdl.CreditsafeAddressV2 dataVendorDossier, Creditsafe_Address__c addressDB, String type) {
        //addressDB.Name = dataVendorDossier.street != null ? dataVendorDossier.street.abbreviate(79) : '';
        addressDB.Full_Address__c = dataVendorDossier.full_address;
        addressDB.Postcode__c = dataVendorDossier.postal_code;
        addressDB.Street__c = dataVendorDossier.street;
        addressDB.City__c = dataVendorDossier.city;
        addressDB.House_Number__c = dataVendorDossier.house_number;
        addressDB.Country__c = dataVendorDossier.country;
        addressDB.Telephone__c = dataVendorDossier.telephone;
        addressDB.Type__c = type;

        return addressDB;
    }


    private Date getDate(Datetime dateTimeObject) {
        return dateTimeObject != null ? Date.newInstance(dateTimeObject.year(), dateTimeObject.month(), dateTimeObject.day()) : null;
    }

    private Integer getInteger(String value) {
        return value != null ? Integer.valueOf(value) : null;
    }



}