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
     * Does a callout and properly handles fallback and errors
     *
     * @param methodName
     * @param arguments
     *
     * @return
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
     * @param methodName
     * @param arguments
     *
     * @return
     */
    private abstract Object call(String methodName, Map<String, Object> arguments);

    /**
     * Handles a callout exception that can occur when calling the data vendor.
     *
     * @param calloutException
     *
     * @return
     */
    public void handleCallOutException(CalloutException calloutException) {
        String message = calloutException.getMessage();
        String faultCode = getFaultCode(message);
        switch on faultCode {
            when 'Client' {
                if (message.contains('Invalid authentication (You are not logged in)')) {
                    throw new CCWsClientAuthenticationException(Label.Error_Client_Authentication, calloutException);
                }
                throw new CCWsClientException(Label.Error_Webservice_Client, calloutException);
            }
            when 'Client.Authentication' {
                throw new CCWsClientAuthenticationException(Label.Error_Client_Authentication, calloutException);
            }
            when 'Client.Authentication.HostRestriction' {
                throw new CCWsClientAuthHostRestrictionException(Label.Error_Client_Hostrestriction, calloutException);
            }
            when 'Client.Authentication.Password' {
                throw new CCWsClientAuthPasswordException(Label.Error_Client_Authentication_Password, calloutException);
            }
            when 'Client.Authentication.Username' {
                throw new CCWsClientAuthUserNameException(Label.Error_Client_Authentication_Username, calloutException);
            }
            when 'Client.Authorization' {
                throw new CCWsClientAuthorizationException(Label.Error_Client_Authorization, calloutException);
            }
            when 'Client.Input' {
                throw new CCWsClientInputException(Label.Error_Client_Input, calloutException);
            }
            when 'Client.Input.FormatIncorrect' {
                throw new CCWsClientInputFormatIncorrectException(Label.Error_Client_Input_Format_Incorrect, calloutException);
            }
            when 'Client.Input.Incomplete' {
                throw new CCWsClientInputIncompleteException(Label.Error_Client_Input_Incomplete, calloutException);
            }
            when 'Client.Input.Invalid' {
                throw new CCWsClientInputInvalidException(Label.Error_Client_Input_Invalid, calloutException);
            }
            when 'Client.Input.Payment' {
                throw new CCWsClientPaymentException(Label.Error_Client_Payment, calloutException);
            }
            // ** SERVER **
            when 'Server' {
                if (message.contains('Vat number for business not found')) {
                    throw new CCWsServerDataNotFoundVatException(Label.VAT_Not_Found, calloutException);
                }
                throw new CCWsServerException(Label.Error_Webservice_Server, calloutException);
            }
            when 'Server.Data' {
                throw new CCWsServerDataException(Label.Error_Server_Data, calloutException);
            }
            when 'Server.Data.NotFound' {
                throw new CCWsServerDataNotFoundException(Label.Error_Server_Data_NotFound, calloutException);
            }
            when 'Server.Data.NotFound.Nbwo.EstimateUnavailable' {
                throw new CCWsServerDataNotFoundNbwoException(Label.Error_Server_Data_NotFound_Nbwo_EstimateUnavailable, calloutException);
            }
            when 'Server.Data.NotFound.Kadaster.NotDeliverable' {
                throw new CCWsServerDataNotFoundKadasterException(Label.Error_Server_Data_NotFound_Kadaster_NotDeliverable, calloutException);
            }
            when 'Server.Data.PageNotFound' {
                throw new CCWsServerDataPageNotFoundException(Label.Error_Server_Data_PageNotFound, calloutException);
            }
            when 'Server.Unavailable' {
                throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable, calloutException);
            }
            when 'Server.Unavailable.InternalError' {
                throw new CCWsServerUnavailableInternalException(Label.Error_Server_Unavailable_InternalError, calloutException);
            }
            when 'Server.Unavailable.Temporary' {
                throw new CCWsServerUnavailableTemporaryException(Label.Error_Server_Unavailable_Temporary, calloutException);
            }
            when else {
                throw new CCWsException(Label.Error_Unknown, calloutException);
            }
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
        Integer faultCodeStart = message.lastIndexOf('SOAP-ENV:') + 'SOAP-ENV:'.length();
        Integer faultCodeEnd = message.indexOf(' ', faultCodeStart);
        String faultCode = message.substring(faultCodeStart, faultCodeEnd);
        return faultCode;
    }

    /**
     * Gets the relevant part of the error message
     *
     * @param message
     *
     * @return
     */
    private String getErrorMessage(String message) {
        String returnValue = '';
        returnValue = message.removeStart('Web service callout failed: WebService returned a SOAP Fault: ');
        returnValue = message.substring(0, message.indexOf(' faultcode'));
        return returnValue;
    }

}