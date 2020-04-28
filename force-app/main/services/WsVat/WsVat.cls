/**
 * Created by jaapbranderhorst on 04/04/2020.
 */

public inherited sharing class WsVat  {

    public static VatWsdl.VatValidation vatValidate(String vat_number) {
        return newInstance().vatValidate(vat_number);
    }

    public static VatWsdl.VatProxyViesCheckVatResponse vatViesProxyCheckVat(String vat_number) {
        return newInstance().vatViesProxyCheckVat(vat_number);
    }

    private static IWsVat newInstance() {
        return (IWsVat) Application.Service.newInstance(IWsVat.class);
    }

}