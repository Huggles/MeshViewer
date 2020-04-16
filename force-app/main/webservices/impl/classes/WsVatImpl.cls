/**
 * Created by jaapbranderhorst on 04/04/2020.
 */

public inherited sharing class WsVatImpl implements IWsVat {

    private inherited sharing class WsVatCallout extends MethodCallout {

        public WsVatCallout(VatWsdl.Webservices_nlPort port) {
            super(port);
        }

        public Object call(String methodName, Map<String, object> arguments) {
            VatWsdl.Webservices_NLPort port = (VatWsdl.Webservices_nlPort) this.port;

            switch on methodName {
                when 'vatValidate' {
                    return port.vatValidate((String) arguments.get('vat_number'));

                }
                when 'vatViesProxyCheckVat' {
                    return port.vatViesProxyCheckVat((String) arguments.get('vat_number'));
                }
                when else {
                    throw new CCWsException('Method ' + methodName + ' not implemented');
                }
            }
        }
    }

    private WsVatCallout methodCallOut { get; set; }

    private VatWsdl.Webservices_nlPort port { get; set; }

    public WsVatImpl() {
        port = new VatWsdl.Webservices_nlPort();
        port.HeaderLogin = new VatWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
        methodCallOut = new WsVatCallout(port);
    }

    public VatWsdl.VatValidation vatValidate(String vat_number) {
        return (VatWsdl.VatValidation)methodCallOut.callOut('vatValidate', new Map<String, Object>{'vat_number' => vat_number});
    }

    public VatWsdl.VatProxyViesCheckVatResponse vatViesProxyCheckVat(String vat_number) {
        return (VatWsdl.VatProxyViesCheckVatResponse)methodCallOut.callOut('vatViesProxyCheckVat', new Map<String, Object>{'vat_number' => vat_number});
    }

}