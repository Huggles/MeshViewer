public class WebServicesNLSOAPDutchBusinessImpl extends WebServicesNLSOAPDutchBusinessImplTypes implements IWebServicesNLSOAPDutchBusiness {
    
public WebServicesNLSOAPDutchBusinessImpl(){
        super();
}
    
    
    public DutchBusinessDto dutchBusinessGetDossierV3(String dossier_number,String establishment_number){
        

        dutchBusinessGetDossierV3RequestType request_x = new dutchBusinessGetDossierV3RequestType();
        dutchBusinessGetDossierV3ResponseType response_x;
        request_x.dossier_number = dossier_number;
        request_x.establishment_number = establishment_number;
        Map<String, dutchBusinessGetDossierV3ResponseType> response_map_x = new Map<String, dutchBusinessGetDossierV3ResponseType>();
        response_map_x.put('response_x', response_x);

        WebServiceCallout.invoke(
                port,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                        'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessGetDossierV3',
                        'http://www.webservices.nl/soap/',
                        'dutchBusinessGetDossierV3',
                        'http://www.webservices.nl/soap/',
                        'dutchBusinessGetDossierV3Response',
                        'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessGetDossierV3ResponseType'} // NB!!! The type file name should be prepended to the ws method name
        );
        response_x = response_map_x.get('response_x');
        DutchBusinessDto r = new DutchBusinessDto();
        r.DutchBusinessDossierV3 = response_x.out;
        return  r;
    }

        public DutchBusinessDto dutchBusinessSearchParametersV2(String trade_name,String city,String street,String postcode,Integer house_number,String house_number_addition,String telephone_number,String domain_name,Boolean strict_search,Integer page) {
            
            dutchBusinessSearchParametersV2RequestType request_x = new dutchBusinessSearchParametersV2RequestType();
            dutchBusinessSearchParametersV2ResponseType response_x;
            request_x.trade_name = trade_name;
            request_x.city = city;
            request_x.street = street;
            request_x.postcode = postcode;
            request_x.house_number = house_number;
            request_x.house_number_addition = house_number_addition;
            request_x.telephone_number = telephone_number;
            request_x.domain_name = domain_name;
            request_x.strict_search = strict_search;
            request_x.page = page;
            Map<String, dutchBusinessSearchParametersV2ResponseType> response_map_x = new Map<String, dutchBusinessSearchParametersV2ResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessSearchParametersV2',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchParametersV2',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchParametersV2Response',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchParametersV2ResponseType'}
            );
            response_x = response_map_x.get('response_x');
            DutchBusinessDto result = new DutchBusinessDto();
            result.DutchBusinessReferenceV2PagedResult = response_x.out;
            return result;
        }

//________________________*****************************************************___________________________________________________
        public DutchBusinessLegalEntityData dutchBusinessGetLegalEntity(String dossier_number) {
            dutchBusinessGetLegalEntityRequestType request_x = new dutchBusinessGetLegalEntityRequestType();
            dutchBusinessGetLegalEntityResponseType response_x;
            request_x.dossier_number = dossier_number;
            Map<String, dutchBusinessGetLegalEntityResponseType> response_map_x = new Map<String, dutchBusinessGetLegalEntityResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessGetLegalEntity',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessGetLegalEntity',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessGetLegalEntityResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessGetLegalEntityResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }

        public DutchBusinessOrganizationTree dutchBusinessGetOrganizationTree(String dossier_number) {
            dutchBusinessGetOrganizationTreeRequestType request_x = new dutchBusinessGetOrganizationTreeRequestType();
            dutchBusinessGetOrganizationTreeResponseType response_x;
            request_x.dossier_number = dossier_number;
            Map<String, dutchBusinessGetOrganizationTreeResponseType> response_map_x = new Map<String, dutchBusinessGetOrganizationTreeResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessGetOrganizationTree',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessGetOrganizationTree',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessGetOrganizationTreeResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessGetOrganizationTreeResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }

        public DutchBusinessPositions dutchBusinessGetPositions(String dossier_number) {
            dutchBusinessGetPositionsRequestType request_x = new dutchBusinessGetPositionsRequestType();
            dutchBusinessGetPositionsResponseType response_x;
            request_x.dossier_number = dossier_number;
            Map<String, dutchBusinessGetPositionsResponseType> response_map_x = new Map<String, dutchBusinessGetPositionsResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessGetPositions',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessGetPositions',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessGetPositionsResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessGetPositionsResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }

        public DutchBusinessEstablishmentReferencePagedResult dutchBusinessSearch(String dossier_number,String trade_name,String city,String street,String postcode,Integer house_number,String house_number_addition,String telephone_number,String domain_name,Boolean strict_search,Integer page) {
            dutchBusinessSearchRequestType request_x = new dutchBusinessSearchRequestType();
            dutchBusinessSearchResponseType response_x;
            request_x.dossier_number = dossier_number;
            request_x.trade_name = trade_name;
            request_x.city = city;
            request_x.street = street;
            request_x.postcode = postcode;
            request_x.house_number = house_number;
            request_x.house_number_addition = house_number_addition;
            request_x.telephone_number = telephone_number;
            request_x.domain_name = domain_name;
            request_x.strict_search = strict_search;
            request_x.page = page;
            Map<String, dutchBusinessSearchResponseType> response_map_x = new Map<String, dutchBusinessSearchResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessSearch',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearch',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }

        public DutchBusinessReferencePagedResult dutchBusinessSearchDossierNumber(String dossier_number,String establishment_number,String rsin_number,Integer page) {
            dutchBusinessSearchDossierNumberRequestType request_x = new dutchBusinessSearchDossierNumberRequestType();
            dutchBusinessSearchDossierNumberResponseType response_x;
            request_x.dossier_number = dossier_number;
            request_x.establishment_number = establishment_number;
            request_x.rsin_number = rsin_number;
            request_x.page = page;
            Map<String, dutchBusinessSearchDossierNumberResponseType> response_map_x = new Map<String, dutchBusinessSearchDossierNumberResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessSearchDossierNumber',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchDossierNumber',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchDossierNumberResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchDossierNumberResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }

        public DutchBusinessEstablishmentReferencePagedResult dutchBusinessSearchEstablishments(String dossier_number,String establishment_number,String rsin_number,Integer page) {
            dutchBusinessSearchEstablishmentsRequestType request_x = new dutchBusinessSearchEstablishmentsRequestType();
            dutchBusinessSearchEstablishmentsResponseType response_x;
            request_x.dossier_number = dossier_number;
            request_x.establishment_number = establishment_number;
            request_x.rsin_number = rsin_number;
            request_x.page = page;
            Map<String, dutchBusinessSearchEstablishmentsResponseType> response_map_x = new Map<String, dutchBusinessSearchEstablishmentsResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessSearchEstablishments',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchEstablishments',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchEstablishmentsResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchEstablishmentsResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }

        public DutchBusinessNewsItemPagedResult dutchBusinessSearchNewsByDossier(Integer dossier_number,DateTime period_start,DateTime period_end,String sort_order,Integer page) {
            dutchBusinessSearchNewsByDossierRequestType request_x = new dutchBusinessSearchNewsByDossierRequestType();
            dutchBusinessSearchNewsByDossierResponseType response_x;
            request_x.dossier_number = dossier_number;
            request_x.period_start = period_start;
            request_x.period_end = period_end;
            request_x.sort_order = sort_order;
            request_x.page = page;
            Map<String, dutchBusinessSearchNewsByDossierResponseType> response_map_x = new Map<String, dutchBusinessSearchNewsByDossierResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessSearchNewsByDossier',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchNewsByDossier',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchNewsByDossierResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchNewsByDossierResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }

        public DutchBusinessReferencePagedResult dutchBusinessSearchPostcode(String postcode,Integer house_number,String house_number_addition,Integer page) {
            dutchBusinessSearchPostcodeRequestType request_x = new dutchBusinessSearchPostcodeRequestType();
            dutchBusinessSearchPostcodeResponseType response_x;
            request_x.postcode = postcode;
            request_x.house_number = house_number;
            request_x.house_number_addition = house_number_addition;
            request_x.page = page;
            Map<String, dutchBusinessSearchPostcodeResponseType> response_map_x = new Map<String, dutchBusinessSearchPostcodeResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessSearchPostcode',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchPostcode',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchPostcodeResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchPostcodeResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }

        public DutchBusinessReferencePagedResult dutchBusinessSearchSelection(stringArray city,stringArray postcode,stringArray sbi,Boolean primary_sbi_only,intArray legal_form,Integer employees_min,Integer employees_max,String economically_active,String financial_status,String changed_since,String new_since,Integer page,stringArray provinces,String sbi_match_type) {
            dutchBusinessSearchSelectionRequestType request_x = new dutchBusinessSearchSelectionRequestType();
            dutchBusinessSearchSelectionResponseType response_x;
            request_x.city = city;
            request_x.postcode = postcode;
            request_x.sbi = sbi;
            request_x.primary_sbi_only = primary_sbi_only;
            request_x.legal_form = legal_form;
            request_x.employees_min = employees_min;
            request_x.employees_max = employees_max;
            request_x.economically_active = economically_active;
            request_x.financial_status = financial_status;
            request_x.changed_since = changed_since;
            request_x.new_since = new_since;
            request_x.page = page;
            request_x.provinces = provinces;
            request_x.sbi_match_type = sbi_match_type;
            Map<String, dutchBusinessSearchSelectionResponseType> response_map_x = new Map<String, dutchBusinessSearchSelectionResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessSearchSelection',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchSelection',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessSearchSelectionResponse',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchSelectionResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }





}



