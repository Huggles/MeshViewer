/**
 * Created by jaapbranderhorst on 16/03/2020.
 */

@IsTest
private class Iso3166CountryPicklistControllerTest {
    @IsTest
    static void testGetIso3166Options() {
        Test.startTest();
        List<Iso3166CountryPickListController.Iso3166Option> entries = (List<Iso3166CountryPickListController.Iso3166Option>)((AuraResponseWrapper)Iso3166CountryPickListController.getIso3166Options()).data;
        Test.stopTest();
        System.assert(entries.size() == 249);
    }

    @IsTest
    static void testGetIsO3166OptionByAlpha2Code() {
        Test.startTest();
        Iso3166CountryPickListController.Iso3166Option option = (Iso3166CountryPickListController.Iso3166Option)((AuraResponseWrapper)Iso3166CountryPickListController.getIsO3166OptionByAlpha2Code('NL')).data;
        Test.stopTest();
        System.assert(option != null);
        System.assert(option.alpha2Code == 'NL');
        System.assert(option.country == 'Netherlands (The)');
        System.assert(option.alpha3Code == 'NLD');
    }
}