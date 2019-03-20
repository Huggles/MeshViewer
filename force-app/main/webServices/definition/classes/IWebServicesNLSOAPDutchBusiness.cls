/****************************************************************************************
Author          : ValerijsProkudins
Description     : Interface class for CompanyInfo DutchBusiness webservice layer
******************************************************************************************/
public interface IWebServicesNLSOAPDutchBusiness extends IWebServicesNLSOAP{
    
    DutchBusinessDto dutchBusinessGetDossierV3(String dossier_number,String establishment_number);
    
    DutchBusinessDto dutchBusinessSearchParametersV2(String trade_name,String city,String street,String postcode,Integer house_number,String house_number_addition,String telephone_number,String domain_name,Boolean strict_search,Integer page);
        
}
