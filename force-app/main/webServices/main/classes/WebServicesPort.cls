/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public with sharing class WebServicesPort {

    public static final String ADMIN_SCOPE = 'Admin';
    public static final String USER_SCOPE = 'User';

    public static void executeCallout(String scope, Object request_x, Map<String,Object> response_map_x, List<String> infoArray) {
        newInstance().executeCallout(scope, request_x, response_map_x, infoArray);
    }

    public static IWebServicesPort newInstance() {
        return (IWebServicesPort) Application.Service.newInstance(IWebServicesPort.class);
    }

}