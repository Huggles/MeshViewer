/**
 * Created by jaapbranderhorst on 2019-06-29.
 * See https://webview.webservices.nl/documentation/files/service_dutchaddress-php.html
 */

public interface IWsAddress {

    AddressWsdl.PerceelSearchPartsPagedResult addressPerceelFullParameterSearchV2(String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype,Integer page_x);
}