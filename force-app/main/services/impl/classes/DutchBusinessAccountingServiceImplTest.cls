@isTest
public with sharing class DutchBusinessAccountingServiceImplTest {


@isTest
public static void onboardCustomer(){

    DutchBusinessAccountingDto.userCreateResponseDto output= new DutchBusinessAccountingDto.userCreateResponseDto();
    output.nickname = '1234';
    DutchBusinessAccountingDto.UserCreateRequestDto input = new DutchBusinessAccountingDto.UserCreateRequestDto();
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    IWebServicesNLSOAPAccounting mockWS = (IWebServicesNLSOAPAccounting)mocks.mock(IWebServicesNLSOAPAccounting.class);
    mocks.startStubbing();

    //mocks.when(mockWS.CreateCIUser((DutchBusinessAccountingDto.UserCreateRequestDto)fflib_Match.anyObject())).thenReturn(output);
    //mocks.stopStubbing(); 

    test.startTest();
    //Application.service.setMock(IDutchBusinessAccountingService.class, mockWS);
    IDutchBusinessAccountingService service = DutchBusinessAccountingService.newInstance();
        mocks.when(mockWS.userCreate((DutchBusinessAccountingDto.UserCreateRequestDto)fflib_Match.anyObject())).thenReturn(output);
    mocks.stopStubbing();  
    Application.service.setMock(IWebServicesNLSOAPAccounting.class, mockWS);



    DutchBusinessAccountingDto.userCreateResponseDto result = service.onboardCustomer('1234');
    //((IDutchBusinessAccountingService)mocks.verify(mockWS)).CreateCIUser((DutchBusinessAccountingDto.UserCreateRequestDto)fflib_Match.anyObject());
    system.assertEquals(result.nickname, output.nickname); 


    test.stoptest();



}

 
@isTest
public static void testCreateCIUser(){
    DutchBusinessAccountingDto.UserCreateRequestDto input = new DutchBusinessAccountingDto.UserCreateRequestDto();
    DutchBusinessAccountingDto.userCreateResponseDto output = new DutchBusinessAccountingDto.userCreateResponseDto();
    output.id = 0;
    output.nickname = 'test';
    output.password = 'test';
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    IWebServicesNLSOAPAccounting mockWS = (IWebServicesNLSOAPAccounting)mocks.mock(IWebServicesNLSOAPAccounting.class);

    input.usergroups = new list<Integer>();
    input.usergroups.add(23);

    mocks.startStubbing();

    mocks.when(mockWS.userCreate((DutchBusinessAccountingDto.UserCreateRequestDto)fflib_Match.anyObject())).thenReturn(output);
    mocks.stopStubbing();  
    Application.service.setMock(IWebServicesNLSOAPAccounting.class, mockWS);
    IDutchBusinessAccountingService service = DutchBusinessAccountingService.newInstance();

    DutchBusinessAccountingDto.userCreateResponseDto result = service.CreateCIUser(input);
    ((IWebServicesNLSOAPAccounting)mocks.verify(mockWS)).userCreate((DutchBusinessAccountingDto.UserCreateRequestDto)fflib_Match.anyObject());
    system.assertEquals(result.id, output.id);   

    } 



@isTest
public static void testAddBudget(){

    fflib_ApexMocks mocks = new fflib_ApexMocks();
//given
    //IDutchBusinessAccountingService mockService = (IDutchBusinessAccountingService)mocks.mock(IDutchBusinessAccountingService.class);
    IWebServicesNLSOAPAccounting mockWS = (IWebServicesNLSOAPAccounting)mocks.mock(IWebServicesNLSOAPAccounting.class);
    
    //Application.service.setMock(IDutchBusinessAccountingService.class, mockService);
    
    mocks.startStubbing();
    
    Double amount = 100.0;
    Integer userId = 1234;
    DutchBusinessAccountingDto.userChangeBalanceRequestDto input = new DutchBusinessAccountingDto.userChangeBalanceRequestDto();
    input.userId = userId;
    input.balance = amount;

    mocks.when(mockWS.userChangeBalance((DutchBusinessAccountingDto.userChangeBalanceRequestDto)fflib_Match.anyObject())).thenReturn(true);
    //mocks.when(mockWS.userChangeBalance((set<DutchBusinessAccountingDto.userChangeBalanceRequestDto> fflib_Match.anyObject()).thenReturn(true));
    //mocks.when(mockWS.userChangeBalance((Set<DutchBusinessAccountingDto.userChangeBalanceRequestDto> fflib_Match.anyObject())).thenReturn(true);
    mocks.stopStubbing();
Application.service.setMock(IWebServicesNLSOAPAccounting.class, mockWS);
    // when
    IDutchBusinessAccountingService service = DutchBusinessAccountingService.newInstance();

    boolean result = service.addBudget(amount, userId);
    //system.debug(service.addBudget(amount, userId));
system.debug('***************** result = '+ result);
    //then
    ((IWebServicesNLSOAPAccounting)mocks.verify(mockWS)).userChangeBalance((DutchBusinessAccountingDto.userChangeBalanceRequestDto)fflib_Match.anyObject());
    system.assert(result);
    


}


}