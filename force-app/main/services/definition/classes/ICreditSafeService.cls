/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public interface ICreditSafeService {

    List<SearchForCreditSafeDossiersResultDto> searchForCreditSafeDossiers(List<CreditSafe.Country> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name);

}