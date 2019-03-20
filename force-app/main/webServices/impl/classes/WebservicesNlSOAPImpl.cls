public abstract class WebservicesNlSOAPImpl extends WebservicesNlSOAPImplTypes implements IWebservicesNlSOAP{
    public String endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php'; //TODO: mover to other place?
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
    

/*
   public void getAuthentication(Webservices_nlPort port){
       

        Credentials__c CS = Credentials__c.getOrgDefaults();
        HeaderLoginType header= new HeaderLoginType();
        header.userName=cs.Username__c;//'appsolutelytest_bfc9bbb2';
        header.passWord=cs.Password__c;//'5Z9wwVa-hYzy*mFY)VW.-U$!5Vu}Ymc{';//
        System.debug(logginglevel.error,'get auth');
        System.debug(logginglevel.error,header);
        port.HeaderLogin = header;
    }
*/
    public WebservicesNlSOAPImpl(){
        port = new Webservices_nlPort();
    }
    public class Webservices_nlPort {
        public String endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php';
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
        public Webservices_nlPort(){
            getAuthentication();
        }
        public void getAuthentication(){
            Credentials__c CS = Credentials__c.getOrgDefaults();
            HeaderLogin = new HeaderLoginType();
            HeaderLogin.userName=cs.Username__c;//'appsolutelytest_bfc9bbb2';
            HeaderLogin.passWord=cs.Password__c;//'5Z9wwVa-hYzy*mFY)VW.-U$!5Vu}Ymc{';//
        }
    }


}