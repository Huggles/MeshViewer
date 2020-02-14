/**
* Created by appsolutely on 2020-02-11.
*/

public inherited sharing class WsInternationalAddress
{
    public static String login(String username,String password){
        return newInstance().login( username, password);
    }
    public static IWsInternationalAddress newInstance() {
        return (IWsInternationalAddress)Application.Service.newInstance(IWsInternationalAddress.class);
    }
}
