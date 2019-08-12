/**
 * Created by jaapbranderhorst on 2019-07-11.
 *
 * Interface to indicate that the implementing object is a webservice port with fallback capabilities. Used in the callout framework.
 * Usage: have every port from a generated WSDL implement this class so you can use it as port in the CallOutHelper
 */

public interface FallBackableWebServicePort extends WebServicePort {
    /**
     * Set all relevant properties on the port to do the fallback (endpoint).
     */
    void doFallBack();

}