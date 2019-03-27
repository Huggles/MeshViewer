/****************************************************************************************
Author          : ValerijsProkudins
Description     : Company info DutchBusiness integration implementation class. NB: it extends the DutchBusiness implementation type class!
******************************************************************************************/
public class WebServicesNLSOAPDutchBusinessImpl extends WebServicesNLSOAPDutchBusinessImplTypes implements IWebServicesNLSOAPDutchBusiness {
    
public WebServicesNLSOAPDutchBusinessImpl(){
        super();
}
    public DutchBusinessDto.DutchBusinessGetDossierResponse dutchBusinessGetDossier(DutchBusinessDto.DutchBusinessGetDossierRequest params){

        try{
            DutchBusinessDossierV3 response = dutchBusinessGetDossierV3(params.dossier_number, params.establishment_number);
            DutchBusinessDto.DutchBusinessGetDossierResponse result = new DutchBusinessDto.DutchBusinessGetDossierResponse();
            result.legal_name = response.legal_name;
            result.dossier_number = response.dossier_number;
            result.establishment_number = response.establishment_number;
            result.main_establishment_number = response.main_establishment_number;
            result.indication_main_establishment = response.indication_main_establishment ;
            result.rsin_number = response.rsin_number ;
            result.chamber_number = response.chamber_number ;
            result.legal_form_code = response.legal_form_code ;
            result.legal_form_text = response.legal_form_text ;
            result.indication_organisation_code = response.indication_organisation_code ;
            result.trade_name_45 = response.trade_name_45 ;
            result.trade_name_full = response.trade_name_full;
            result.trade_names = new list<String>();
            for(String str: response.trade_names.item){
                result.trade_names.add(str);
            }

            result.telephone_number = response.telephone_number ;
            result.mobile_number = response.mobile_number ;
            result.domain_name = response.domain_name ;
            result.authorized_share_capital = response.authorized_share_capital ;
            result.authorized_share_capital_currency = response.authorized_share_capital_currency ;
            result.class_personnel = response.class_personnel ;
            result.class_personnel_fulltime = response.class_personnel_fulltime ;
            result.continuation_date = Date.newInstance(response.continuation_date.year, response.continuation_date.month, response.continuation_date.day);
            result.discontinuation_date = Date.newInstance(response.discontinuation_date.year, response.discontinuation_date.month, response.discontinuation_date.day);
            result.establishment_date = Date.newInstance(response.establishment_date.year, response.establishment_date.month, response.establishment_date.day);
            result.founding_date = Date.newInstance(response.founding_date.year, response.founding_date.month, response.founding_date.day);
            result.issued_share_capital = response.issued_share_capital ;
            result.issued_share_capital_currency = response.issued_share_capital_currency ;
            result.paid_up_share_capital = response.paid_up_share_capital ;
            result.paid_up_share_capital_currency = response.paid_up_share_capital_currency ;
            result.personnel = response.personnel ;
            result.personnel_fulltime = response.personnel_fulltime ;
            result.personnel_reference_date = Date.newInstance(response.personnel_reference_date.year, response.personnel_reference_date.month, response.personnel_reference_date.day);
            result.primary_sbi_code = response.primary_sbi_code ;
            result.primary_sbi_code_text = response.primary_sbi_code_text ;
            result.secondary_sbi_code1 = response.secondary_sbi_code1 ;
            result.secondary_sbi_code1_text = response.secondary_sbi_code1_text ;
            result.secondary_sbi_code2 = response.secondary_sbi_code2 ;
            result.Secondary_Sbi_Code2_Text = response.Secondary_Sbi_Code2_Text;

            return result;

        }catch(System.CalloutException ex){
            throw new CustomException('The call to the service was unsuccessfull'+ex.getMessage());
        }catch(System.Exception ex){
            throw new CustomException('Something happened while processing the webservice call response'+ex.getMessage());
        }

    }
     
    public DutchBusinessDossierV3 dutchBusinessGetDossierV3(String dossier_number,String establishment_number){
        

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
        return response_x.out;
    }
    public DutchBusinessDto.DutchBusinessSearchParametersResponse dutchBusinessSearchParameters(DutchBusinessDto.DutchBusinessSearchParametersRequest params){
        try{
            DutchBusinessDto.DutchBusinessSearchParametersResponse result;
            DutchBusinessReferenceV2PagedResult response = dutchBusinessSearchParametersV2(params.name,params.city,params.street,params.postcode,null,null,params.phone,params.domain,false,null);   
            
            result = new DutchBusinessDto.DutchBusinessSearchParametersResponse();
            result.curpage = response.paging.curpage;
            result.perpage = response.paging.perpage;
            result.numpages = response.paging.numpages;
            result.numresults = response.paging.numresults;
            result.maxresults = response.paging.maxresults;
            for(DutchBusinessReferenceV2 item: response.results.item){
                    DutchBusinessDto.DutchBusinessReference restItem = new DutchBusinessDto.DutchBusinessReference();
                    restItem.dossier_number = item.dossier_number ;
                    restItem.establishment_number = item.establishment_number ;
                    restItem.name = item.name ;
                    restItem.match_type = item.match_type ;
                    restItem.establishment_city = item.establishment_city ;
                    restItem.establishment_street = item.establishment_street ;
                    restItem.correspondence_city = item.correspondence_city ;
                    restItem.correspondence_street = item.correspondence_street ;
                    restItem.indication_economically_active =  item.indication_economically_active ;
                    result.items.add(restItem);
            }
        return result;
            
        }catch(System.CalloutException ex){
            throw new CustomException('The call to the service was unsuccessfull'+ex.getMessage());
        }catch(System.Exception ex){
            throw new CustomException('Something happened while processing the webservice call response'+ex.getMessage());
        }

    }

        public DutchBusinessReferenceV2PagedResult dutchBusinessSearchParametersV2(String trade_name,String city,String street,String postcode,Integer house_number,String house_number_addition,String telephone_number,String domain_name,Boolean strict_search,Integer page) {
            
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
            //DutchBusinessDto result = new DutchBusinessDto();
            return response_x.out;
            //return result;
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


        private String getDate(DutchBusinessDateV3 dt){
                String result;
                result = dt.year + '-' + dt.month +'-'+ dt.day;
                return result;
        }


}



