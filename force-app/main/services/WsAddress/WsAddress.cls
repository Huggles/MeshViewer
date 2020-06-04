/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public inherited sharing class WsAddress implements IWsAddress {

    public static DutchAddressWsdl.DutchAddressPostcodeRange dutchAddressRangePostcodeSearch(String address){
        return newInstance().dutchAddressRangePostcodeSearch(address);
    }

    public static IWsAddress newInstance() {
        return (IWsAddress) Application.Service.newInstance(IWsAddress.class);
    }
}