/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public with sharing class AddressServiceImpl implements IAddressService {

    public static final Integer MAX_SEARCH_RESULTS = 1000;

    public List<International_Address__c> dutchAddressSearch(String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype){

        List<International_Address__c> dutchAddresses = new List<International_Address__c>();
        List<AddressWsdl.Perceel> addresses = searchForDutchAddressInCompanyInfo(province, district, city, street, houseNo, houseNoAddition, nbcode, lettercombination, addresstype);
        
        for (AddressWsdl.Perceel addressPerceel : addresses) {
            dutchAddresses.add(mapAddressPerceelToInternationalAddress(addressPerceel));
        }
        
        return dutchAddresses;
    }

    private List<AddressWsdl.Perceel> searchForDutchAddressInCompanyInfo(String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype){
        List<AddressWsdl.Perceel> searchResults = new List<AddressWsdl.Perceel>();
        AddressWsdl.PerceelSearchPartsPagedResult returnedResults = WsAddress.addressPerceelFullParameterSearchV2(province, district, city, street, houseNo, houseNoAddition, nbcode, lettercombination, addresstype, 1);
        if (returnedResults != null && returnedResults.results != null && returnedResults.results.item != null) {
            searchResults.addAll(returnedResults.results.item);
            Integer numPages = returnedResults.paging.numpages;
            for (Integer i = 2; i <= numPages && searchResults.size() < MAX_SEARCH_RESULTS; i++) {
                returnedResults = WsAddress.addressPerceelFullParameterSearchV2(province, district, city, street, houseNo, houseNoAddition, nbcode, lettercombination, addresstype, i);
                searchResults.addAll(returnedResults.results.item);
            }
        }
        return searchResults;
    }
    
    private International_Address__c mapAddressPerceelToInternationalAddress(AddressWsdl.Perceel addressPerceel) {
        International_Address__c dutchAddres = new International_Address__c();
        dutchAddres.Perceel_Id__c = addressPerceel.perceelid;
        dutchAddres.House_Number__c = String.valueOf(addressPerceel.huisnr);
        dutchAddres.House_Number_Addition__c = addressPerceel.huisnr_toevoeging;
        dutchAddres.Perceel_Number__c = addressPerceel.perceelnummer;
        dutchAddres.Reeks_Id__c = addressPerceel.reeksid;
        dutchAddres.House_Number_From__c = addressPerceel.huisnr_van;
        dutchAddres.House_Number_To__c = addressPerceel.huisnr_tm;
        dutchAddres.Postcode__c = addressPerceel.wijkcode;
        dutchAddres.Reeks_Indication__c = addressPerceel.reeksindicatie;
        dutchAddres.Letter_Combination__c = addressPerceel.lettercombinatie;
        dutchAddres.Street_Id__c = addressPerceel.straatid;
        dutchAddres.Street__c = addressPerceel.straatnaam;
        dutchAddres.Street_Name_Nen__c = addressPerceel.straatnaam_nen;
        dutchAddres.Street_Name_Ptt__c = addressPerceel.straatnaam_ptt;
        dutchAddres.Street_Name_Extract__c = addressPerceel.straatnaam_extract;
        dutchAddres.City_Id__c = addressPerceel.plaatsid;
        dutchAddres.City_Ptt__c = addressPerceel.plaatsnaam_ptt;
        dutchAddres.City_Extract__c = addressPerceel.plaatsnaam_extract;
        dutchAddres.Locality__c = addressPerceel.plaatsnaam;
        dutchAddres.Municipality__c = addressPerceel.gemeentenaam;
        dutchAddres.Municipality_Code__c = addressPerceel.gemeentecode;
        dutchAddres.Municipality_Id__c = addressPerceel.gemeenteid;
        dutchAddres.Province__c = addressPerceel.provincienaam;
        dutchAddres.Province_Code__c = addressPerceel.provinciecode;
        dutchAddres.CeBuco_Code__c = addressPerceel.cebucocode;
        dutchAddres.Formatted_Address__c = addressPerceel.straatnaam + String.valueOf(addressPerceel.huisnr) ;
        dutchAddres.RecordTypeId = Schema.SObjectType.International_Address__c.getRecordTypeInfosByDeveloperName().get('Dutch_Address').recordTypeId;

        return dutchAddres;
    }

}