/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public inherited sharing class WsDutchBusiness implements IWsDutchBusiness{

    public static DutchBusinessWsdl.DutchBusinessVatNumber dutchBusinessGetVatNumber(String dossier_number) {
        return newInstance().dutchBusinessGetVatNumber(dossier_number);
    }

    public static DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult dutchBusinessSearchParametersV2(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search, Integer page_x) {
        return newInstance().dutchBusinessSearchParametersV2(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search, page_x);
    }

    public static DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult dutchBusinessSearch(String dossier_number, String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search, Integer page_x) {
        return newInstance().dutchBusinessSearch(dossier_number, trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search, page_x);
    }

    public static DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessGetDossierV3(String dossier_number, String establishment_number) {
        return newInstance().dutchBusinessGetDossierV3(dossier_number, establishment_number);
    }

    public static IWsDutchBusiness newInstance() {
        return (IWsDutchBusiness) Application.Service.newInstance(IWsDutchBusiness.class);
    }

    public static DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult dutchBusinessUpdateGetChangedDossiers(Date changed_since,DutchBusinessWsdl.stringArray update_types,Integer page_x) {
        return newInstance().dutchBusinessUpdateGetChangedDossiers(changed_since, update_types, page_x);
    }

    public static void dutchBusinessUpdateRemoveDossier(String dossier_number,String establishment_number){

    }

}