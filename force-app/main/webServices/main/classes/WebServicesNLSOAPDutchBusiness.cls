/****************************************************************************************
Author          : ValerijsProkudins
Description     : Useb by fflib Application class to wire together the servicve definition and implementation
******************************************************************************************/
public class WebServicesNLSOAPDutchBusiness {


    public DutchBusinessDto dutchBusinessGetDossierV3(String dossier_number,String establishment_number){
        return newInstance().dutchBusinessGetDossierV3(dossier_number, establishment_number);
    }


    public DutchBusinessDto dutchBusinessSearchParametersV2(String trade_name,String city,String street,String postcode,Integer house_number,String house_number_addition,String telephone_number,String domain_name,Boolean strict_search,Integer page) {
        return newInstance().dutchBusinessSearchParametersV2(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search, page);
    }



    public static IWebServicesNLSOAPDutchBusiness newInstance() {
        return (IWebServicesNLSOAPDutchBusiness) Application.Service.newInstance(IWebServicesNLSOAPDutchBusiness.class);
    }

}
