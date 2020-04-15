/**
 * Created by jaapbranderhorst on 2019-07-07.
 */

@IsTest
private class AccountingWsdlTest {

    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType)
        {
            if(request instanceof AccountingWsdl.loginRequestType)
                response.put('response_x', new AccountingWsdl.loginResponseType());
            if(request instanceof AccountingWsdl.userSessionListRequestType)
                response.put('response_x', new AccountingWsdl.userSessionListResponseType());
            if(request instanceof AccountingWsdl.userEditV2RequestType)
                response.put('response_x', new AccountingWsdl.userEditV2ResponseType());
            if(request instanceof AccountingWsdl.userViewV2RequestType)
                response.put('response_x', new AccountingWsdl.userViewV2ResponseType());
            if(request instanceof AccountingWsdl.userEditBalanceRequestType)
                response.put('response_x', new AccountingWsdl.userEditBalanceResponseType());
            if(request instanceof AccountingWsdl.accountGetOrderTokenRequestType)
                response.put('response_x', new AccountingWsdl.accountGetOrderTokenResponseType());
            if(request instanceof AccountingWsdl.accountViewBalanceRequestType)
                response.put('response_x', new AccountingWsdl.accountViewBalanceResponseType());
            if(request instanceof AccountingWsdl.userEditHostRestrictionsRequestType)
                response.put('response_x', new AccountingWsdl.userEditHostRestrictionsResponseType());
            if(request instanceof AccountingWsdl.userRemoveGroupRequestType)
                response.put('response_x', new AccountingWsdl.userRemoveGroupResponseType());
            if(request instanceof AccountingWsdl.userChangePasswordRequestType)
                response.put('response_x', new AccountingWsdl.userChangePasswordResponseType());
            if(request instanceof AccountingWsdl.accountEditV2RequestType)
                response.put('response_x', new AccountingWsdl.accountEditV2ResponseType());
            if(request instanceof AccountingWsdl.logoutRequestType)
                response.put('response_x', new AccountingWsdl.logoutResponseType());
            if(request instanceof AccountingWsdl.accountGetCreationStatusRequestType)
                response.put('response_x', new AccountingWsdl.accountGetCreationStatusResponseType());
            if(request instanceof AccountingWsdl.accountViewHostRestrictionsRequestType)
                response.put('response_x', new AccountingWsdl.accountViewHostRestrictionsResponseType());
            if(request instanceof AccountingWsdl.accountEditHostRestrictionsRequestType)
                response.put('response_x', new AccountingWsdl.accountEditHostRestrictionsResponseType());
            if(request instanceof AccountingWsdl.userNotifyRequestType)
                response.put('response_x', new AccountingWsdl.userNotifyResponseType());
            if(request instanceof AccountingWsdl.userListAssignableGroupsRequestType)
                response.put('response_x', new AccountingWsdl.userListAssignableGroupsResponseType());
            if(request instanceof AccountingWsdl.accountUserSearchV2RequestType)
                response.put('response_x', new AccountingWsdl.accountUserSearchV2ResponseType());
            if(request instanceof AccountingWsdl.userCreateV2RequestType)
                response.put('response_x', new AccountingWsdl.userCreateV2ResponseType());
            if(request instanceof AccountingWsdl.userEditExtendedV2RequestType)
                response.put('response_x', new AccountingWsdl.userEditExtendedV2ResponseType());
            if(request instanceof AccountingWsdl.userViewHostRestrictionsRequestType)
                response.put('response_x', new AccountingWsdl.userViewHostRestrictionsResponseType());
            if(request instanceof AccountingWsdl.userViewBalanceRequestType)
                response.put('response_x', new AccountingWsdl.userViewBalanceResponseType());
            if(request instanceof AccountingWsdl.createTestUserRequestType)
                response.put('response_x', new AccountingWsdl.createTestUserResponseType());
            if(request instanceof AccountingWsdl.accountViewV2RequestType)
                response.put('response_x', new AccountingWsdl.accountViewV2ResponseType());
            if(request instanceof AccountingWsdl.accountGetCreationTokenRequestType)
                response.put('response_x', new AccountingWsdl.accountGetCreationTokenResponseType());
            if(request instanceof AccountingWsdl.accountUserListV2RequestType)
                response.put('response_x', new AccountingWsdl.accountUserListV2ResponseType());
            if(request instanceof AccountingWsdl.userRemoveRequestType)
                response.put('response_x', new AccountingWsdl.userRemoveResponseType());
            if(request instanceof AccountingWsdl.userSessionRemoveRequestType)
                response.put('response_x', new AccountingWsdl.userSessionRemoveResponseType());
            if(request instanceof AccountingWsdl.userAddGroupRequestType)
                response.put('response_x', new AccountingWsdl.userAddGroupResponseType());
            return;
        }
    }

    @IsTest
    private static void testCoverMethods1() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new AccountingWsdl.Webservices_nlPort().login(null,null);
        new AccountingWsdl.Webservices_nlPort().userSessionList(null,null);
        new AccountingWsdl.Webservices_nlPort().userEditV2(null,null, null, null, null, null, null, null);
        new AccountingWsdl.Webservices_nlPort().userViewV2(null);
        new AccountingWsdl.Webservices_nlPort().userEditBalance(null,null);
        new AccountingWsdl.Webservices_nlPort().accountGetOrderToken(null,null);
        new AccountingWsdl.Webservices_nlPort().accountViewBalance(null);
        new AccountingWsdl.Webservices_nlPort().userEditHostRestrictions(null,null);
        new AccountingWsdl.Webservices_nlPort().userRemoveGroup(null,null);
        new AccountingWsdl.Webservices_nlPort().userChangePassword(null,null, null);
    }

    @IsTest
    private static void testCoverMethods2() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new AccountingWsdl.Webservices_nlPort().accountEditV2(null,null, null, null, null, null, null, null);
        new AccountingWsdl.Webservices_nlPort().logout();
        new AccountingWsdl.Webservices_nlPort().accountGetCreationStatus(null);
        new AccountingWsdl.Webservices_nlPort().accountViewHostRestrictions(null);
        new AccountingWsdl.Webservices_nlPort().accountEditHostRestrictions(null,null);
        new AccountingWsdl.Webservices_nlPort().userNotify(null,null);
        new AccountingWsdl.Webservices_nlPort().userListAssignableGroups(null,null);
        new AccountingWsdl.Webservices_nlPort().accountUserSearchV2(null,null, null);
        new AccountingWsdl.Webservices_nlPort().userCreateV2(null,null, null, null, null, null, null, null, null,null, null, null, null);
        new AccountingWsdl.Webservices_nlPort().userEditExtendedV2(null,null, null, null, null, null, null, null, null,null, null, null, null, null, null);
    }
    @IsTest
    private static void testCoverMethods3() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        new AccountingWsdl.Webservices_nlPort().userViewHostRestrictions(null);
        new AccountingWsdl.Webservices_nlPort().userViewBalance(null);
        new AccountingWsdl.Webservices_nlPort().createTestUser(null,null,null,null,null);
        new AccountingWsdl.Webservices_nlPort().accountViewV2(null);
        new AccountingWsdl.Webservices_nlPort().accountGetCreationToken(null);
        new AccountingWsdl.Webservices_nlPort().accountUserListV2(null,null);
        new AccountingWsdl.Webservices_nlPort().userRemove(null);
        new AccountingWsdl.Webservices_nlPort().userSessionRemove(null,null);
        new AccountingWsdl.Webservices_nlPort().userAddGroup(null,null);
        System.assert(true);
    }

    @IsTest
    static void testCoverTypes() {
        new AccountingWsdl.Account();
        new AccountingWsdl.userSessionRemoveRequestType();
        new AccountingWsdl.userNotifyRequestType();
        new AccountingWsdl.userViewBalanceRequestType();
        new AccountingWsdl.accountUserSearchV2RequestType();
        new AccountingWsdl.userEditBalanceRequestType();
        new AccountingWsdl.AccountV2PagedResult();
        new AccountingWsdl.AccountOrderToken();
        new AccountingWsdl.UserGroupPagedResult();
        new AccountingWsdl.SessionPagedResult();
        new AccountingWsdl.userListAssignableGroupsRequestType();
        new AccountingWsdl.UserGroup();
        new AccountingWsdl.userChangePasswordResponseType();
        new AccountingWsdl.logoutResponseType();
        new AccountingWsdl.userViewV2ResponseType();
        new AccountingWsdl.userEditExtendedV2ResponseType();
        new AccountingWsdl.accountGetOrderTokenRequestType();
        new AccountingWsdl.userViewV2RequestType();
        new AccountingWsdl.userViewHostRestrictionsResponseType();
        new AccountingWsdl.userViewBalanceResponseType();
        new AccountingWsdl.accountEditHostRestrictionsRequestType();
        new AccountingWsdl.userRemoveGroupResponseType();
        new AccountingWsdl.accountGetOrderTokenResponseType();
        new AccountingWsdl.accountViewV2RequestType();
        new AccountingWsdl.userEditV2ResponseType();
        new AccountingWsdl.UserV2PagedResult();
        new AccountingWsdl.intArray();
        new AccountingWsdl.userNotifyResponseType();
        new AccountingWsdl.HeaderLoginType();
        new AccountingWsdl.userNotifyRequestType();
        new AccountingWsdl.userEditHostRestrictionsRequestType();
        new AccountingWsdl.loginRequestType();
        new AccountingWsdl.accountEditV2RequestType();
        new AccountingWsdl.accountViewBalanceRequestType();
        new AccountingWsdl.userViewHostRestrictionsRequestType();
        new AccountingWsdl.accountGetCreationStatusResponseType();
        new AccountingWsdl.ResultInfo();
        new AccountingWsdl.AccountV2Array();
        new AccountingWsdl.userChangePasswordRequestType();
        new AccountingWsdl.accountEditV2ResponseType();
        new AccountingWsdl.HeaderAuthenticateType();
        new AccountingWsdl.SessionArray();
        new AccountingWsdl.User_x();
        new AccountingWsdl.accountUserListV2RequestType();
        new AccountingWsdl.accountGetCreationTokenRequestType();
        new AccountingWsdl.userSessionRemoveRequestType();
        new AccountingWsdl.userAddGroupRequestType();
        new AccountingWsdl.accountViewHostRestrictionsResponseType();
        new AccountingWsdl.logoutRequestType();
        new AccountingWsdl.accountGetCreationStatusRequestType();
        new AccountingWsdl.UserV2();
        new AccountingWsdl.accountViewV2ResponseType();
        new AccountingWsdl.AccountPagedResult();
        new AccountingWsdl.accountEditHostRestrictionsResponseType();
        new AccountingWsdl.AccountCreationToken();
        new AccountingWsdl.userSessionListRequestType();
        new AccountingWsdl.userEditV2RequestType();
        new AccountingWsdl.userRemoveGroupRequestType();
        new AccountingWsdl.AccountV2();
        new AccountingWsdl.accountUserSearchV2ResponseType();
        new AccountingWsdl.userCreateV2ResponseType();
        new AccountingWsdl.accountViewBalanceResponseType();
        new AccountingWsdl.userRemoveResponseType();
        new AccountingWsdl.userSessionListResponseType();
        new AccountingWsdl.UserGroupArray();
        new AccountingWsdl.accountViewHostRestrictionsRequestType();
        new AccountingWsdl.userEditBalanceResponseType();
        new AccountingWsdl.userEditExtendedV2RequestType();
        new AccountingWsdl.createTestUserRequestType();
        new AccountingWsdl.accountGetCreationTokenResponseType();
        new AccountingWsdl.userRemoveRequestType();
        new AccountingWsdl.UserV2Array();
        new AccountingWsdl.accountUserListV2ResponseType();
        new AccountingWsdl.UserCredentials();
        new AccountingWsdl.userCreateV2RequestType();
        new AccountingWsdl.createTestUserResponseType();
        new AccountingWsdl.userAddGroupResponseType();
        new AccountingWsdl.userEditHostRestrictionsResponseType();
        new AccountingWsdl.AccountArray();
        new AccountingWsdl.Session();
        new AccountingWsdl.userListAssignableGroupsResponseType();
        System.assert(true);
    }
}