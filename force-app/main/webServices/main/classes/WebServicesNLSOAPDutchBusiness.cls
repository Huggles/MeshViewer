/****************************************************************************************
Author          : ValerijsProkudins
Description     : Useb by fflib Application class to wire together the servicve definition and implementation
******************************************************************************************/
public class WebServicesNLSOAPDutchBusiness {

    public static DutchBusinessDto.DutchBusinessGetDossierResponse dutchBusinessGetDossier(DutchBusinessDto.DutchBusinessGetDossierRequest params){
        return newInstance().dutchBusinessGetDossier(params);
    }

    public static DutchBusinessDto.DutchBusinessSearchParametersResponse dutchBusinessSearchParameters(DutchBusinessDto.DutchBusinessSearchParametersRequest params){
        return newInstance().dutchBusinessSearchParameters(params);
    }

    public static DutchBusinessDto.DutchBusinessVatNumber businessGetVatNumber(DutchBusinessDto.DutchBusinessGetVatNumberRequest params){
        return newInstance().businessGetVatNumber(params);
    }

    public static IWebServicesNLSOAPDutchBusiness newInstance() {
        return (IWebServicesNLSOAPDutchBusiness) Application.Service.newInstance(IWebServicesNLSOAPDutchBusiness.class);
    }
}
