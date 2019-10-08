/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

public inherited sharing class WsCreditsafeImpl implements IWsCreditsafe {



    private class CreditSafeMethodCallOut extends MethodCallout {

        public Object call(String methodName, Map<String, Object> arguments) {
            CreditsafeWsdl.Webservices_nlPort port = (CreditsafeWsdl.Webservices_nlPort) this.port;
            switch on methodName {
                when 'creditsafeSearchV2' {
                    return port.creditsafeSearchV2(
                            (CreditsafeWsdl.stringArray)arguments.get('countries'),
                            (String)arguments.get('id'),
                            (String)arguments.get('status'),
                            (String)arguments.get('registration_number'),
                            (String)arguments.get('registration_type'),
                            (String)arguments.get('vat_number'),
                            (String)arguments.get('province'),
                            (String)arguments.get('city'),
                            (String)arguments.get('street'),
                            (String)arguments.get('postal_code'),
                            (String)arguments.get('name')
                    );

                }
                when else {
                    throw new CCWsException('Method ' + methodName + ' not implemented');
                }

            }
            // return null;
        }

        public CreditSafeMethodCallOut(CreditsafeWsdl.Webservices_nlPort port) {
            super(port);
        }
    }

    private CreditSafeMethodCallOut methodCallOut { get; set; }

    private CreditsafeWsdl.Webservices_nlPort port { get; set; }

    public WsCreditsafeImpl() {
        port =  new CreditsafeWsdl.Webservices_nlPort();
        port.HeaderLogin = new CreditsafeWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
        methodCallOut = new CreditSafeMethodCallOut(port);
    }

    public CreditsafeWsdl.CreditsafeSearchResultV2 creditsafeSearchV2(CreditsafeWsdl.stringArray countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        return (CreditsafeWsdl.CreditsafeSearchResultV2)methodCallOut.callOut('creditsafeSearchV2', new Map<String, Object>{
                'countries' => countries,
                'id' => id,
                'status' => status,
                'registration_number' => registration_number,
                'registration_type' => registration_type,
                'vat_number' => vat_number,
                'province' => province,
                'city' => city,
                'street' => street,
                'postal_code' => postal_code,
                'name' => name
        });
    }

}