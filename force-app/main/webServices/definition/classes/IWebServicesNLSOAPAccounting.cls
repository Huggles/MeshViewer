/****************************************************************************************
Author          : ValerijsProkudins
Description     : Interface class for CompanyInfo Accounting webservice layer
******************************************************************************************/
public interface IWebServicesNLSOAPAccounting  extends IWebServicesNLSOAP{

    boolean userChangeBalance(DutchBusinessAccountingDto.userChangeBalanceRequestDto input);
    DutchBusinessAccountingDto.userViewBalanceResponse userGetBalance(DutchBusinessAccountingDto.userViewBalanceRequest input);
    DutchBusinessAccountingDto.userViewV2Response userCheckActive(DutchBusinessAccountingDto.userCheckActiveRequest input);
    //DutchBusinessAccountingDto.AccountViewResponseDto accountView();
    //DutchBusinessAccountingDto.AccountViewResponseDto accountView(String accountId);
    DutchBusinessAccountingDto.UserCreateResponseDto userCreate(DutchBusinessAccountingDto.userCreateRequestDto input);
}
