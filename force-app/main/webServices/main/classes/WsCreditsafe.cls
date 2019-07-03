/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public with sharing class WsCreditsafe {

    public static CreditsafeWsdl.CreditsafeSearchResultV2 creditsafeSearchV2(CreditsafeWsdl.stringArray countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        return null;
    }

    public static IWsCreditsafe newInstance() {
        return (IWsCreditsafe)Application.Service.newInstance(IWsCreditsafe.class);
    }

}