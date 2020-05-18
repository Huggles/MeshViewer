/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public interface IDutchAddressService {
    /*
     * Returns Dutch_Address_Postcode_Range__c if given address is found
     *
     * @param address
     */
    Dutch_Address_Postcode_Range__c dutchAddressRangePostcodeSearch(String address);
}