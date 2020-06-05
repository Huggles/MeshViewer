/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public inherited sharing class AddressService {

    /*
     * Returns International_Address__c if given address is found
     *
     * @param address
     */
    public static List<International_Address__c> dutchAddressSearch(String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype){
        return newInstance().dutchAddressSearch(province, district, city, street, houseNo, houseNoAddition, nbcode, lettercombination, addresstype);
    }

    public static IAddressService newInstance() {
        return (IAddressService)Application.Service.newInstance(IAddressService.class);
    }

}