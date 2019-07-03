/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public with sharing class WsCreditsafeImpl implements IWsCreditsafe {

    private CreditsafeWsdl.Webservices_nlPort port { get; set; }

    public WsCreditsafeImpl() {
        port =  new CreditsafeWsdl.Webservices_nlPort();
        port.HeaderLogin = new CreditsafeWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
    }

    public CreditsafeWsdl.CreditsafeSearchResultV2 creditsafeSearchV2(CreditsafeWsdl.stringArray countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        CreditsafeWsdl.CreditsafeSearchResultV2 returnValue = null;
        try {
            returnValue = port.creditsafeSearchV2(countries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.creditsafeSearchV2(countries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

}