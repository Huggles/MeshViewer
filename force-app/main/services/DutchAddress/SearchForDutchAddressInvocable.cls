/**
 * Created by tejaswinidandi on 15/05/2020.
 */

global inherited sharing class SearchForDutchAddressInvocable {

    global inherited sharing class SearchForDutchAddressArgument {
        @InvocableVariable(label='Address' description='Address of the company or organisation')
        global String address;

        @TestVisible
        private SearchForDutchAddressArgument(String address){
            this.address = address;
        }

        public SearchForDutchAddressArgument() {}

    }

    @InvocableMethod(label = 'Search and complete for dutch addresses' description='Searches and completes/corrects dutch addresses.' category='Company.info')
    global static List<List<Boolean>> searchDutchAddress(List<SearchForDutchAddressArgument> arguments) {
//        List<Dutch_Address_Postcode_Range__c> dutchAddressPostcodeRanges = new List<Dutch_Address_Postcode_Range__c>();
//        List<List<Dutch_Address_Postcode_Range__c>> listDutchAddressPostcodeRanges = new List<List<Dutch_Address_Postcode_Range__c>>();
//
//        for (SearchForDutchAddressArgument searchForDutchAddressArgument : arguments) {
//            dutchAddressPostcodeRanges.add(DutchAddressService.dutchAddressRangePostcodeSearch(
//                    searchForDutchAddressArgument.address
//            ));
//        }
//        listDutchAddressPostcodeRanges.add(new List<Dutch_Address_Postcode_Range__c>(dutchAddressPostcodeRanges));
//        System.debug(listDutchAddressPostcodeRanges);
        return null;
    }

}