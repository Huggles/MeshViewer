/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public with sharing class CreditSafeServiceImpl implements ICreditSafeService {

    

    //  CreditsafeWsdl.CreditsafeSearchResultV2 creditsafeSearchV2(CreditsafeWsdl.stringArray countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {

    // reuse the searchresultdossierdto??
    public List<SearchForDossiersResultDto> searchForCreditSafeDossiers(List<String> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        if (countries == null || countries.isEmpty()) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }

        return null;
    }

}