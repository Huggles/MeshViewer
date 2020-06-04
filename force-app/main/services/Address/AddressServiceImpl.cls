/**
 * Created by tejaswinidandi on 15/05/2020.
 */

public with sharing class AddressServiceImpl implements IAddressService {

//    public Dutch_Address_Postcode_Range__c dutchAddressRangePostcodeSearch(String address){
//
//        Dutch_Address_Postcode_Range__c dutchAddressPostcodeRange = new Dutch_Address_Postcode_Range__c();
//        if (String.isNotEmpty(address)) {
//            DutchAddressWsdl.DutchAddressPostcodeRange dutchAddressPostcodeRange2 = WsAddress.dutchAddressRangePostcodeSearch(address);
//            if (dutchAddressPostcodeRange2 != null) {
//                dutchAddressPostcodeRange.Cebuco_Code__c = dutchAddressPostcodeRange2.cebuco_code;
//                dutchAddressPostcodeRange.City__c = dutchAddressPostcodeRange2.city;
//                dutchAddressPostcodeRange.House_Number_From__c = dutchAddressPostcodeRange2.house_number_from;
//                dutchAddressPostcodeRange.House_Number_To__c = dutchAddressPostcodeRange2.house_number_to;
//                dutchAddressPostcodeRange.Letter_Combination__c = dutchAddressPostcodeRange2.letter_combination;
//                dutchAddressPostcodeRange.Municipality__c = dutchAddressPostcodeRange2.municipality;
//                dutchAddressPostcodeRange.Municipality_Code__c = dutchAddressPostcodeRange2.municipality_code;
//                dutchAddressPostcodeRange.Neighborhood_Code__c = dutchAddressPostcodeRange2.neighborhood_code;
//                dutchAddressPostcodeRange.Province__c = dutchAddressPostcodeRange2.province;
//                dutchAddressPostcodeRange.Province_Code__c = dutchAddressPostcodeRange2.province_code;
//                dutchAddressPostcodeRange.Range_Indication__c = dutchAddressPostcodeRange2.range_indication;
//                dutchAddressPostcodeRange.Street_Name__c = dutchAddressPostcodeRange2.street_name;
//                dutchAddressPostcodeRange.Street_Name_Nen__c = dutchAddressPostcodeRange2.street_name_nen;
//            }
//        }
//        else {
//            throw new CCInputException('No address is specified');
//        }
//        return dutchAddressPostcodeRange;
//    }

}