/****************************************************************************************
Author          : ValerijsProkudins
Description     : Interface class for CompanyInfo DutchBusiness webservice layer
******************************************************************************************/
public interface IWebServicesNLSOAPDutchBusiness extends IWebServicesNLSOAP{
    // only dto methods in the interface(version agnostic)
    DutchBusinessDto.DutchBusinessGetDossierResponse dutchBusinessGetDossier(DutchBusinessDto.DutchBusinessGetDossierRequest params);
    DutchBusinessDto.DutchBusinessSearchParametersResponse dutchBusinessSearchParameters(DutchBusinessDto.DutchBusinessSearchParametersRequest params);
}
