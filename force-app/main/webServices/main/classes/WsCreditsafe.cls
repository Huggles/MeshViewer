/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public inherited sharing class WsCreditsafe {

    public static IWsCreditsafe newInstance() {
        return (IWsCreditsafe)Application.Service.newInstance(IWsCreditsafe.class);
    }

    public static CreditsafeWsdl.CreditsafeSearchResultV2 creditsafeSearchV2(CreditsafeWsdl.stringArray countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        return newInstance().creditsafeSearchV2(countries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
    }

    public static CreditsafeWsdl.CreditsafeCompanyReportFullV2 creditsafeGetReportFullV2(String company_id, String language, String reason){
        return newInstance().creditsafeGetReportFullV2(company_id, language, reason);
    }

}