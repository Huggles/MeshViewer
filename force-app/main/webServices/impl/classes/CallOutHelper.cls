/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public with sharing class CallOutHelper {

    /**
     * Handles a callout exception that can occur when calling the data vendor.
     *
     * @param calloutException
     *
     * @return
     */
    public static Boolean handleCallOutException(CalloutException calloutException) {
        Boolean fallBack = false;
        String message = calloutException.getMessage();
        String faultCode = getFaultCode(message);
        switch on faultCode {
            when 'Client' {
                if (message.contains('Invalid authentication (You are not logged in)')) {
                    throw new CCWsClientAuthenticationException(Label.Error_Client_Authentication);
                }
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
                throw new CCWsServerDataException(Label.Error_Server_Data);
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
                fallBack = true;
                return fallBack;
            }
            when 'Server.Unavailable.InternalError' {
                ErrorLogUtil.logException(calloutException); // unexpected unavailability of primary server
                fallBack = true;
                return fallBack;
            }
            when 'Server.Unavailable.Temporary' {
                ErrorLogUtil.logException(calloutException); // unexpected unavailability of primary server
                fallBack = true;
                return fallBack;
            }
            when else {
                ErrorLogUtil.logException(calloutException); // ouch unknown exception
                throw new CCWsException(getErrorMessage(message), calloutException); // TODO: fix the message.
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
    private static String getFaultCode(String message) {
        Integer faultCodeStart = message.lastIndexOf('SOAP-ENV:') + 'SOAP-ENV:'.length();
        Integer faultCodeEnd = message.indexOf(' ', faultCodeStart);
        String faultCode = message.substring(faultCodeStart, faultCodeEnd);
        return faultCode;
    }

    private static String getErrorMessage(String message) {
        String returnValue = '';
        returnValue = message.removeStart('Web service callout failed: WebService returned a SOAP Fault: ');
        returnValue = message.substring(0, message.indexOf(' faultcode'));
        return returnValue;
    }

}