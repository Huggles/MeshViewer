/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public inherited sharing class CreditSafeServiceImpl implements ICreditSafeService {



    //  CreditsafeWsdl.CreditsafeSearchResultV2 creditsafeSearchV2(CreditsafeWsdl.stringArray countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {

    // reuse the searchresultdossierdto??
    public List<SearchForCreditSafeDossiersResultDto> searchForCreditSafeDossiers(List<CreditSafe.Country> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        // check the input
        if (countries == null || countries.isEmpty()) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }
        // no checks needed so commented
        // TODO: extend the checks so that per country only relevant patterns can be searched
        List<SearchForCreditSafeDossiersResultDto> resultValue = new List<SearchForCreditSafeDossiersResultDto>();
        CreditsafeWsdl.stringArray creditSafeCountries = new CreditsafeWsdl.stringArray();
        creditSafeCountries.item = new List<String>();
        for (CreditSafe.Country country : countries) {
            creditSafeCountries.item.add(country.name());
        }

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResult = WsCreditsafe.creditsafeSearchV2(creditSafeCountries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
        for (CreditsafeWsdl.CreditsafeCompanyV2 company : searchResult.companies.item) {
            resultValue.add(new SearchForCreditSafeDossiersResultDto(company));
        }
        return resultValue;
    }



//    public List<SearchForDossiersResultDto> searchForCreditSafeDossiers(List<CreditSafe.Country> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
//        // check the input
//        if (countries == null || countries.isEmpty()) {
//            throw new CCInputException(Label.Error_Input_Incorrect);
//        }
//        // no checks needed so commented
//        // TODO: extend the checks so that per country only relevant patterns can be searched
//        List<SearchForDossiersResultDto> resultValue = new List<SearchForDossiersResultDto>();
//        CreditsafeWsdl.stringArray creditSafeCountries = new CreditsafeWsdl.stringArray();
//        creditSafeCountries.item = new List<String>();
//        for (CreditSafe.Country country : countries) {
//            creditSafeCountries.item.add(country.name());
//        }
//
//        CreditsafeWsdl.CreditsafeSearchResultV2 searchResult = WsCreditsafe.creditsafeSearchV2(creditSafeCountries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
//        for (CreditsafeWsdl.CreditsafeCompanyV2 company : searchResult.companies.item) {
//            resultValue.add(new SearchForDossiersResultDto(company));
//        }
//        return resultValue;
//    }

}