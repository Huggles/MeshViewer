/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public with sharing class WebservicesPort {

    public static final String ADMIN_SCOPE = 'Admin';
    public static final String USER_SCOPE = 'User';
    public static final String PRIMARY_ENDPOINT = 'https://ws1.webservices.nl:443/soap_doclit.php';
    public static final String SECONDARY_ENDPOINT = 'https://ws2.webservices.nl:443/soap_doclit.php';

    /**
     * Authentication scope
     */
    private String scope { get; set; }

    /**
     *
     */
    private Boolean fallBackCall { get; set; }

    public String endpoint_x;// = 'https://ws1.webservices.nl:443/soap_doclit.php';
    public Map<String,String> inputHttpHeaders_x;
    public Map<String,String> outputHttpHeaders_x;
    public String clientCertName_x;
    public String clientCert_x;
    public String clientCertPasswd_x;
    public Integer timeout_x;
    public HeaderLoginType headerLogin;
    private String HeaderLogin_hns = 'HeaderLogin=http://www.webservices.nl/soap/';
    public HeaderAuthenticateType HeaderAuthenticate;
    private String HeaderAuthenticate_hns = 'HeaderAuthenticate=http://www.webservices.nl/soap/';
    private String[] ns_map_type_info = new String[]{'http://www.webservices.nl/soap/','wwwWebservicesNlSoap'}; // wwwWebservicesNlSoap is from the old WS file name. Might need to change if something breaks

    public WebservicesPort(String scope){ // scope is either user or admin
        this.scope = scope;
        headerLogin = getAuthentication(scope);
        endpoint_x = PRIMARY_ENDPOINT; // TODO: move to CMT
    }

    public  WebservicesPort(String scope, Boolean useFallBack) {
        this(scope);
        if (useFallBack) {
            endpoint_x = SECONDARY_ENDPOINT;
        } else {
            endpoint_x = PRIMARY_ENDPOINT;
        }
    }

    private HeaderLoginType getAuthentication(String scope){
        HeaderLoginType headerLogin = new HeaderLoginType();
        switch on scope {
            when 'User' {
                Credentials__c CS = Credentials__c.getOrgDefaults();
                if (String.isEmpty(cs.Username__c)) {
                    ErrorLogUtil.logMessage('No username found for Company Info data vendor data user');
                    throw new CCWsException(Label.Error_Config);
                }
                if (String.isEmpty(cs.Password__c)) {
                    ErrorLogUtil.logMessage('No password found for Company Info data vendor data user');
                    throw new CCWsException(Label.Error_Config);
                }
                headerLogin.userName=cs.Username__c;
                headerLogin.passWord=cs.Password__c;
            }
            when 'Admin' {
                ApplicationProperty__mdt configData = [SELECT DataProviderAdminUsername__c, DataProviderAdminPassword__c FROM ApplicationProperty__mdt WHERE DataProviderName__c = 'Company.Info' LIMIT 1];
                if (String.isEmpty(configData.DataProviderAdminUsername__c)) {
                    ErrorLogUtil.logMessage('No username found for Company Info data vendor admin');
                    throw new CCWsException(Label.Error_Config);
                }
                if (String.isEmpty(configData.DataProviderAdminPassword__c)) {
                    ErrorLogUtil.logMessage('No password found for Company Info data vendor admin');
                    throw new CCWsException(Label.Error_Config);
                }
                headerLogin.userName=configData.DataProviderAdminUsername__c;
                headerLogin.passWord=configData.DataProviderAdminPassword__c;
            }
        }
        return headerLogin;
    }


    @TestVisible
    private void handleCallOutException(CalloutException calloutException, Object request_x, Map<String,Object> response_map_x, List<String> infoArray) {
        String message = calloutException.getMessage();
        String faultCode = getFaultCode(message);
        switch on faultCode {
            when 'Client' {
                ErrorLogUtil.logException(calloutException); // shouldn't happen because unexpected so we log.
                throw new CCWsClientException(Label.Error_Webservice_Client); // TODO: rename label
            }
            when 'Client.Authentication' {
                ErrorLogUtil.logException(calloutException); // shouldn't happen so we log.
                throw new CCWsClientAuthenticationException(Label.Error_Client_Authentication);
            }
            when 'Client.Authentication.HostRestriction' {
                ErrorLogUtil.logException(calloutException); // shouldn't happen so we log.
                throw new CCWsClientAuthHostRestrictionException(Label.Error_Client_Hostrestriction); // TODO: rename label
            }
            when 'Client.Authentication.Password' {
                throw new CCWsClientAuthPasswordException(Label.Error_Client_Authentication_Password);
            }
            when 'Client.Authentication.Username' {
                throw new CCWsClientAuthUserNameException(Label.Error_Client_Authentication_Username);
            }
            when 'Client.Authorization' {
                ErrorLogUtil.logException(calloutException); // shouldn't happen because the user should have the right access rights so we log.
                throw new CCWsClientAuthorizationException(Label.Error_Client_Authorization);
            }
            when 'Client.Input' {
                ErrorLogUtil.logException(calloutException); // shouldn't happen because input needs to be checked on the UI and service layer so we log.
                throw new CCWsClientInputException(Label.Error_Client_Input);
            }
            when 'Client.Input.FormatIncorrect' {
                ErrorLogUtil.logException(calloutException); // shouldn't happen because input needs to be checked on the UI and service layer so we log.
                throw new CCWsClientInputFormatIncorrectException(Label.Error_Client_Input_Format_Incorrect);
            }
            when 'Client.Input.Incomplete' {
                ErrorLogUtil.logException(calloutException); // shouldn't happen because input needs to be checked on the UI and service layer so we log.
                throw new CCWsClientInputIncompleteException(Label.Error_Client_Input_Incomplete);
            }
            when 'Client.Input.Invalid' {
                ErrorLogUtil.logException(calloutException); // shouldn't happen because input needs to be checked on the UI and service layer so we log.
                throw new CCWsClientInputInvalidException(Label.Error_Client_Input_Invalid);
            }
            when 'Client.Input.Payment' {
                throw new CCWsClientPaymentException(Label.Error_Client_Payment);
            }
            // ** SERVER **
            when 'Server' {
                if (message.contains('Vat number for business not found')) {
                    throw new CCWsServerDataNotFoundVatException(Label.VAT_Not_Found); // TODO: rename the label to Error_Server_Data_NotFound_VAT
                }
                ErrorLogUtil.logException(calloutException);
                throw new CCWsServerException(Label.Error_Webservice_Server); // TODO: rename label
            }
            when 'Server.Data' {
                ErrorLogUtil.logException(calloutException);
                throw new CCWsClientException(Label.Error_Server_Data);
            }
            when 'Server.Data.NotFound' {
                throw new CCWsServerDataNotFoundException(Label.Error_Server_Data_NotFound);
            }
            when 'Server.Data.NotFound.Nbwo.EstimateUnavailable' {
                throw new CCWsServerDataNotFoundNbwoException(Label.Error_Server_Data_NotFound_Nbwo_EstimateUnavailable);
            }
            when 'Server.Data.NotFound.Kadaster.NotDeliverable' {
                throw new CCWsServerDataNotFoundKadasterException(Label.Error_Server_Data_NotFound_Kadaster_NotDeliverable);
            }
            when 'Server.Data.PageNotFound' {
                throw new CCWsServerDataPageNotFoundException(Label.Error_Server_Data_PageNotFound);
            }
            when 'Server.Unavailable' {
                ErrorLogUtil.logException(calloutException); // unexpected unavailability of primary server
                if (fallBackCall) {
                    throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                } else {
                    if (scope != ADMIN_SCOPE) { // only accounting services are being requested as an admin user
                        doFallBackCall(request_x, response_map_x, infoArray);
                    } else { // fallback doesn't support accounting services
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
            when 'Server.Unavailable.InternalError' {
                ErrorLogUtil.logException(calloutException); // unexpected unavailability of primary server
                if (fallBackCall) {
                    throw new CCWsServerUnavailableInternalException(Label.Error_Server_Unavailable_InternalError);
                } else {
                    if (scope != ADMIN_SCOPE) { // only accounting services are being requested as an admin user
                        doFallBackCall(request_x, response_map_x, infoArray);
                    } else { // fallback doesn't support accounting services
                        throw new CCWsServerUnavailableInternalException(Label.Error_Server_Unavailable_InternalError);
                    }
                }
            }
            when 'Server.Unavailable.Temporary' {
                ErrorLogUtil.logException(calloutException); // unexpected unavailability of primary server
                if (fallBackCall) {
                    throw new CCWsServerUnavailableTemporaryException(Label.Error_Server_Unavailable_Temporary);
                } else {
                    if (scope != ADMIN_SCOPE) { // only accounting services are being requested as an admin user
                        doFallBackCall(request_x, response_map_x, infoArray);
                    } else { // fallback doesn't support accounting services
                        throw new CCWsServerUnavailableTemporaryException(Label.Error_Server_Unavailable_Temporary);
                    }
                }
            }
            when else {
                ErrorLogUtil.logException(calloutException); // ouch unknown exception
                throw new CCWsException(Label.Error, calloutException);
            }
        }
    }

    private void doFallBackCall(Object request_x, Map<String,Object> response_map_x, list <String> infoArray) {
        WebservicesPort port = new WebservicesPort(this.scope, true);
        infoArray.set(0, port.endpoint_x);
        try {
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    infoArray
            );
        } catch(CalloutException e) {
            handleCallOutException(e, request_x, response_map_x, infoArray);
        }
    }

    /**
     * Returns the soap fault code as defined in https://webview.webservices.nl/documentation/files/interfaces/errorhandling-txt.html
     *
     * @param message
     *
     * @return
     */
    private String getFaultCode(String message) {
        Integer faultCodeStart = message.lastIndexOf('SOAP-ENV:');
        Integer faultCodeEnd = message.indexOf(' ', faultCodeStart);
        String faultCode = message.substring(faultCodeStart, faultCodeEnd);
        return faultCode;
    }

    public void executeCallout(Object request_x, Map<String,Object> response_map_x, List<String> infoArray) {
        this.fallBackCall = false;
        try{
            WebServiceCallout.invoke(   //Invocxation is wrapped in method that supports fallback server in case of callout timeout
                    this,
                    request_x,
                    response_map_x,
                    infoArray
            );
        } catch (CalloutException e) {
            handleCallOutException(e, request_x, response_map_x, infoArray);
        }
    }

}