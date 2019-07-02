/**
 * Created by jaapbranderhorst on 2019-06-27.
 */

public with sharing virtual class CCWsException extends CCException {

    public String faultCode { get; private set; }
    public String soapMessage { get; private set; }
    public String[] faultCodeParts { get; private set; }

    public CCWsException(String faultCode, String soapMessage, String[] faultCodeParts) {

    }

}