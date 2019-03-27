/****************************************************************************************
Author          : ValerijsProkudins
Description     : Useb by fflib Application class to wire together the servicve definition and implementation
******************************************************************************************/
public class WebServicesNLSOAPDutchBusiness {

    public DutchBusinessDto.DutchBusinessGetDossierResponse dutchBusinessGetDossier(DutchBusinessDto.DutchBusinessGetDossierRequest params){
        return newInstance().dutchBusinessGetDossier(params);
    }

    DutchBusinessDto.DutchBusinessSearchParametersResponse dutchBusinessSearchParameters(DutchBusinessDto.DutchBusinessSearchParametersRequest params){
        return newInstance().dutchBusinessSearchParameters(params);
    }

    public static IWebServicesNLSOAPDutchBusiness newInstance() {
        return (IWebServicesNLSOAPDutchBusiness) Application.Service.newInstance(IWebServicesNLSOAPDutchBusiness.class);
    }
}
