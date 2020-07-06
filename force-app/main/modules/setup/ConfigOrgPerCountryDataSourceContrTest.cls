/**
 * Created by jaapbranderhorst on 27/06/2020.
 */

@IsTest
private class ConfigOrgPerCountryDataSourceContrTest {
    @IsTest
    static void testGetDataSourcesPerCountry() {
        Test.startTest();
        AuraResponseWrapper responseWrapper = ConfigOrgPerCountryDataSourceController.getDataSourcesPerCountry();
        Test.stopTest();
        List<ConfigOrgPerCountryDataSourceController.DataSourcesPerCountry> dataSourcesPerCountries = (List<ConfigOrgPerCountryDataSourceController.DataSourcesPerCountry>)responseWrapper.data;
        System.assertEquals(true, dataSourcesPerCountries.size() > 0);
        for (ConfigOrgPerCountryDataSourceController.DataSourcesPerCountry dataSourcesPerCountry :dataSourcesPerCountries) {
            System.assertNotEquals(null, dataSourcesPerCountry.countryCode);
            System.assertNotEquals(null, dataSourcesPerCountry.country);
            System.assertNotEquals(null, dataSourcesPerCountry.dataSourceOptions);
            System.assertNotEquals(null, dataSourcesPerCountry.selectedDataSource);
            System.assertEquals(true, dataSourcesPerCountry.dataSourceOptions.size() > 0);
            System.assertNotEquals(null, dataSourcesPerCountry.dataSourceOptions.get(0).label);
            System.assertNotEquals(null, dataSourcesPerCountry.dataSourceOptions.get(0).value);
        }
    }
}