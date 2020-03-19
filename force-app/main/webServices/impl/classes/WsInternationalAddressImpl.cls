/**
* Created by appsolutely on 2020-02-12.
*/

public inherited sharing class WsInternationalAddressImpl implements IWsInternationalAddress {

    private inherited sharing class InternationalAddressMethodCallout extends MethodCallout {

        public InternationalAddressMethodCallout(InternationalAddressWsdl.Webservices_nlPort port) {
            super(port);
        }

        public Object call(String methodName, Map<String, object> arguments){

            InternationalAddressWsdl.Webservices_NLPort port = (InternationalAddressWsdl.Webservices_nlPort)this.port;

            switch on methodName {
                when 'internationalAddressSearchV2' {
                    return port.internationalAddressSearchV2(
                            (String)arguments.get('organization'),
                            (String)arguments.get('building'),
                            (String)arguments.get('street'),
                            (String)arguments.get('housenr'),
                            (String)arguments.get('pobox'),
                            (String)arguments.get('locality'),
                            (String)arguments.get('postcode'),
                            (String)arguments.get('province'),
                            (String)arguments.get('country'),
                            (String)arguments.get('language'),
                            (String)arguments.get('country_format'));
                }
                when else {
                    throw new CCWsException('Method ' + methodName + ' not implemented');
                }
            }
        }


    }




    private InternationalAddressMethodCallout methodCallOut { get; set; }

    private InternationalAddressWsdl.Webservices_nlPort port { get; set; }

    public WsInternationalAddressImpl() {
        port = new InternationalAddressWsdl.Webservices_nlPort();
        port.HeaderLogin = new InternationalAddressWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
        methodCallOut = new InternationalAddressMethodCallOut(port);

    }

    public String login(String username,String password){
        return (String)methodCallOut.callOut('login', new Map<String, Object>{
                'username' => username,
                'password' => password
        });
    }

    public void logout(){
        methodCallOut.callOut('logout', new map<String, Object>{});
    }

    public InternationalAddressWSDL.InternationalAddressSearchV2Result internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format){
        return (InternationalAddressWSDL.InternationalAddressSearchV2Result) methodCallOut.callOut('internationalAddressSearchV2', new Map<String, Object>{
                'organization' => organization,
                'building' => building,
                'street' => street,
                'housenr' => housenr,
                'pobox' => pobox,
                'locality' => locality,
                'postcode' => postcode,
                'province' => province,
                'country' => country,
                'language' => language,
                'country_format' => country_format
        });
    }

}
