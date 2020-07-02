/****************************************************************************************
Author          : Hugo van Krimpen
Date            : 04/06/2020
Description     : Service layer for Setup
******************************************************************************************/
public inherited sharing class SetupService {

    public static List<Protected_Subscriber_Setting__mdt> getUpdateTypes() {
        return newInstance().getUpdateTypes();
    }

    public static Id setUpdateTypes(List<Map<string, object>> payload) {
        return newInstance().setUpdateTypes(payload);
    }

    public static List<Datasource_Per_Country__mdt> getDataSourcesPerCountry() {
        return newInstance().getDataSourcesPerCountry();
    }

    public static Data_source__mdt getSelectedDataSource(String countryCode) {
        return newInstance().getSelectedDataSource(countryCode);
    }

    public static void setDataSourcePerCountry(Map<String, String> selectedDataSourcePerCountry){
        newInstance().setDataSourcePerCountry(selectedDataSourcePerCountry);
    }

    public static ISetupService newInstance() {
        return (ISetupService) Application.Service.newInstance(ISetupService.class);
    }

}