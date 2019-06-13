/****************************************************************************************
Author          : ValerijsProkudins
Description     : Interface class for CompanyConnect DutchBusiness webservice layer
******************************************************************************************/
public interface IWebServicesNLSOAPDutchBusiness extends IWebServicesNLSOAP{
    // only dto methods in the interface(version agnostic)
    DutchBusinessDto.DutchBusinessGetDossierResponse dutchBusinessGetDossier(DutchBusinessDto.DutchBusinessGetDossierRequest params);
    DutchBusinessDto.DutchBusinessSearchParametersResponse dutchBusinessSearchParameters(DutchBusinessDto.DutchBusinessSearchParametersRequest params);
    DutchBusinessDto.DutchBusinessVatNumber businessGetVatNumber(DutchBusinessDto.DutchBusinessGetVatNumberRequest params);
}
