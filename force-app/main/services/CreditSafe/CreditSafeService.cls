/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public inherited sharing class CreditSafeService {

    public static List<Business_Dossier__c> searchForCreditSafeDossiers(List<String> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        return newInstance().searchForCreditSafeDossiers(countries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
    }

    public static Creditsafe_Company_Report_Full__c getCreditsafeReportFullV2(String company_id, String language, String reason) {
        return newInstance().getCreditsafeReportFullV2(company_id, language, reason);
    }

    public static ICreditSafeService newInstance() {
        return (ICreditSafeService)Application.Service.newInstance(ICreditSafeService.class);
    }

}