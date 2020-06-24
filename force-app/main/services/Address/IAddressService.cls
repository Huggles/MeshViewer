/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public interface IAddressService {
    /*
     * Returns List of International_Address__c with Dutch address recordtype if given address is found
     *
     * @param address
     */
    List<International_Address__c> dutchAddressSearch(String organization,String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype);
}