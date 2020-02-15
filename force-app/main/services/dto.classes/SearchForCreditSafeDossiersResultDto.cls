/**
 * Created by jaapbranderhorst on 15/02/2020.
 */

public with sharing class SearchForCreditSafeDossiersResultDto {

    public String creditsafe_number;
    public Datetime date_last_account;
    public Datetime date_last_change;
    public List<String> trade_names;
    public String trade_name {
        get {
            if (trade_names != null && trade_names.size() >= 1) {
                return trade_names[0];
            } else {
                return '';
            }
        }
    }
    public String[] vat_numbers;
    public String vat_number {
        get {
            if (vat_numbers != null && vat_numbers.size() >= 1) {
                return vat_numbers[0];
            } else {
                return '';
            }
        }
    }
    public String address_country;
    public String registration_number;
    public String name;
    public String id;
    public String type;
    public String status;
    public String office_type;
    public String city;
    public String country;
    public String full_address;
    public String house_number;
    public String postal_code;
    public String street;
    public String telephone;

    public SearchForCreditSafeDossiersResultDto(CreditsafeWsdl.CreditsafeCompanyV2 searchResultV2) {
        this.creditsafe_number = searchResultV2.creditsafe_number;
        this.date_last_account = searchResultV2.date_last_account;
        this.date_last_change = searchResultV2.date_last_change;
        this.trade_names = searchResultV2.trade_names != null ? searchResultV2.trade_names.item : null;
        this.vat_numbers = searchResultV2.vat_numbers != null ? searchResultV2.vat_numbers.item : null;
        this.country = searchResultV2.country;
        this.registration_number = searchResultV2.registration_number;
        this.name = searchResultV2.name;
        this.id = searchResultV2.id;
        this.type = searchResultV2.type_x;
        this.status = searchResultV2.status;
        this.office_type = searchResultV2.office_type;
        this.street = searchResultV2.address != null ? searchResultV2.address.street : null;
        this.telephone = searchResultV2.address != null ? searchResultV2.address.telephone : null;
        this.postal_code = searchResultV2.address != null ? searchResultV2.address.postal_code : null;
        this.house_number = searchResultV2.address != null ? searchResultV2.address.house_number : null;
        this.city = searchResultV2.address != null ? searchResultV2.address.city : null;
        this.address_country = searchResultV2.address != null ? searchResultV2.address.country : null;
        this.full_address = searchResultV2.address != null ? searchResultV2.address.full_address : null;
    }

}