/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public with sharing class WsAccountingImpl implements IWsAccounting {

    private class AccountingMethodCallOut extends MethodCallout {

        public Object call(String methodName, Map<String,Object> arguments) {
            AccountingWsdl.Webservices_nlPort port = (AccountingWsdl.Webservices_nlPort)this.port;
            switch on methodName {
                when 'login' {
                    return port.login((String)arguments.get('username'), (String)arguments.get('password'));
                }
                when 'userSessionList' {
                    return port.userSessionList((Integer)arguments.get('userid'), (Integer)arguments.get('page_x'));
                }
                when 'userEditV2' {
                    port.userEditV2(
                            (Integer)arguments.get('userid'),
                            (String)arguments.get('email'),
                            (String)arguments.get('address'),
                            (String)arguments.get('contactname'),
                            (String)arguments.get('contactemail'),
                            (String)arguments.get('telephone'),
                            (String)arguments.get('fax'),
                            (String)arguments.get('password')
                    );
                }
                when 'userViewV2' {
                    return port.userViewV2((Integer)arguments.get('userid'));
                }
                when 'userEditBalance' {
                    port.userEditBalance((Integer)arguments.get('userid'), (Double)arguments.get('balance'));
                }
                when 'accountGetOrderToken' {
                    return port.accountGetOrderToken((Integer)arguments.get('accountid'), (String)arguments.get('return_url'));
                }
                when 'accountViewBalance' {
                    return port.accountViewBalance((Integer)arguments.get('accountid'));
                }
                when 'userEditHostRestrictions' {
                    port.userEditHostRestrictions((Integer)arguments.get('userid'), (String)arguments.get('restrictions'));
                }
                when 'userRemoveGroup' {
                    port.userRemoveGroup((Integer)arguments.get('userid'), (Integer)arguments.get('usergroupid'));
                }
                when 'userChangePassword' {
                    port.userChangePassword((Integer)arguments.get('userid'), (String)arguments.get('old_password'), (String)arguments.get('new_password'));
                }
                when 'accountEditV2' {
                    port.accountEditV2(
                            (Integer)arguments.get('accountid'),
                            (String)arguments.get('address'),
                            (String)arguments.get('contactname'),
                            (String)arguments.get('contactemail'),
                            (String)arguments.get('telephone'),
                            (String)arguments.get('fax'),
                            (String)arguments.get('description'),
                            (Double)arguments.get('balancethreshold')
                    );
                }
                when 'logout' {
                    port.logout();
                }
                when 'accountGetCreationStatus' {
                    return port.accountGetCreationStatus((String)arguments.get('token'));
                }
                when 'accountViewHostRestrictions' {
                    return port.accountViewHostRestrictions((Integer)arguments.get('accountid'));
                }
                when 'accountEditHostRestrictions' {
                    port.accountEditHostRestrictions((Integer)arguments.get('accountid'), (String)arguments.get('restrictions'));
                }
                when 'userNotify' {
                    return port.userNotify((Integer)arguments.get('userid'), (String)arguments.get('password'));
                }
                when 'userListAssignableGroups' {
                    return port.userListAssignableGroups((Integer)arguments.get('userid'), (Integer)arguments.get('page_x'));
                }
                when 'accountUserSearchV2' {
                    return port.accountUserSearchV2((Integer)arguments.get('accountid'), (String)arguments.get('phrase'), (Integer)arguments.get('page_x'));
                }when 'userCreateV2' {
                    return port.userCreateV2(
                            (Integer)arguments.get('accountid'),
                            (String)arguments.get('nickname'),
                            (String)arguments.get('password'),
                            (AccountingWsdl.intArray)arguments.get('usergroups'),
                            (String)arguments.get('email'),
                            (String)arguments.get('companyname'),
                            (String)arguments.get('address'),
                            (String)arguments.get('contactname'),
                            (String)arguments.get('contactemail'),
                            (String)arguments.get('telephone'),
                            (String)arguments.get('fax'),
                            (String)arguments.get('clientcode'),
                            (String)arguments.get('comments')
                    );
                }when 'userEditExtendedV2' {
                    port.userEditExtendedV2(
                            (Integer)arguments.get('userid'),
                            (String)arguments.get('nickname'),
                            (String)arguments.get('password'),
                            (String)arguments.get('email'),
                            (String)arguments.get('companyname'),
                            (String)arguments.get('address'),
                            (String)arguments.get('contactname'),
                            (String)arguments.get('contactemail'),
                            (String)arguments.get('telephone'),
                            (String)arguments.get('fax'),
                            (String)arguments.get('clientcode'),
                            (String)arguments.get('comments'),
                            (Integer)arguments.get('accountid'),
                            (Double)arguments.get('balancethreshold'),
                            (String)arguments.get('notificationrecipients')
                    );
                }
                when 'userViewHostRestrictions' {
                    return port.userViewHostRestrictions((Integer)arguments.get('userid'));
                }
                when 'userViewBalance' {
                    return port.userViewBalance((Integer)arguments.get('userid'));
                }
                when 'createTestUser' {
                    return port.createTestUser(
                            (String)arguments.get('application'),
                            (String)arguments.get('email'),
                            (String)arguments.get('companyname'),
                            (String)arguments.get('contactname'),
                            (String)arguments.get('telephone')
                    );
                }
                when 'accountViewV2' {
                    return port.accountViewV2((Integer)arguments.get('accountid'));
                }
                when 'accountGetCreationToken' {
                    return port.accountGetCreationToken((String)arguments.get('return_url'));
                }
                when 'accountUserListV2' {
                    return port.accountUserListV2((Integer)arguments.get('accountid'), (Integer)arguments.get('page_x'));
                }
                when 'userRemove' {
                    port.userRemove((Integer)arguments.get('userid'));
                }
                when 'userSessionRemove' {
                    port.userSessionRemove((Integer)arguments.get('userid'), (String)arguments.get('reactid'));
                }
                when 'userAddGroup' {
                    port.userAddGroup((Integer)arguments.get('userid'), (Integer)arguments.get('usergroupid'));
                }
                when else {
                    throw new CCWsException('Method ' + methodName + ' not implemented');
                }
            }
            return null;
        }

        public AccountingMethodCallOut(AccountingWsdl.Webservices_nlPort port) {
            super(port);
        }
    }

    private AccountingMethodCallOut methodCallOut { get; set; }

    private AccountingWsdl.Webservices_nlPort port { get; set; }



    public WsAccountingImpl() {
        port =  new AccountingWsdl.Webservices_nlPort();
        port.HeaderLogin = new AccountingWsdl.HeaderLoginType();
        // TODO:  referral customers are stored as separate record in the mdt. The current query returns all records.
        ApplicationProperty__mdt applicationProperty = [
                SELECT
                        DataProviderAdminPassword__c,
                        DataProviderAdminUsername__c
                FROM ApplicationProperty__mdt LIMIT 1];
        port.HeaderLogin.username = applicationProperty.DataProviderAdminUsername__c;
        port.HeaderLogin.password = applicationProperty.DataProviderAdminPassword__c;

        methodCallOut = new AccountingMethodCallOut(port);

    }

    public String login(String username, String password) {
        return (String)methodCallOut.callOut('login', new Map<String, Object>{
                'username' => username,
                'password' => password
        });
    }

    public AccountingWsdl.SessionPagedResult userSessionList(Integer userid, Integer page_x) {
        return (AccountingWsdl.SessionPagedResult)methodCallOut.callOut('userSessionList', new Map<String, Object>{
                'userid' => userid,
                'page_x' => page_x
        });

    }

    public void userEditV2(Integer userid, String email, String address, String contactname, String contactemail, String telephone, String fax, String password) {
        methodCallOut.callOut('userEditV2', new Map<String, Object>{
                'userid' => userid,
                'email' => email,
                'address' => address,
                'contactname' => contactname,
                'contactemail' => contactemail,
                'telephone' => telephone,
                'fax' => fax,
                'password' => password
        });
    }

    public AccountingWsdl.UserV2 userViewV2(Integer userid) {
        return (AccountingWsdl.UserV2)methodCallOut.callOut('userViewV2', new Map<String, Object>{
                'userid' => userid
        });
    }

    public void userEditBalance(Integer userid, Double balance) {
        methodCallOut.callOut('userEditBalance', new Map<String, Object>{
                'userid' => userid,
                'balance' => balance
        });
    }

    public AccountingWsdl.AccountOrderToken accountGetOrderToken(Integer accountid, String return_url) {
        return (AccountingWsdl.AccountOrderToken)methodCallOut.callOut('accountGetOrderToken', new Map<String, Object>{
                'accountid' => accountid,
                'return_url' => return_url
        });
    }

    public Double accountViewBalance(Integer accountid) {
        return (Double)methodCallOut.callOut('accountViewBalance', new Map<String, Object>{
                'accountid' => accountid
        });
    }

    public void userEditHostRestrictions(Integer userid, String restrictions) {
        methodCallOut.callOut('userEditHostRestrictions', new Map<String, Object>{
                'userid' => userid,
                'restrictions' => restrictions
        });
    }

    public void userRemoveGroup(Integer userid, Integer usergroupid) {
        methodCallOut.callOut('userRemoveGroup', new Map<String, Object>{
                'userid' => userid,
                'usergroupid' => usergroupid
        });
    }

    public void userChangePassword(Integer userid, String old_password, String new_password) {
        methodCallOut.callOut('userChangePassword', new Map<String, Object>{
                'userid' => userid,
                'old_password' => old_password,
                'new_password' => new_password
        });
    }

    public void accountEditV2(Integer accountid, String address, String contactname, String contactemail, String telephone, String fax, String description, Double balancethreshold) {
        methodCallOut.callOut('accountEditV2', new Map<String, Object>{
                'accountid' => accountid,
                'address' => address,
                'contactname' => contactname,
                'contactemail' => contactemail,
                'telephone' => telephone,
                'fax' => fax,
                'description' => description,
                'balancethreshold' => balancethreshold
        });
    }

    public void logout() {
        methodCallOut.callOut('logout', new Map<String, Object>{});
    }

    public Integer accountGetCreationStatus(String token) {
        return (Integer)methodCallOut.callOut('accountGetCreationStatus', new Map<String, Object>{
                'token' => token
        });
    }

    public String accountViewHostRestrictions(Integer accountid) {
        return (String)methodCallOut.callOut('accountViewHostRestrictions', new Map<String, Object>{
                'accountid' => accountid
        });
    }

    public void accountEditHostRestrictions(Integer accountid, String restrictions) {
        methodCallOut.callOut('accountEditHostRestrictions', new Map<String, Object>{
                'accountid' => accountid,
                'restrictions' => restrictions
        });
    }

    public String userNotify(Integer userid, String password) {
        return (String)methodCallOut.callOut('userNotify', new Map<String, Object>{
                'userid' => userid,
                'password' => password
        });
    }

    public AccountingWsdl.UserGroupPagedResult userListAssignableGroups(Integer userid, Integer page_x) {
        return (AccountingWsdl.UserGroupPagedResult)methodCallOut.callOut('userListAssignableGroups', new Map<String, Object>{
                'userid' => userid,
                'page_x' => page_x
        });
    }

    public AccountingWsdl.UserV2PagedResult accountUserSearchV2(Integer accountid, String phrase, Integer page_x) {
        return (AccountingWsdl.UserV2PagedResult)methodCallOut.callOut('accountUserSearchV2', new Map<String, Object>{
                'accountid' => accountid,
                'phrase' => phrase,
                'page_x' => page_x
        });
    }

    public AccountingWsdl.userCreateV2ResponseType userCreateV2(Integer accountid, String nickname, String password, AccountingWsdl.intArray usergroups, String email, String companyname, String address, String contactname, String contactemail, String telephone, String fax, String clientcode, String comments) {
        return (AccountingWsdl.userCreateV2ResponseType)methodCallOut.callOut('userCreateV2', new Map<String, Object>{
                'accountid' => accountid,
                'address' => address,
                'contactname' => contactname,
                'contactemail' => contactemail,
                'telephone' => telephone,
                'fax' => fax,
                'usergroups' => usergroups,
                'email' => email,
                'nickname' => nickname,
                'password' => password,
                'companyname' => companyname,
                'clientcode' => clientcode,
                'comments' => comments
        });
    }

    public void userEditExtendedV2(Integer userid, String nickname, String password, String email, String companyname, String address, String contactname, String contactemail, String telephone, String fax, String clientcode, String comments, Integer accountid, Double balancethreshold, String notificationrecipients) {
        methodCallOut.callOut('userEditExtendedV2', new Map<String, Object>{
                'userid' => userid,
                'nickname' => nickname,
                'password' => password,
                'email' => email,
                'companyname' => companyname,
                'address' => address,
                'contactname' => contactname,
                'contactemail' => contactemail,
                'telephone' => telephone,
                'fax' => fax,
                'clientcode' => clientcode,
                'comments' => comments,
                'accountid' => accountid,
                'balancethreshold' => balancethreshold,
                'notificationrecipients' => notificationrecipients
        });
    }

    public String userViewHostRestrictions(Integer userid) {
        return (String)methodCallOut.callOut('userViewHostRestrictions', new Map<String, Object>{
                'userid' => userid
        });
    }

    public Double userViewBalance(Integer userid) {
        return (Double)methodCallOut.callOut('userViewBalance', new Map<String, Object>{
                'userid' => userid
        });
    }

    public AccountingWsdl.UserCredentials createTestUser(String application, String email, String companyname, String contactname, String telephone) {
        return (AccountingWsdl.UserCredentials)methodCallOut.callOut('createTestUser', new Map<String, Object>{
                'application' => application,
                'email' => email,
                'companyname' => companyname,
                'contactname' => contactname,
                'telephone' => telephone
        });
    }

    public AccountingWsdl.AccountV2 accountViewV2(Integer accountid) {
        return (AccountingWsdl.AccountV2)methodCallOut.callOut('accountViewV2', new Map<String, Object>{
                'accountid' => accountid
        });
    }

    public AccountingWsdl.AccountCreationToken accountGetCreationToken(String return_url) {
        return (AccountingWsdl.AccountCreationToken)methodCallOut.callOut('accountGetCreationToken', new Map<String, Object>{
                'return_url' => return_url
        });
    }

    public AccountingWsdl.UserV2PagedResult accountUserListV2(Integer accountid, Integer page_x) {
        return (AccountingWsdl.UserV2PagedResult)methodCallOut.callOut('accountUserListV2', new Map<String, Object>{
                'accountid' => accountid,
                'page_x' => page_x
        });
    }

    public void userRemove(Integer userid) {
        methodCallOut.callOut('userRemove', new Map<String, Object>{
                'userid' => userid
        });
    }

    public void userSessionRemove(Integer userid, String reactid) {
        methodCallOut.callOut('userSessionRemove', new Map<String, Object>{
                'userid' => userid,
                'reactid' => reactid
        });
    }

    public void userAddGroup(Integer userid, Integer usergroupid) {
        methodCallOut.callOut('userAddGroup', new Map<String, Object>{
                'userid' => userid,
                'usergroupid' => usergroupid
        });
    }


}