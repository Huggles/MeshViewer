/**
 * Created by jaapbranderhorst on 2019-06-30.
 */

public inherited sharing class WsDutchBusinessImpl implements IWsDutchBusiness {

    private inherited sharing class DutchBusinessMethodCallOut extends MethodCallout {

        public Object call(String methodName, Map<String, Object> arguments) {
            System.debug('methodsName: ' + methodName);
            System.debug('arguments: ' + JSON.serializePretty(arguments));
            DutchBusinessWsdl.Webservices_nlPort port = (DutchBusinessWsdl.Webservices_nlPort) this.port;
            switch on methodName {
                when 'dutchBusinessSearch' {
                    return port.dutchBusinessSearch(
                            (String)arguments.get('dossier_number'),
                            (String)arguments.get('trade_name'),
                            (String)arguments.get('city'),
                            (String)arguments.get('street'),
                            (String)arguments.get('postcode'),
                            (Integer)arguments.get('house_number'),
                            (String)arguments.get('house_number_addition'),
                            (String)arguments.get('telephone_number'),
                            (String)arguments.get('domain_name'),
                            (Boolean)arguments.get('strict_search'),
                            (Integer)arguments.get('page_x')
                    );

                }
                when 'dutchBusinessGetVatNumber' {
                    return port.dutchBusinessGetVatNumber(
                            (String)arguments.get('dossier_number')
                    );
                }
                when 'dutchBusinessSearchParametersV2' {
                    return port.dutchBusinessSearchParametersV2(
                            (String)arguments.get('trade_name'),
                            (String)arguments.get('city'),
                            (String)arguments.get('street'),
                            (String)arguments.get('postcode'),
                            (Integer)arguments.get('house_number'),
                            (String)arguments.get('house_number_addition'),
                            (String)arguments.get('telephone_number'),
                            (String)arguments.get('domain_name'),
                            (Boolean)arguments.get('strict_search'),
                            (Integer)arguments.get('page_x')
                    );

                }
                when 'dutchBusinessGetDossierV3' {
                    return port.dutchBusinessGetDossierV3(
                            (String)arguments.get('dossier_number'),
                            (String)arguments.get('establishment_number')
                    );
                }
                when 'dutchBusinessUpdateGetChangedDossiers' {
                    return port.dutchBusinessUpdateGetChangedDossiers(
                            (Date)arguments.get('changed_since'),
                            (DutchBusinessWsdl.stringArray)arguments.get('update_types'),
                            (Integer)arguments.get('page_x')
                    );
                }
                when 'dutchBusinessUpdateRemoveDossier' {
                    port.dutchBusinessUpdateRemoveDossier(
                            (String)arguments.get('dossier_number'),
                            (String)arguments.get('establishment_number')
                    );
                    return null;
                }
                when else {
                    throw new CCWsException('Method ' + methodName + ' not implemented');
                }

            }
            // return null;
        }

        public DutchBusinessMethodCallOut(DutchBusinessWsdl.Webservices_nlPort port) {
            super(port);
        }
    }

    private DutchBusinessWsdl.Webservices_nlPort port { get; set; }

    private DutchBusinessMethodCallOut methodCallOut { get; set; }

    public WsDutchBusinessImpl() {
        port = new DutchBusinessWsdl.Webservices_nlPort();
        port.HeaderLogin = new DutchBusinessWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
        methodCallOut = new DutchBusinessMethodCallOut(port);
    }

    public DutchBusinessWsdl.DutchBusinessVatNumber dutchBusinessGetVatNumber(String dossier_number) {
        return (DutchBusinessWsdl.DutchBusinessVatNumber)methodCallOut.callOut('dutchBusinessGetVatNumber', new Map<String, Object>{'dossier_number' => dossier_number});
    }

    public DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult dutchBusinessSearch(String dossier_number, String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search, Integer page_x) {
        return (DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult)methodCallOut.callOut('dutchBusinessSearch', new Map<String, Object>{
                'dossier_number' => dossier_number,
                'trade_name' => trade_name,
                'city' => city,
                'street' => street,
                'postcode' => postcode,
                'house_number' => house_number,
                'house_number_addition' => house_number_addition,
                'telephone_number' => telephone_number,
                'domain_name' => domain_name,
                'strict_search' => strict_search,
                'page_x' => page_x
        });
    }


    public DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult dutchBusinessSearchParametersV2(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search, Integer page_x) {
        return (DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult)methodCallOut.callOut('dutchBusinessSearchParametersV2', new Map<String, Object>{
                'trade_name' => trade_name,
                'city' => city,
                'street' => street,
                'postcode' => postcode,
                'house_number' => house_number,
                'house_number_addition' => house_number_addition,
                'telephone_number' => telephone_number,
                'domain_name' => domain_name,
                'strict_search' => strict_search,
                'page_x' => page_x
        });
    }

    public DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessGetDossierV3(String dossier_number, String establishment_number) {
        return (DutchBusinessWsdl.DutchBusinessDossierV3)methodCallOut.callOut('dutchBusinessGetDossierV3', new Map<String, Object>{
                'dossier_number' => dossier_number,
                'establishment_number' => establishment_number
        });
    }

    public DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult dutchBusinessUpdateGetChangedDossiers(Date changed_since, DutchBusinessWsdl.stringArray update_types, Integer page_x) {
        return (DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult)methodCallOut.callOut('dutchBusinessUpdateGetChangedDossiers', new Map<String, Object>{
                'changed_since' => changed_since,
                'update_types' => update_types,
                'page_x' => page_x
        });
    }

    public void dutchBusinessUpdateRemoveDossier(String dossier_number,String establishment_number) {
        methodCallOut.callOut('dutchBusinessUpdateRemoveDossier', new Map<String, Object>{
                'dossier_number' => dossier_number,
                'establishment_number' => establishment_number
        });
    }

}