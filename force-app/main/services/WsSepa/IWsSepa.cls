/**
 * Created by hugovankrimpen on 01/07/2020.
 */

public interface IWsSepa {


    /**
      * Checks an IBAN with / Account Holder Name combination. It can either be a match, mistype (in the name) or not a match.
      * This function does the actual Wsdl Callout.
      *
      * @param IBAN The International Bank Account Number to check
      * @param accountHolderName The first + lastname of the acocunt holder.
      *
      * @return SepaWsdl.SepaMatchAccountHolderResult.
      */
    SepaWsdl.SepaMatchAccountHolderResult sepaMatchAccountHolder(String IBAN,String accountHolderName);
}