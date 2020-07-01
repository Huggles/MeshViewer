/**
 * Created by hugovankrimpen on 01/07/2020.
 */

public interface IWsSepa {
    SepaWsdl.SepaMatchAccountHolderResult sepaMatchAccountHolder(String IBAN,String accountHolderName);
}