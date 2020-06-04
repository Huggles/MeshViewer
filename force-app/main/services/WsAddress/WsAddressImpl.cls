/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public inherited sharing class WsAddressImpl implements IWsAddress {

    private inherited sharing class DutchAddressMethodCallOut extends MethodCallout {

        public Object call(String methodName, Map<String, Object> arguments) {
            DutchAddressWsdl.Webservices_nlPort port = (DutchAddressWsdl.Webservices_nlPort) this.port;
            switch on methodName {
                when 'dutchAddressRangePostcodeSearch' {
                    return port.dutchAddressRangePostcodeSearch(
                            (String)arguments.get('address')
                    );
                }
                when else {
                    throw new CCWsException('Method ' + methodName + ' not implemented');
                }
            }
        }

        public DutchAddressMethodCallOut(DutchAddressWsdl.Webservices_nlPort port) {
            super(port);
        }
    }

    public WsAddressImpl(DutchAddressWsdl.Webservices_nlPort port) {

    }

    private DutchAddressWsdl.Webservices_nlPort port { get; set; }

    private DutchAddressMethodCallOut methodCallOut { get; set; }

    public WsAddressImpl() {
        port = new DutchAddressWsdl.Webservices_nlPort();
        port.HeaderLogin = new DutchAddressWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
        methodCallOut = new DutchAddressMethodCallOut(port);
    }

    public DutchAddressWsdl.DutchAddressPostcodeRange dutchAddressRangePostcodeSearch(String address) {
        return (DutchAddressWsdl.DutchAddressPostcodeRange)methodCallOut.callOut('dutchAddressRangePostcodeSearch', new Map<String, Object>{'address' => address});
    }
}