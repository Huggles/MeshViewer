/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public inherited sharing class WsAddress implements IWsAddress {

    public static AddressWsdl.PerceelSearchPartsPagedResult addressPerceelFullParameterSearchV2(String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype,Integer page_x) {
        return newInstance().addressPerceelFullParameterSearchV2(province, district, city, street, houseNo, houseNoAddition, nbcode, lettercombination, addresstype, page_x);
    }

    public static IWsAddress newInstance() {
        return (IWsAddress) Application.Service.newInstance(IWsAddress.class);
    }
}