@isTest
public with sharing class WebServicesNLSOAPAccountingImplTest {



@isTest
public static void testUserGetBalanceSuccess(){

    Test.setMock(WebServiceMock.class, new userViewBalanceSuccessMockImpl());
   
    Test.startTest();
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        DutchBusinessAccountingDto.userViewBalanceResponse response = service.userGetBalance(new DutchBusinessAccountingDto.userViewBalanceRequest());
        Test.stopTest();
        system.assertEquals(response.balance,1234);

}
@isTest
public static void testUserGetBalanceFailure(){

    Test.setMock(WebServiceMock.class, new CalloutFailureMockImpl());
    boolean flag = false;
    Test.startTest();
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        try{
            DutchBusinessAccountingDto.userViewBalanceResponse response = service.userGetBalance(new DutchBusinessAccountingDto.userViewBalanceRequest());
        }catch(CCException e){
            flag = true;
        }
        Test.stopTest();
        system.assert(flag);

}

@isTest 
public static void testUserChangeBalanceSuccess(){

    Test.setMock(WebServiceMock.class, new userEditBalanceSuccessMockImpl());
   
    Test.startTest();
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        boolean response = service.userChangeBalance(new DutchBusinessAccountingDto.userChangeBalanceRequestDto());
        Test.stopTest();
        system.assert(response);

}
@isTest 
public static void testUserChangeBalanceFailure(){
    boolean flag = false;
    Test.setMock(WebServiceMock.class, new CalloutFailureMockImpl());
   
    Test.startTest();
    try{
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        boolean response = service.userChangeBalance(new DutchBusinessAccountingDto.userChangeBalanceRequestDto());
    }catch(CCException e){
        flag = true;
    }
        Test.stopTest();
        system.assert(flag);

}
@isTest 
public static void testUserCreateSuccess(){

    Test.setMock(WebServiceMock.class, new UserCreateV2SuccessMockImpl());   
    Test.startTest();
        //DutchBusinessAccountingDto.UserCreateRequestDto input = new DutchBusinessAccountingDto.UserCreateRequestDto();
        //input.usergroups=new list<Integer>();
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        DutchBusinessAccountingDto.userCreateResponseDto response = service.userCreate(new DutchBusinessAccountingDto.UserCreateRequestDto());
        Test.stopTest();
        system.assertEquals(response.nickname,'test');
        system.assertEquals(response.Id,1234);
        system.assertEquals(response.password,'test');
}
@isTest 
public static void testUserCreateFailure(){

    boolean flag = false;
    Test.setMock(WebServiceMock.class, new CalloutFailureMockImpl());  
    Test.startTest();
    try{
        IWebServicesNLSOAPAccounting service = WebServicesNLSOAPAccounting.newInstance();
        DutchBusinessAccountingDto.userCreateResponseDto response = service.userCreate(new DutchBusinessAccountingDto.UserCreateRequestDto());
    }catch(CCException e){
        flag = true;
    }
        Test.stopTest();
        system.assert(flag);

}
        


public class userEditBalanceSuccessMockImpl implements WebServiceMock {
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
        WebServicesNLSOAPAccountingImplTypes.userEditBalanceResponseType resp = new WebServicesNLSOAPAccountingImplTypes.userEditBalanceResponseType();
            response.put( 'response_x', resp);   
        }
}


public class userViewBalanceSuccessMockImpl implements WebServiceMock {
    public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
            WebServicesNLSOAPAccountingImplTypes.userViewBalanceResponseType resp = new WebServicesNLSOAPAccountingImplTypes.userViewBalanceResponseType();
            resp.balance = 1234;
            response.put( 'response_x', resp);   
   }
}

public class UserCreateV2SuccessMockImpl implements WebServiceMock {
    public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
            WebServicesNLSOAPAccountingImplTypes.userCreateV2ResponseType resp = new WebServicesNLSOAPAccountingImplTypes.userCreateV2ResponseType();
            resp.Id = 1234;
            resp.nickname = 'test';
            resp.password = 'test';
            response.put( 'response_x', resp);   
   }
}
public class CalloutFailureMockImpl implements WebServiceMock {
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            CalloutException e = new CalloutException();
            throw e;
        }
}



}
