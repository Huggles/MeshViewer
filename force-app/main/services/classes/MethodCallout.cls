/**
 * Created by jaapbranderhorst on 2019-07-11.
 */

public inherited sharing abstract class MethodCallout implements Callable {

    protected WebServicePort port{
        get; set;
    }

    public MethodCallout(WebServicePort port) {
        this.port = port;
    }

    /**
     * Does a callout and properly handles errors
     *
     * @param methodName the name of the method to call
     * @param arguments the arguments for the method as key value pairs in a map
     *
     * @return the return value of the call.
     */
    public Object callOut(String methodName, Map<String, Object> arguments) {
        Object returnValue = null;
        try {
            returnValue = call(methodName, arguments);
        } catch(CalloutException calloutException) {
            handleCallOutException(calloutException);
        }
        return returnValue;
    }

    /**
     * Implement this method and call callOut on an instance of a child to do a callout to the webservice layer
     *
     * @param methodName the name of the method to call
     * @param arguments the arguments for the method as key value pairs in a map
     *
     * @return the return value of the call.
     */
    private abstract Object call(String methodName, Map<String, Object> arguments);

    /**
     * Handles a callout exception that can occur when calling the data vendor.
     *
     * @param calloutException the exception thrown by the callout
     *
     */
    public void handleCallOutException(CalloutException calloutException) {
        String message = calloutException.getMessage();
        String faultCode = getFaultCode(message);
        switch on faultCode {
            when 'Client' {
                if (message.contains('(You are not logged in)')) { // Company.info should improve this...
                    throw new CCWsClientAuthenticationException(Label.Error_Client_Authentication, calloutException);
                }
                // general error caused by the client but unexpected so we log
                Exception ex = new CCWsClientException(getErrorMessage(message) + '.' + Label.Error_Webservice_Client, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Client.Authentication' {
                throw new CCWsClientAuthenticationException(Label.Error_Client_Authentication, calloutException);
            }
            when 'Client.Authentication.HostRestriction' {
                // Authentication failed due to restrictions on hosts and/or ip addresses.
                // this shouldn't happen because Salesforce servers should be allowed to call Company.info servers so we log
                Exception ex = new CCWsClientAuthHostRestrictionException(Label.Error_Client_Hostrestriction, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Client.Authentication.Password' {
                throw new CCWsClientAuthPasswordException(Label.Error_Client_Authentication_Password, calloutException);
            }
            when 'Client.Authentication.Username' {
                throw new CCWsClientAuthUserNameException(Label.Error_Client_Authentication_Username, calloutException);
            }
            when 'Client.Authorization' {
                // The client has been authenticated, but isn’t allowed to use the requested functionality.
                // this shouldn't happen because Salesforce users should be authorized for all services so we log
                Exception ex = new CCWsClientAuthorizationException(Label.Error_Client_Authorization, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Client.Input' {
                // An error occurred due to a problem with the client’s input.
                // This shouldn't happen because we should have checked the input in the UI and the business services so we log
                Exception ex = new CCWsClientInputException(Label.Error_Client_Input, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Client.Input.FormatIncorrect' {
                // The input is invalid because one of the parameters contains a syntax error or is in an incorrect format.
                // This shouldn't happen because we should have checked the input in the UI and the business services so we log
                Exception ex = new CCWsClientInputFormatIncorrectException(Label.Error_Client_Input_Format_Incorrect, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Client.Input.Incomplete' {
                // The input is invalid because one of the required parameters is missing or is incomplete.
                // This shouldn't happen because we should have checked the input in the UI and the business services so we log
                Exception ex = new CCWsClientInputIncompleteException(Label.Error_Client_Input_Incomplete, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Client.Input.Invalid' {
                // The input is invalid because one of the parameters contains an invalid or disallowed value.
                // This shouldn't happen because we should have checked the input in the UI and the business services so we log
                Exception ex = new CCWsClientInputInvalidException(Label.Error_Client_Input_Invalid, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Client.Input.Payment' {
                // The request can’t be processed, because the user (or its account) doesn’t have sufficient balance/credits.
                throw new CCWsClientPaymentException(Label.Error_Client_Payment, calloutException);
            }
            // ** SERVER **
            when 'Server' {
                if (message.contains('Vat number for business not found')) {
                    throw new CCWsServerDataNotFoundVatException(Label.VAT_Not_Found, calloutException);
                }
                // General error, caused by the server.
                // This shouldn't happen so we log
                Exception ex = new CCWsServerException(Label.Error_Webservice_Server, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Server.Data' {
                // An error occurred while retrieving requested data.
                // This shouldn't happen so we log
                Exception ex = new CCWsServerDataException(Label.Error_Server_Data, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Server.Data.NotFound' {
                // The requested data isn’t available (for example, the requested address does not exist).
                throw new CCWsServerDataNotFoundException(Label.Error_Server_Data_NotFound, calloutException);
            }
            when 'Server.Data.NotFound.Nbwo.EstimateUnavailable' {
                // An accurate NBWO value can not be estimated for the specified address.
                throw new CCWsServerDataNotFoundNbwoException(Label.Error_Server_Data_NotFound_Nbwo_EstimateUnavailable, calloutException);
            }
            when 'Server.Data.NotFound.Kadaster.NotDeliverable' {
                // The requested result is not deliverable.  (kadaster can not deliver person information due to legal reasons)
                throw new CCWsServerDataNotFoundKadasterException(Label.Error_Server_Data_NotFound_Kadaster_NotDeliverable, calloutException);
            }
            when 'Server.Data.PageNotFound' {
                // The requested result page doesn’t exist.
                throw new CCWsServerDataPageNotFoundException(Label.Error_Server_Data_PageNotFound, calloutException);
            }
            when 'Server.Unavailable' {
                // An error occurred that causes the service to be unavailable.
                // This shouldn't happen so we log
                Exception ex = new CCWsServerUnavailableException(Label.Error_Server_Unavailable, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Server.Unavailable.InternalError' {
                // The service is unavailable due to an internal server error.
                // This shouldn't happen so we log
                Exception ex = new CCWsServerUnavailableInternalException(Label.Error_Server_Unavailable_InternalError, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when 'Server.Unavailable.Temporary' {
                // The service is unavailable due to a temporary technical problem.
                // This shouldn't happen so we log
                Exception ex = new CCWsServerUnavailableTemporaryException(Label.Error_Server_Unavailable_Temporary, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            when else {
                // An unexpected (and undocumented) exception
                // This shouldn't happen so we log
                Exception ex = new CCWsException(Label.Error_Unknown, calloutException);
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
        }
    }

    /**
     * Returns the soap fault code as defined in https://webview.webservices.nl/documentation/files/interfaces/errorhandling-txt.html
     *
     * @param message the exception's error message
     *
     * @return the fault code found
     */
    private String getFaultCode(String message) {
        Integer faultCodeStart = message.lastIndexOf('SOAP-ENV:') + 'SOAP-ENV:'.length();
        Integer faultCodeEnd = message.indexOf(' ', faultCodeStart);
        String faultCode = message.substring(faultCodeStart, faultCodeEnd);
        return faultCode;
    }

    /**
     * Gets the relevant part of the error message
     *
     * @param message the exception's error message
     *
     * @return the fault code
     */
    private String getErrorMessage(String message) {
        String returnValue = '';
        returnValue = message.removeStart('Web service callout failed: WebService returned a SOAP Fault: ');
        returnValue = message.indexOf(' faultcode') > 0 ? message.substring(0, message.indexOf(' faultcode')): returnValue;
        return returnValue;
    }

}