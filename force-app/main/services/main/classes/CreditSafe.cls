/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public with sharing class CreditSafe  {

    public static List<SearchForDossiersResultDto> searchForCreditSafeDossiers(List<String> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        return newInstance().searchForCreditSafeDossiers(countries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
    }

    public static ICreditSafeService newInstance() {
        return (ICreditSafeService)Application.Service.newInstance(ICreditSafeService.class);
    }

}