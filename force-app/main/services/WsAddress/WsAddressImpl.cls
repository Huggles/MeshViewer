/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public inherited sharing class WsAddressImpl implements IWsAddress {

    private inherited sharing class AddressMethodCallOut extends MethodCallout {

        public AddressMethodCallOut(AddressWsdl.Webservices_nlPort port) {
            super(port);
        }

        public Object call(String methodName, Map<String, Object> arguments) {
            AddressWsdl.Webservices_nlPort port = (AddressWsdl.Webservices_nlPort) this.port;
            switch on methodName {
                when 'addressPerceelFullParameterSearchV2' {
                    return port.addressPerceelFullParameterSearchV2(
                            (String)arguments.get('province'),
                            (String)arguments.get('district'),
                            (String)arguments.get('city'),
                            (String)arguments.get('street'),
                            (Integer)arguments.get('houseNo'),
                            (String)arguments.get('houseNoAddition'),
                            (String)arguments.get('nbcode'),
                            (String)arguments.get('lettercombination'),
                            (String)arguments.get('addresstype'),
                            (Integer)arguments.get('page_x')
                    );
                }
                when else {
                    throw new CCWsException('Method ' + methodName + ' not implemented');
                }
            }
        }
    }

    private AddressWsdl.Webservices_nlPort port { get; set; }

    private AddressMethodCallOut methodCallOut { get; set; }

    public WsAddressImpl() {
        port = new AddressWsdl.Webservices_nlPort();
        port.HeaderLogin = new AddressWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
        methodCallOut = new AddressMethodCallOut(port);
    }

    public AddressWsdl.PerceelSearchPartsPagedResult addressPerceelFullParameterSearchV2(String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype,Integer page_x) {
        return (AddressWsdl.PerceelSearchPartsPagedResult)methodCallOut.callOut('addressPerceelFullParameterSearchV2', new Map<String, Object>{
                'province' => province,
                'district' => district,
                'city' => city,
                'street' => street,
                'houseNo' => houseNo,
                'houseNoAddition' => houseNoAddition,
                'nbcode' => nbcode,
                'lettercombination' => lettercombination,
                'addresstype' => addresstype,
                'page_x' => page_x
        });
    }
}