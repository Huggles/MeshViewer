/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public inherited sharing class AddressService {

    /*
     * Returns List of International_Address__c with Dutch address recordtype if given address is found
     *
     * @param address
     */
    public static List<International_Address__c> dutchAddressSearch(String organization,String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype){
        return newInstance().dutchAddressSearch(organization, province, district, city, street, houseNo, houseNoAddition, nbcode, lettercombination, addresstype);
    }

    public static IAddressService newInstance() {
        return (IAddressService)Application.Service.newInstance(IAddressService.class);
    }

}