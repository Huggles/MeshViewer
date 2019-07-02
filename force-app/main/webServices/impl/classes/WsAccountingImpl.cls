/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public with sharing class WsAccountingImpl implements IWsAccounting {

    private AccountingWsdl.Webservices_nlPort port { get; set; }

    public WsAccountingImpl() {
        port =  new AccountingWsdl.Webservices_nlPort();
        port.HeaderLogin = new AccountingWsdl.HeaderLoginType();
        // TODO:  referral customers are stored as separate record in the mdt. The current query returns all records.
        ApplicationProperty__mdt applicationProperty = [
                SELECT
                        DataProviderAdminPassword__c,
                        DataProviderAdminUsername__c
                FROM ApplicationProperty__mdt];
        port.HeaderLogin.username = applicationProperty.DataProviderAdminUsername__c;
        port.HeaderLogin.password = applicationProperty.DataProviderAdminPassword__c;

    }

    public String login(String username, String password) {
        String returnValue = null;
        try {
            returnValue = port.login(username, password);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.login(username, password);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public AccountingWsdl.SessionPagedResult userSessionList(Integer userid, Integer page_x) {
        AccountingWsdl.SessionPagedResult returnValue = null;
        try {
            returnValue = port.userSessionList(userid, page_x);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.userSessionList(userid, page_x);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public void userEditV2(Integer userid, String email, String address, String contactname, String contactemail, String telephone, String fax, String password) {
        try {
            port.userEditV2(userid, email, address, contactname, contactemail, telephone, fax, password);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userEditV2(userid, email, address, contactname, contactemail, telephone, fax, password);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public AccountingWsdl.UserV2 userViewV2(Integer userid) {
        AccountingWsdl.UserV2 returnValue = null;
        try {
            returnValue = port.userViewV2(userid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.userViewV2(userid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public void userEditBalance(Integer userid, Double balance) {
        try {
            port.userEditBalance(userid, balance);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userEditBalance(userid, balance);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public AccountingWsdl.AccountOrderToken accountGetOrderToken(Integer accountid, String return_url) {
        AccountingWsdl.AccountOrderToken returnValue = null;
        try {
            returnValue = port.accountGetOrderToken(accountid, return_url);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.accountGetOrderToken(accountid, return_url);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public Double accountViewBalance(Integer accountid) {
        Double returnValue = null;
        try {
            returnValue = port.accountViewBalance(accountid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.accountViewBalance(accountid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public void userEditHostRestrictions(Integer userid, String restrictions) {
        try {
            port.userEditHostRestrictions(userid, restrictions);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userEditHostRestrictions(userid, restrictions);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public void userRemoveGroup(Integer userid, Integer usergroupid) {
        try {
            port.userRemoveGroup(userid, usergroupid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userRemoveGroup(userid, usergroupid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public void userChangePassword(Integer userid, String old_password, String new_password) {
        try {
            port.userChangePassword(userid, old_password, new_password);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userChangePassword(userid, old_password, new_password);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public void accountEditV2(Integer accountid, String address, String contactname, String contactemail, String telephone, String fax, String description, Double balancethreshold) {
        try {
            port.accountEditV2(accountid, address, contactname, contactemail, telephone, fax, description, balancethreshold);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.accountEditV2(accountid, address, contactname, contactemail, telephone, fax, description, balancethreshold);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public void logout() {
        try {
            port.logout();
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.logout();
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public Integer accountGetCreationStatus(String token) {
        Integer returnValue = null;
        try {
            returnValue = port.accountGetCreationStatus(token);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.accountGetCreationStatus(token);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public String accountViewHostRestrictions(Integer accountid) {
        String returnValue = null;
        try {
            returnValue = port.accountViewHostRestrictions(accountid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.accountViewHostRestrictions(accountid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public void accountEditHostRestrictions(Integer accountid, String restrictions) {
        try {
            port.accountEditHostRestrictions(accountid, restrictions);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.accountEditHostRestrictions(accountid, restrictions);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public String userNotify(Integer userid, String password) {
        String returnValue = null;
        try {
            returnValue = port.userNotify(userid, password);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.userNotify(userid, password);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public AccountingWsdl.UserGroupPagedResult userListAssignableGroups(Integer userid, Integer page_x) {
        AccountingWsdl.UserGroupPagedResult returnValue = null;
        try {
            returnValue = port.userListAssignableGroups(userid, page_x);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.userListAssignableGroups(userid, page_x);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public AccountingWsdl.UserV2PagedResult accountUserSearchV2(Integer accountid, String phrase, Integer page_x) {
        AccountingWsdl.UserV2PagedResult returnValue = null;
        try {
            returnValue = port.accountUserSearchV2(accountid, phrase, page_x);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.accountUserSearchV2(accountid, phrase, page_x);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public AccountingWsdl.userCreateV2ResponseType userCreateV2(Integer accountid, String nickname, String password, AccountingWsdl.intArray usergroups, String email, String companyname, String address, String contactname, String contactemail, String telephone, String fax, String clientcode, String comments) {
        AccountingWsdl.userCreateV2ResponseType returnValue = null;
        try {
            returnValue = port.userCreateV2(accountid, nickname, password, usergroups, email, companyname, address, contactname, contactemail, telephone, fax, clientcode, comments);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.userCreateV2(accountid, nickname, password, usergroups, email, companyname, address, contactname, contactemail, telephone, fax, clientcode, comments);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public void userEditExtendedV2(Integer userid, String nickname, String password, String email, String companyname, String address, String contactname, String contactemail, String telephone, String fax, String clientcode, String comments, Integer accountid, Double balancethreshold, String notificationrecipients) {
        try {
            port.userEditExtendedV2(userid, nickname, password, email, companyname, address, contactname, contactemail, telephone, fax, clientcode, comments, accountid, balancethreshold, notificationrecipients);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userEditExtendedV2(userid, nickname, password, email, companyname, address, contactname, contactemail, telephone, fax, clientcode, comments, accountid, balancethreshold, notificationrecipients);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public String userViewHostRestrictions(Integer userid) {
        String returnValue = null;
        try {
            returnValue = port.userViewHostRestrictions(userid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.userViewHostRestrictions(userid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public Double userViewBalance(Integer userid) {
        Double returnValue = null;
        try {
            returnValue = port.userViewBalance(userid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.userViewBalance(userid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public AccountingWsdl.UserCredentials createTestUser(String application, String email, String companyname, String contactname, String telephone) {
        AccountingWsdl.UserCredentials returnValue = null;
        try {
            returnValue = port.createTestUser(application, email, companyname, contactname, telephone);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.createTestUser(application, email, companyname, contactname, telephone);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public AccountingWsdl.AccountV2 accountViewV2(Integer accountid) {
        AccountingWsdl.AccountV2 returnValue = null;
        try {
            returnValue = port.accountViewV2(accountid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.accountViewV2(accountid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public AccountingWsdl.AccountCreationToken accountGetCreationToken(String return_url) {
        AccountingWsdl.AccountCreationToken returnValue = null;
        try {
            returnValue = port.accountGetCreationToken(return_url);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.accountGetCreationToken(return_url);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public AccountingWsdl.UserV2PagedResult accountUserListV2(Integer accountid, Integer page_x) {
        AccountingWsdl.UserV2PagedResult returnValue = null;
        try {
            returnValue = port.accountUserListV2(accountid, page_x);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.accountUserListV2(accountid, page_x);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public void userRemove(Integer userid) {
        try {
            port.userRemove(userid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userRemove(userid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public void userSessionRemove(Integer userid, String reactid) {
        try {
            port.userSessionRemove(userid, reactid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userSessionRemove(userid, reactid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

    public void userAddGroup(Integer userid, Integer usergroupid) {
        try {
            port.userAddGroup(userid, usergroupid);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.userAddGroup(userid, usergroupid);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }


}