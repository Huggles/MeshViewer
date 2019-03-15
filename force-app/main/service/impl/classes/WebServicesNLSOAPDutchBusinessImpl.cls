public class WebServicesNLSOAPDutchBusinessImpl  extends WebServicesNLSOAPDutchBusinessImplTypes implements IWebServicesNLSOAPDutchBusiness{
    public void dutchBusinessGetDossierV3(String dossier_number,String establishment_number){
            Webservices_nlPort port = new Webservices_nlPort();

            dutchBusinessGetDossierV3RequestType request_x = new dutchBusinessGetDossierV3RequestType();
            dutchBusinessGetDossierV3ResponseType response_x;
            request_x.dossier_number = dossier_number;
            request_x.establishment_number = establishment_number;
            Map<String, dutchBusinessGetDossierV3ResponseType> response_map_x = new Map<String, dutchBusinessGetDossierV3ResponseType>();
            response_map_x.put('response_x', response_x);

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(this));
            WebServiceCallout.invoke(
                    port,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'https://ws1.webservices.nl/soap_doclit.php/dutchBusinessGetDossierV3',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessGetDossierV3',
                            'http://www.webservices.nl/soap/',
                            'dutchBusinessGetDossierV3Response',
                            'WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessGetDossierV3ResponseType'}
            );
            response_x = response_map_x.get('response_x');

    }
}



