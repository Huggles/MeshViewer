/**
 * Created by jaapbranderhorst on 27/06/2020.
 */

@IsTest
private class ConfigOrgPerCountryDataSourceContrTest {
    @IsTest
    static void testGetDataSourcesPerCountry() {
        Test.startTest();
        List<ConfigOrgPerCountryDataSourceController.DataSourcesPerCountry> dataSourcesPerCountries = ConfigOrgPerCountryDataSourceController.getDataSourcesPerCountry();
        Test.stopTest();
        System.assertEquals(true, dataSourcesPerCountries.size() > 0);
        for (ConfigOrgPerCountryDataSourceController.DataSourcesPerCountry dataSourcesPerCountry :dataSourcesPerCountries) {
            System.assertNotEquals(null, dataSourcesPerCountry.countryCode);
            System.assertNotEquals(null, dataSourcesPerCountry.country);
            System.assertNotEquals(null, dataSourcesPerCountry.dataSourceOptions);
            System.assertNotEquals(null, dataSourcesPerCountry.selectedDataSource);
            System.assertEquals(true, dataSourcesPerCountry.dataSourceOptions.size() > 0);
        }
    }
}