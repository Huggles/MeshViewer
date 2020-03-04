/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public interface ICreditSafeService {

    List<Business_Dossier__c> searchForCreditSafeDossiers(List<CreditSafe.Country> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name);
    Creditsafe_Company_Report_Full__c getCreditsafeReportFullV2(String company_id, String language, String reason);

}