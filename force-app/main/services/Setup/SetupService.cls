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

    public static ISetupService newInstance() {
        return (ISetupService) Application.Service.newInstance(ISetupService.class);
    }

}