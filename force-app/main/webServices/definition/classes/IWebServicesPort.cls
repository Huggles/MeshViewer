/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public interface IWebServicesPort {

    /**
     * Execute a callout to the Company Info backend
     *
     * @param scope the authentication scope
     * @param request_x
     * @param response_map_x
     * @param infoArray
     */
    void executeCallout(String scope, Object request_x, Map<String,Object> response_map_x, List<String> infoArray);

}