/**
 * Created by jaapbranderhorst on 2019-06-29.
 * See https://webview.webservices.nl/documentation/files/service_dutchaddress-php.html
 */

public interface IWsAddress {

    DutchAddressWsdl.DutchAddressPostcodeRange dutchAddressRangePostcodeSearch(String address);
}