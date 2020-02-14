/**
* Created by appsolutely on 2020-02-12.
*/

public inherited sharing class WsInternationalAddressImpl implements IWsInternationalAddress {

    private inherited sharing class InternationalAddressMethodCallout extends MethodCallout{

        public object call(String methodName, Map<String, object> arguments){

            InternationalAddressWSDL.Webservices_NLPort port = (InternationalAddressWSDL.Webservices_nlPort)this.port;

            switch on methodName {
                    when 'login' {
                        return port.login((String)arguments.get('username'), (String)arguments.get('password'));
                    }
                    when else {
                        throw new CCWsException('Method ' + methodName + ' not implemented');
                    }
                }
               // return null;
            }

            public InternationalAddressMethodCallout(InternationalAddressWSDL.Webservices_nlPort port) {
                super(port);
            }
        }

        private InternationalAddressMethodCallout methodCallOut { get; set; }

        private InternationalAddressWsdl.Webservices_nlPort port { get; set; }

        public WsInternationalAddressImpl() {
            port =  new InternationalAddressWsdl.Webservices_nlPort();
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







}
