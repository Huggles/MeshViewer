/**
 * Created by asifsayyed on 02/12/18.
 */
@isTest
global class wwwWebservicesNlSoapMockImpl implements WebServiceMock {
    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        System.debug(LoggingLevel.INFO, 'wwwWebservicesNlSoapMockImpl.doInvoke() - ' +
                '\n request: ' + request +
                '\n response: ' + response +
                '\n endpoint: ' + endpoint +
                '\n soapAction: ' + soapAction +
                '\n requestName: ' + requestName +
                '\n responseNS: ' + responseNS +
                '\n responseName: ' + responseName +
                '\n responseType: ' + responseType);
        if(request instanceOf wwwWebservicesNlSoap.dutchBusinessGetDossierHistoryRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessGetDossierHistoryResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessGetDossierV3RequestType) {
            wwwWebservicesNlSoap.dutchBusinessGetDossierV3ResponseType r =  new wwwWebservicesNlSoap.dutchBusinessGetDossierV3ResponseType();
            r.out = getExampleDossier();
            response.put( 'response_x', r);
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessGetLegalEntityRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessGetLegalEntityResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessGetOrganizationTreeRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessGetOrganizationTreeResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessGetPositionsRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessGetPositionsResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchDossierNumberRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchDossierNumberResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchEstablishmentsRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchEstablishmentsResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchNewsByDossierRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchNewsByDossierResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchParametersV2RequestType) {
            wwwWebservicesNlSoap.dutchBusinessSearchParametersV2ResponseType r =  new wwwWebservicesNlSoap.dutchBusinessSearchParametersV2ResponseType();
            r.out = new wwwWebservicesNlSoap.DutchBusinessReferenceV2PagedResult();
            r.out.results = new wwwWebservicesNlSoap.DutchBusinessReferenceV2Array();

            r.out.results.item = getExampleBusinessList();

            response.put( 'response_x', r);
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchPostcodeRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchPostcodeResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchSelectionRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchSelectionResponseType());
        }
    }
    public static List<wwwWebservicesNlSoap.DutchBusinessReferenceV2> getExampleBusinessList() {
        List<wwwWebservicesNlSoap.DutchBusinessReferenceV2> ret = new List<wwwWebservicesNlSoap.DutchBusinessReferenceV2>();
        Integer cnt = 5; 
        
        for (Integer i = 0; i < cnt; i++) {
            wwwWebservicesNlSoap.DutchBusinessReferenceV2 item = new wwwWebservicesNlSoap.DutchBusinessReferenceV2();
            item.name='test ' + i;
            ret.add(item);
        }
        return ret;
    }
    public static wwwWebservicesNlSoap.DutchBusinessDossierV3 getExampleDossier() {
        wwwWebservicesNlSoap.DutchBusinessDossierV3 ret = new wwwWebservicesNlSoap.DutchBusinessDossierV3();
        ret.legal_name = 'Test';
        ret.dossier_number = '12345678';
        ret.establishment_number = '123454';
        ret.main_establishment_number = '1234567788';
        ret.indication_main_establishment = true;
        ret.rsin_number = '857039878';
        ret.chamber_number = '30';
        ret.legal_form_code = '41';
        ret.legal_form_text = 'Besloten Vennootschap met gewone structuur';
        ret.indication_organisation_code = '0';
        ret.trade_name_45 = 'Test';
        ret.trade_name_full = 'Test';
        ret.telephone_number = '123456';
        ret.mobile_number = '';
        ret.domain_name = '';
        
        return ret;
    }
}