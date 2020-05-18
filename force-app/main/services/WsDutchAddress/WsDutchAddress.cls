/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public inherited sharing class WsDutchAddress implements IWsDutchAddress{

    public static DutchAddressWsdl.DutchAddressPostcodeRange dutchAddressRangePostcodeSearch(String address){
        return newInstance().dutchAddressRangePostcodeSearch(address);
    }

    public static IWsDutchAddress newInstance() {
        return (IWsDutchAddress) Application.Service.newInstance(IWsDutchAddress.class);
    }
}