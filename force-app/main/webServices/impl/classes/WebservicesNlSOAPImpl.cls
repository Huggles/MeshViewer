/****************************************************************************************
Author          : ValerijsProkudins
Description     : Company info baseline integration implementation class. NB: it extends the baseline implementation type class!
******************************************************************************************/
public abstract class WebservicesNlSOAPImpl extends WebservicesNlSOAPImplTypes implements IWebservicesNlSOAP{
    //public String endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php'; //TODO: mover to other place?
    //public Map<String,String> inputHttpHeaders_x;
    //public Map<String,String> outputHttpHeaders_x;
    //public String clientCertName_x;
    //public String clientCert_x;
    //public String clientCertPasswd_x;
    //public Integer timeout_x;
    //public HeaderAuthenticateType HeaderAuthenticate;
    //public HeaderLoginType HeaderLogin;
    //private String HeaderAuthenticate_hns = 'HeaderAuthenticate=http://www.webservices.nl/soap/';
   // private String HeaderLogin_hns = 'HeaderLogin=http://www.webservices.nl/soap/';
    private String[] ns_map_type_info = new String[]{'http://www.webservices.nl/soap/','wwwWebservicesNlSoap'};
    public Webservices_nlPort port;

    public WebservicesNlSOAPImpl(){
        //port = new Webservices_nlPort('User');
        //this.endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php';
    }
    public class Webservices_nlPort {
        public String endpoint_x;// = 'https://ws1.webservices.nl:443/soap_doclit.php';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public HeaderLoginType HeaderLogin;
        private String HeaderLogin_hns = 'HeaderLogin=http://www.webservices.nl/soap/';
        public HeaderAuthenticateType HeaderAuthenticate;
        private String HeaderAuthenticate_hns = 'HeaderAuthenticate=http://www.webservices.nl/soap/';
        private String[] ns_map_type_info = new String[]{'http://www.webservices.nl/soap/','wwwWebservicesNlSoap'}; // wwwWebservicesNlSoap is from the old WS file name. Might need to change if something breaks
        public Webservices_nlPort(String scope){ // scope is either user or admin
            HeaderLogin = getAuthentication(scope);
            endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php'; // TODO: move to CMT
        }
        /*public Webservices_nlPort(String scope, boolean fallback){ // scope is either user or admin
            HeaderLogin = getAuthentication(scope);
            system.debug('************ FALLBACK SERVER USED');
            //this.endpoint_x = 'https://ws2.webservices.nl:443/soap_doclit.php'; // fallbackURL ws2.webservices.nl
            //endpoint_x = 'https://ws2.webservices.nl:443/soap_doclit.php'; // fallbackURL ws2.webservices.nl
        }*/
        public void useFallback(){
            endpoint_x = 'https://ws2.webservices.nl:443/soap_doclit.php';
        }
        public HeaderLoginType getAuthentication(String scope){
            HeaderLoginType HeaderLogin;
            system.debug(logginglevel.error, '*********** '+scope);
            if(scope == 'User'){
                Credentials__c CS = Credentials__c.getOrgDefaults();
                if(cs.Username__c != null && cs.Password__c != null){
                    HeaderLogin = new HeaderLoginType();
                    HeaderLogin.userName=cs.Username__c;//'appsolutelytest_bfc9bbb2';
                    HeaderLogin.passWord=cs.Password__c;//'5Z9wwVa-hYzy*mFY)VW.-U$!5Vu}Ymc{';//
                }
            }else{
                ApplicationProperty__mdt configData = [SELECT DataProviderName__c, DefaultTrialBalance__c, DataProviderAdminUsername__c, DataProviderAdminPassword__c FROM ApplicationProperty__mdt WHERE DataProviderName__c = 'Company.Info' LIMIT 1];
                system.debug(logginglevel.error, '*********** '+configData);
                HeaderLogin = new HeaderLoginType();
                HeaderLogin.userName=configData.DataProviderAdminUsername__c;//'appsolutelytest_Admin';
                HeaderLogin.passWord=configData.DataProviderAdminPassword__c;//'q{UfUzSJj7V,*Q$vw(Y_Sk2gyG,UVJG$';//         
            }
            if(HeaderLogin == null){
                BdsException ex = new BdsException(System.Label.BDS_NoAuthAppNotActive);//'No authentication data found. The app is not activated');
                ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
                throw new BdsException(System.Label.BDS_NoAuthAppNotActive);//'No authentication data found. The app is not activated');
            }
            return HeaderLogin;
            
        }
    }



    public void ExecuteCallout(Webservices_nlPort port, Object request_x, Map<String,Object> response_map_x, list <String> infoArray){
        try{
            WebServiceCallout.invoke(   //Invocxation is wrapped in method that supports fallback server in case of callout timeout
                    port,
                    request_x,
                    response_map_x,
                    infoArray
            );
        }catch(CalloutException e){
            system.debug('*********** Using the fallback server port = '+ port);
            port.useFallback();
            infoArray.set(0, port.endpoint_x);
system.debug('*********** Using the fallback server port222 = '+ port);
            WebServiceCallout.invoke(   //Invocxation is wrapped in method that supports fallback server in case of callout timeout
                    port,
                    request_x,
                    response_map_x,
                    infoArray
            );
        }// if fallback fails we roll up the callback exception???
    }


}

