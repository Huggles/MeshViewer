/**
 * Created by jaapbranderhorst on 04/04/2020.
 */

public interface IWsVat {

    /**
    * Validate a VAT number.
    *
    * @param vat_number The vat number to check, starting with a country code followed by a 2 - 12 character long vat number.
    *
    * @return Entry containing the requested VAT number and it validation state.
    */
    VatWsdl.VatValidation vatValidate(String vat_number);

    /**
    * The proxy method is a direct proxy to the VIES service making that service available via our webservice, for multiple end-points.  This service will hehave exactly as the VIES service itself, but any service faults are wrapped within the generic Webservices.nl error system.  The disclaimer found on http://ec.europa.eu/taxation_customs/vies/disclaimer.html?locale=en
    * is also applied to this service.  Webservices.nl is in no way responsible or liable for the contents or avalability of this service.
    *
    * @param vat_number The vat number to check, starting with a country code followed by a 2 - 12 character long vat number.
    *
    * @return The response as retrieved from Vies Service
    */
    VatWsdl.VatProxyViesCheckVatResponse vatViesProxyCheckVat(String vat_number);

}