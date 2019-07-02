/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public with sharing class WsAccounting {
    public static String login(String username, String password) {
        return newInstance().login(username, password);
    }

    public static AccountingWsdl.SessionPagedResult userSessionList(Integer userid, Integer page_x) {
        return newInstance().userSessionList(userid, page_x);
    }

    public static void userEditV2(Integer userid, String email, String address, String contactname, String contactemail, String telephone, String fax, String password) {
        newInstance().userEditV2(userid, email, address, contactname, contactemail, telephone, fax, password);
    }

    public static AccountingWsdl.UserV2 userViewV2(Integer userid) {
        return newInstance().userViewV2(userid);
    }

    public static void userEditBalance(Integer userid, Double balance) {
        newInstance().userEditBalance(userid, balance);
    }

    public static AccountingWsdl.AccountOrderToken accountGetOrderToken(Integer accountid,String return_url) {
        return newInstance().accountGetOrderToken(accountid, return_url);
    }

    public static Double accountViewBalance(Integer accountid) {
        return newInstance().accountViewBalance(accountid);
    }

    public static void userEditHostRestrictions(Integer userid, String restrictions) {
        newInstance().userEditHostRestrictions(userid, restrictions);
    }

    public static void userRemoveGroup(Integer userid, Integer usergroupid) {
        newInstance().userRemoveGroup(userid, usergroupid);
    }

    public static void userChangePassword(Integer userid, String old_password, String new_password) {
        newInstance().userChangePassword(userid, old_password, new_password);
    }

    public static void accountEditV2(Integer accountid, String address, String contactname, String contactemail, String telephone, String fax, String description, Double balancethreshold) {
        newInstance().accountEditV2(accountid, address, contactname, contactemail, telephone, fax, description, balancethreshold);
    }

    public static void logout() {
        newInstance().logout();
    }

    public static Integer accountGetCreationStatus(String token) {
        return newInstance().accountGetCreationStatus(token);
    }

    public static String accountViewHostRestrictions(Integer accountid) {
        return newInstance().accountViewHostRestrictions(accountid);
    }

    public static void accountEditHostRestrictions(Integer accountid, String restrictions) {
        newInstance().accountEditHostRestrictions(accountid, restrictions);
    }

    public static String userNotify(Integer userid, String password) {
        return newInstance().userNotify(userid, password);
    }

    public static AccountingWsdl.UserGroupPagedResult userListAssignableGroups(Integer userid, Integer page_x) {
        return newInstance().userListAssignableGroups(userid, page_x);
    }

    public static AccountingWsdl.UserV2PagedResult accountUserSearchV2(Integer accountid, String phrase, Integer page_x) {
        return newInstance().accountUserSearchV2(accountid, phrase, page_x);
    }

    public static AccountingWsdl.userCreateV2ResponseType userCreateV2(Integer accountid, String nickname, String password, AccountingWsdl.intArray usergroups, String email, String companyname, String address, String contactname, String contactemail, String telephone, String fax, String clientcode, String comments) {
        return newInstance().userCreateV2(accountid, nickname, password, usergroups, email, companyname, address, contactname, contactemail, telephone, fax, clientcode, comments);
    }

    public static void userEditExtendedV2(Integer userid, String nickname, String password, String email, String companyname, String address, String contactname, String contactemail, String telephone, String fax, String clientcode, String comments, Integer accountid, Double balancethreshold, String notificationrecipients) {
        newInstance().userEditExtendedV2(userid, nickname, password, email, companyname, address, contactname, contactemail, telephone, fax, clientcode, comments, accountid, balancethreshold, notificationrecipients);
    }

    public static String userViewHostRestrictions(Integer userid) {
        return newInstance().userViewHostRestrictions(userid);
    }

    public static Double userViewBalance(Integer userid) {
        return newInstance().userViewBalance(userid);
    }

    public static AccountingWsdl.UserCredentials createTestUser(String application, String email, String companyname, String contactname, String telephone) {
        return newInstance().createTestUser(application, email, companyname, contactname, telephone);
    }

    public static AccountingWsdl.AccountV2 accountViewV2(Integer accountid) {
        return newInstance().accountViewV2(accountid);
    }

    public static AccountingWsdl.AccountCreationToken accountGetCreationToken(String return_url) {
        return newInstance().accountGetCreationToken(return_url);
    }

    public static AccountingWsdl.UserV2PagedResult accountUserListV2(Integer accountid, Integer page_x) {
        return newInstance().accountUserListV2(accountid, page_x);
    }

    public static void userRemove(Integer userid) {
        newInstance().userRemove(userid);
    }

    public static void userSessionRemove(Integer userid, String reactid) {
        newInstance().userSessionRemove(userid, reactid);
    }

    public static void userAddGroup(Integer userid, Integer usergroupid) {
        newInstance().userAddGroup(userid, usergroupid);
    }


    public static IWsAccounting newInstance() {
        return (IWsAccounting) Application.Service.newInstance(IWsAccounting.class);
    }

}