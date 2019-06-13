/****************************************************************************************
Author          : ValerijsProkudins
Description     : Useb by fflib Application class to wire together the servicve definition and implementation
******************************************************************************************/
public class WebServicesNLSOAPAccounting {


    public static boolean userChangeBalance(DutchBusinessAccountingDto.userChangeBalanceRequestDto input){
        return newInstance().userChangeBalance(input);
    }

    public static DutchBusinessAccountingDto.userViewBalanceResponse userGetBalance(DutchBusinessAccountingDto.userViewBalanceRequest input){
        return newInstance().userGetBalance(input);
    }

    /*public static DutchBusinessAccountingDto.AccountViewResponseDto accountView(){
        return newInstance().accountView();
    }

    public static DutchBusinessAccountingDto.AccountViewResponseDto accountView(String accountId){
        return newInstance().accountView(accountId);
    }*/
    public DutchBusinessAccountingDto.userCreateResponseDto userCreate(DutchBusinessAccountingDto.UserCreateRequestDto input){
        return newInstance().userCreate(input);
    }
    public static IWebServicesNLSOAPAccounting newInstance() {
        return (IWebServicesNLSOAPAccounting) Application.Service.newInstance(IWebServicesNLSOAPAccounting.class);
    }


}
