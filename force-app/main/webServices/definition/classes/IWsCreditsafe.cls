/**
 * Created by jaapbranderhorst on 2019-07-03.
 *
 * See https://webview.webservices.nl/documentation/files/service_creditsafe-php.html#Creditsafe
 */

public interface IWsCreditsafe {

   // CreditsafeWsdl.CreditsafeCompanyUpdatePagedResult creditsafeMonitorGetUpdatedCompanies(Date changed_since,Integer page_x) ;
    CreditsafeWsdl.CreditsafeSearchResultV2 creditsafeSearchV2(CreditsafeWsdl.stringArray countries,String id,String status,String registration_number,String registration_type,String vat_number,String province,String city,String street,String postal_code,String name);
  //  CreditsafeWsdl.CreditsafeSearchCriteria creditsafeSearchCriteria(CreditsafeWsdl.stringArray countries);
//    CreditsafeWsdl.CreditsafeCompanyReportFullV2 creditsafeGetReportFullV2(String company_id,String language,String reason);
//    void creditsafeMonitorAddCompany(String company_id);
//    CreditsafeWsdl.CreditsafeCompanyReportFull creditsafeGetReportFull(String company_id,String language,String document);
//    void creditsafeMonitorRemoveCompany(String company_id);

}