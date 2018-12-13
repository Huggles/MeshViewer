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
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessGetDossierV3ResponseType());
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
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchParametersV2ResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchPostcodeRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchPostcodeResponseType());
        }
        else if(request instanceOf wwwWebservicesNlSoap.dutchBusinessSearchSelectionRequestType) {
            response.put( 'response_x', new wwwWebservicesNlSoap.dutchBusinessSearchSelectionResponseType());
        }
    }
}