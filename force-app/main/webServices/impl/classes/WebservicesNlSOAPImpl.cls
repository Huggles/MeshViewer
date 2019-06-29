/****************************************************************************************
Author          : ValerijsProkudins
Description     : Company info baseline integration implementation class. NB: it extends the baseline implementation type class!
******************************************************************************************/
public with sharing abstract class WebservicesNlSOAPImpl extends WebservicesNlSOAPImplTypes implements IWebservicesNlSOAP{
    //public String endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php'; //TODO: mover to other place?
    //public Map<String,String> inputHttpHeaders_x;
    //public Map<String,String> outputHttpHeaders_x;
    //public String clientCertName_x;
    //public String clientCert_x;
    //public String clientCertPasswd_x;
    //public Integer timeout_x;
    //public HeaderAuthenticateType HeaderAuthenticate;
    //public HeaderLoginType HeaderLogin;
    //private String HeaderAuthenticate_hns = 'HeaderAuthenticate=http://www.webservices.nl/soap/';
   // private String HeaderLogin_hns = 'HeaderLogin=http://www.webservices.nl/soap/';
    private String[] ns_map_type_info = new String[]{'http://www.webservices.nl/soap/','wwwWebservicesNlSoap'};
    public Webservices_nlPort port;

    public WebservicesNlSOAPImpl(){
        //port = new Webservices_nlPort('User');
        //this.endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php';
    }
    public with sharing class Webservices_nlPort {
        
        private Boolean fallback { get; private set; }

        public String endpoint_x;// = 'https://ws1.webservices.nl:443/soap_doclit.php';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public HeaderLoginType HeaderLogin;
        private String HeaderLogin_hns = 'HeaderLogin=http://www.webservices.nl/soap/';
        public HeaderAuthenticateType HeaderAuthenticate;
        private String HeaderAuthenticate_hns = 'HeaderAuthenticate=http://www.webservices.nl/soap/';
        private String[] ns_map_type_info = new String[]{'http://www.webservices.nl/soap/','wwwWebservicesNlSoap'}; // wwwWebservicesNlSoap is from the old WS file name. Might need to change if something breaks
        
        public Webservices_nlPort(String scope){ // scope is either user or admin
            HeaderLogin = getAuthentication(scope);
            endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php'; // TODO: move to CMT
        }
       
        public void useFallback(){
            fallback = true;
            endpoint_x = 'https://ws2.webservices.nl:443/soap_doclit.php';
        }
        
        public headerLoginType getAuthentication(String scope){
            headerLoginType headerLogin;
            if(scope == 'User'){
                Credentials__c CS = Credentials__c.getOrgDefaults();
                if(cs.Username__c != null && cs.Password__c != null){
                    headerLogin = new headerLoginType();
                    headerLogin.userName=cs.Username__c;
                    headerLogin.passWord=cs.Password__c;
                }
            }else{ // admin apparently, maybe we should explicitly check...
                ApplicationProperty__mdt configData = [SELECT DataProviderAdminUsername__c, DataProviderAdminPassword__c FROM ApplicationProperty__mdt WHERE DataProviderName__c = 'Company.Info' LIMIT 1];
                headerLogin = new headerLoginType();
                headerLogin.userName=configData.DataProviderAdminUsername__c;
                headerLogin.passWord=configData.DataProviderAdminPassword__c;        
            }
//            if(headerLogin == null){
//                // TODO: find out how we ever could get here since we cannot
//
//                CCException ex = new CCException(System.Label.NoAuthAppNotActive);//'No authentication data found. The app is not activated');
//                ErrorLogUtil.logException(ex); 
//                //throw new CCException(System.Label.NoAuthAppNotActive);//'No authentication data found. The app is not activated');
//            }
            return headerLogin;
            
        }
    }

    @TestVisible
    private void handleCallOutException(CalloutException calloutException, Webservices_nlPort port, Object request_x, Map<String,Object> response_map_x, list <String> infoArray) {
        String message = calloutException.getMessage();
        String faultCode = getFaultCode(message);
        String soapErrorMessage = getSoapErrorMessage(message);
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
                doFallBackCall(port, request_x, response_map_x, infoArray);
            }
            when 'Server.Unavailable.InternalError' {

            }
            when 'Server.Unavailable.Temporary' {

            }
            when else {

            }
        }
    }
    
    private void doFallBackCall(Webservices_nlPort port, Object request_x, Map<String,Object> response_map_x, list <String> infoArray) {
        port.useFallback();
        infoArray.set(0, port.endpoint_x);
        try {
            WebServiceCallout.invoke(   //Invocation is wrapped in method that supports fallback server in case of callout timeout
                    port,
                    request_x,
                    response_map_x,
                    infoArray
            );
        } catch(CalloutException e) {
            handleCallOutException(e, port, request_x, response_map_x, infoArray);
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

    /**
     * Strips SOAP Fault: from the calloutException message and returns the human readable error message
     *
     * @param message
     *
     * @return
     */
    private String getSoapErrorMessage(String message) {
        Integer errorMessageStart = message.lastIndexOf('SOAP Fault:');
        Integer errorMessageEnd = message.indexOf('faultcode');
        String errorMessage = message.substring(errorMessageStart, errorMessageEnd).normalizeSpace();
        return errorMessage;
    }



    // TODO: add proper error handling
    public void executeCallout(Webservices_nlPort port, Object request_x, Map<String,Object> response_map_x, list <String> infoArray){
        port.fallback = false;
        try{
            WebServiceCallout.invoke(   //Invocxation is wrapped in method that supports fallback server in case of callout timeout
                    port,
                    request_x,
                    response_map_x,
                    infoArray
            );
            // TODO: we allready know if an error is happening here (since it is in the Error response) handle it here.
            // see: https://webview.webservices.nl/documentation/files/interfaces/errorhandling-txt.html#Error_Handling
        } catch (CalloutException e) {
            handleCallOutException(e, port, request_x, response_map_x, infoArray);
        }
    }


}

