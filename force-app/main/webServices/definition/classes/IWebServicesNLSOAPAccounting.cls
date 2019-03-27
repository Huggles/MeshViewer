/****************************************************************************************
Author          : ValerijsProkudins
Description     : Interface class for CompanyInfo Accounting webservice layer
******************************************************************************************/
public interface IWebServicesNLSOAPAccounting  extends IWebServicesNLSOAP{

    DutchBusinessAccountingDto.AccountViewResponseDto accountView();
    DutchBusinessAccountingDto.AccountViewResponseDto accountView(String accountId);
    DutchBusinessAccountingDto.UserCreateResponseDto userCreate(DutchBusinessAccountingDto.userCreateRequestDto input);
}
