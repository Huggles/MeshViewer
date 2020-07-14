/**
 * Created by hugovankrimpen on 01/07/2020.
 */

public with sharing class WsSepa{

    public static SepaWsdl.SepaMatchAccountHolderResult sepaMatchAccountHolder(String IBAN,String accountHolderName){
        return newInstance().sepaMatchAccountHolder(IBAN, accountHolderName);
    }

    public static IWsSepa newInstance() {
        return (IWsSepa) Application.Service.newInstance(IWsSepa.class);
    }


}