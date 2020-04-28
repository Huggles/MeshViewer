/**
 * Created by jaapbranderhorst on 2019-06-29.
 * See https://webview.webservices.nl/documentation/files/service_accounting-php.html
 */

public interface IWsAccounting {
    String login(String username,String password);
    AccountingWsdl.SessionPagedResult userSessionList(Integer userid,Integer page_x);
    void userEditV2(Integer userid,String email,String address,String contactname,String contactemail,String telephone,
            String fax,String password);
    AccountingWsdl.UserV2 userViewV2(Integer userid);
    void userEditBalance(Integer userid,Double balance);
    AccountingWsdl.AccountOrderToken accountGetOrderToken(Integer accountid,String return_url);
    Double accountViewBalance(Integer accountid);
    void userEditHostRestrictions(Integer userid,String restrictions);
    void userRemoveGroup(Integer userid,Integer usergroupid);
    void userChangePassword(Integer userid,String old_password,String new_password);
    void accountEditV2(Integer accountid,String address,String contactname,String contactemail,String telephone,
            String fax,String description,Double balancethreshold);
    void logout();
    Integer accountGetCreationStatus(String token);
    String accountViewHostRestrictions(Integer accountid);
    void accountEditHostRestrictions(Integer accountid,String restrictions);
    String userNotify(Integer userid,String password);
    AccountingWsdl.UserGroupPagedResult userListAssignableGroups(Integer userid,Integer page_x);
    AccountingWsdl.UserV2PagedResult accountUserSearchV2(Integer accountid,String phrase,Integer page_x);
    AccountingWsdl.userCreateV2ResponseType userCreateV2(Integer accountid,String nickname,String password,
            AccountingWsdl.intArray usergroups,String email,String companyname,String address,String contactname,
            String contactemail,String telephone,String fax,String clientcode,String comments);
    void userEditExtendedV2(Integer userid,String nickname,String password,String email,String companyname,String address,String contactname,String contactemail,String telephone,String fax,String clientcode,String comments,Integer accountid,Double balancethreshold,String notificationrecipients);
    String userViewHostRestrictions(Integer userid);
    Double userViewBalance(Integer userid);
    AccountingWsdl.UserCredentials createTestUser(String application,String email,String companyname,String contactname,String telephone);
    AccountingWsdl.AccountV2 accountViewV2(Integer accountid);
    AccountingWsdl.AccountCreationToken accountGetCreationToken(String return_url);
    AccountingWsdl.UserV2PagedResult accountUserListV2(Integer accountid,Integer page_x);
    void userRemove(Integer userid);
    void userSessionRemove(Integer userid,String reactid);
    void userAddGroup(Integer userid,Integer usergroupid);

}