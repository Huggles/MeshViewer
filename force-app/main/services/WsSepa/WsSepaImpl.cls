/**
 * Created by hugovankrimpen on 01/07/2020.
 */

public with sharing class WsSepaImpl implements IWsSepa{


    /*
     * Method Callout Implementation
     */
    private inherited sharing class SepaMethodCallOut extends MethodCallout {

        public SepaMethodCallOut(SepaWsdl.Webservices_nlPort port) {
            super(port);
        }
        public Object call(String methodName, Map<String, Object> arguments) {
            SepaWSDL.Webservices_nlPort port = (SepaWSDL.Webservices_nlPort) this.port;
            switch on methodName {
                when 'sepaMatchAccountHolder' {
                    return port.sepaMatchAccountHolder(
                            (String)arguments.get('iban'),
                            (String)arguments.get('name')
                    );
                }
                when else {
                    throw new CCWsException('Method ' + methodName + ' not implemented');
                }
            }
        }
    }

    /*
     * Callout initiation
     */
    private SepaWsdl.Webservices_nlPort port { get; set; }

    private SepaMethodCallOut methodCallOut { get; set; }

    public WsSepaImpl() {
        port = new SepaWsdl.Webservices_nlPort();
        port.HeaderLogin = new SepaWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
        methodCallOut = new SepaMethodCallOut(port);
    }


    /*
     * Callout functions
     */

    public SepaWsdl.SepaMatchAccountHolderResult sepaMatchAccountHolder(String IBAN,String accountHolderName){
        Map<String, Object> payload  = new Map<String, Object>();
        payload.put('iban', IBAN);
        payload.put('name', accountHolderName);
        return (SepaWsdl.SepaMatchAccountHolderResult)methodCallOut.callOut('sepaMatchAccountHolder',payload);
    }
}