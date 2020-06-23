/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public with sharing class AddressServiceImpl implements IAddressService {

    public static final Integer MAX_SEARCH_RESULTS = 1000;

    public List<International_Address__c> dutchAddressSearch(String organization,String province,String district,String city,String street,Integer houseNo,String houseNoAddition,String nbcode,String lettercombination,String addresstype){

        List<International_Address__c> dutchAddresses = new List<International_Address__c>();
        List<AddressWsdl.Perceel> addresses = searchForDutchAddressInCompanyInfo(province, district, city, street, houseNo, houseNoAddition, nbcode, lettercombination, addresstype);
        
        for (AddressWsdl.Perceel addressPerceel : addresses) {
            dutchAddresses.add(mapAddressPerceelToInternationalAddress(addressPerceel, organization));
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
    
    private International_Address__c mapAddressPerceelToInternationalAddress(AddressWsdl.Perceel addressPerceel, String organization) {
        International_Address__c dutchAddress = new International_Address__c();
        dutchAddress.Plot_Id__c = addressPerceel.perceelid;
        dutchAddress.House_Number__c = String.valueOf(addressPerceel.huisnr);
        dutchAddress.House_Number_Addition__c = addressPerceel.huisnr_toevoeging;
        dutchAddress.Plot_Number__c = addressPerceel.perceelnummer;
        dutchAddress.Range_Id__c = addressPerceel.reeksid;
        dutchAddress.House_Number_From__c = addressPerceel.huisnr_van;
        dutchAddress.House_Number_To__c = addressPerceel.huisnr_tm;
        dutchAddress.Postcode__c = addressPerceel.wijkcode;
        dutchAddress.Range_Indication__c = addressPerceel.reeksindicatie;
        dutchAddress.Letter_Combination__c = addressPerceel.lettercombinatie;
        dutchAddress.Street_Id__c = addressPerceel.straatid;
        dutchAddress.Street__c = addressPerceel.straatnaam;
        dutchAddress.Street_Name_Nen__c = addressPerceel.straatnaam_nen;
        dutchAddress.Street_Name_Ptt__c = addressPerceel.straatnaam_ptt;
        dutchAddress.Street_Name_Extract__c = addressPerceel.straatnaam_extract;
        dutchAddress.City_Id__c = addressPerceel.plaatsid;
        dutchAddress.City_Ptt__c = addressPerceel.plaatsnaam_ptt;
        dutchAddress.City_Extract__c = addressPerceel.plaatsnaam_extract;
        dutchAddress.Locality__c = addressPerceel.plaatsnaam;
        dutchAddress.Municipality__c = addressPerceel.gemeentenaam;
        dutchAddress.Municipality_Code__c = addressPerceel.gemeentecode;
        dutchAddress.Municipality_Id__c = addressPerceel.gemeenteid;
        dutchAddress.Province__c = addressPerceel.provincienaam;
        dutchAddress.Province_Code__c = addressPerceel.provinciecode;
        dutchAddress.CeBuco_Code__c = addressPerceel.cebucocode;
        dutchAddress.Formatted_Address__c = addressPerceel.straatnaam + String.valueOf(addressPerceel.huisnr) ;
        dutchAddress.RecordTypeId = Schema.SObjectType.International_Address__c.getRecordTypeInfosByDeveloperName().get('Dutch_Address').recordTypeId;
        dutchAddress.Organization__c = organization;
        dutchAddress.Country__c = 'Netherlands';
        dutchAddress.Alpha_2_Country_Code__c = 'NL';

        return dutchAddress;
    }

}