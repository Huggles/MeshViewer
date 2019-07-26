/**
 * Created by jaapbranderhorst on 2019-06-30.
 */

public with sharing class WsDutchBusinessImpl implements IWsDutchBusiness {

    private DutchBusinessWsdl.Webservices_nlPort port { get; set; }

    public WsDutchBusinessImpl() {
        port = new DutchBusinessWsdl.Webservices_nlPort();
        port.HeaderLogin = new DutchBusinessWsdl.HeaderLoginType();
        Credentials__c credentials = Credentials__c.getOrgDefaults();
        port.HeaderLogin.username = credentials.Username__c;
        port.HeaderLogin.password = credentials.Password__c;
    }

    public DutchBusinessWsdl.DutchBusinessVatNumber dutchBusinessGetVatNumber(String dossier_number) {
        DutchBusinessWsdl.DutchBusinessVatNumber returnValue = null;
        try {
            returnValue = port.dutchBusinessGetVatNumber(dossier_number);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.dutchBusinessGetVatNumber(dossier_number);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult dutchBusinessSearchParametersV2(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search, Integer page_x) {
        DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult returnValue = null;
        try {
            returnValue = port.dutchBusinessSearchParametersV2(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search, page_x);
        } catch(CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.dutchBusinessSearchParametersV2(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search, page_x);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessGetDossierV3(String dossier_number, String establishment_number) {
        DutchBusinessWsdl.DutchBusinessDossierV3 returnValue = null;
        try {
            returnValue = port.dutchBusinessGetDossierV3(dossier_number, establishment_number);
        } catch (CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.dutchBusinessGetDossierV3(dossier_number, establishment_number);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult dutchBusinessUpdateGetChangedDossiers(Date changed_since, DutchBusinessWsdl.stringArray update_types, Integer page_x) {
        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult returnValue = null;
        try {
            returnValue = port.dutchBusinessUpdateGetChangedDossiers(changed_since, update_types, page_x);
        } catch (CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    returnValue = port.dutchBusinessUpdateGetChangedDossiers(changed_since, update_types, page_x);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
        return returnValue;
    }

    public void dutchBusinessUpdateRemoveDossier(String dossier_number,String establishment_number) {
        try {
            port.dutchBusinessUpdateRemoveDossier(dossier_number, establishment_number);
        } catch (CalloutException calloutException) {
            Boolean fallBack = CallOutHelper.handleCallOutException(calloutException);
            if (fallBack) {
                port.doFallBack();
                try {
                    port.dutchBusinessUpdateRemoveDossier(dossier_number, establishment_number);
                } catch (CalloutException calloutException2) {
                    Boolean serverUnavailable = CallOutHelper.handleCallOutException(calloutException2);
                    if (serverUnavailable) {
                        ErrorLogUtil.logException(calloutException2);
                        throw new CCWsServerUnavailableException(Label.Error_Server_Unavailable);
                    }
                }
            }
        }
    }

}