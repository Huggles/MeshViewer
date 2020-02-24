/**
 * Created by appsolutely on 14/02/2020.
 */

public inherited sharing class InternationalAddressImpl implements IInternationalAddressService{

    public List<InternationalAddressResultsDto> internationalAddressSearchV2(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format) {

        // check the input
        if (country == null || String.isEmpty(country)) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }
        // no checks needed so commented
        List<InternationalAddressResultsDto> resultArray = new List<InternationalAddressResultsDto>();

        InternationalAddressWSDL.InternationalAddressSearchV2Result userSearchResult = WsInternationalAddress.internationalAddressSearchV2( organization, building,street, housenr, pobox, locality, postcode, province, country, language, country_format);

       for (InternationalAddressWSDL.InternationalV2 resultItem : userSearchResult.result.item) {
            resultArray.add(new InternationalAddressResultsDto(resultItem));
        }


        return resultArray;
    }
    public List<InternationalAddressResultsDto> internationalAddressSearchInteractive(String organization,String building,String street,String housenr,String pobox,String locality,String postcode,String province,String country,String language,String country_format) {

        // check the input
        if (country == null || String.isEmpty(country)) {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }
        // no checks needed so commented
        List<InternationalAddressResultsDto> resultArray = new List<InternationalAddressResultsDto>();

        InternationalAddressWSDL.InternationalAddressSearchV2Result userSearchResult = WsInternationalAddress.internationalAddressSearchV2( organization, building,street, housenr, pobox, locality, postcode, province, country, language, country_format);

        for (InternationalAddressWSDL.InternationalV2 resultItem : userSearchResult.result.item) {
            resultArray.add(new InternationalAddressResultsDto(resultItem));
        }


        return resultArray;
    }

    public void logout(){

    }

    public string login(String name, String Password){
    return null;
    }

    public void insertInternationalAddress(List<appsolutely__International_Address__c> insertAddress){
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        unitOfWork.registerNew(insertAddress);
        unitOfWork.commitWork();
    }
}