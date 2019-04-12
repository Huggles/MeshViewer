/****************************************************************************************
Author          : ValerijsProkudins
Description     : Company info baseline integration implementation class. NB: it extends the baseline implementation type class!
******************************************************************************************/
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

    public WebservicesNlSOAPImpl(){
        port = new Webservices_nlPort('User');
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
        public Webservices_nlPort(String scope){ // scope is either user or admin
            getAuthentication(scope);
        }
        public void getAuthentication(String scope){
            Credentials__c CS = Credentials__c.getOrgDefaults();
            ApplicationProperty__mdt configData = [SELECT DataProviderName__c, DefaultTrialBalance__c, DataProviderAdminUsername__c, DataProviderAdminPassword__c FROM ApplicationProperty__mdt WHERE DataProviderName__c = 'Company.Info' LIMIT 1];
            HeaderLogin = new HeaderLoginType();
            if(scope == 'User'){
                HeaderLogin.userName=cs.Username__c;//'appsolutelytest_bfc9bbb2';
                HeaderLogin.passWord=cs.Password__c;//'5Z9wwVa-hYzy*mFY)VW.-U$!5Vu}Ymc{';//
            }else{
                HeaderLogin.userName=configData.DataProviderAdminUsername__c;//'appsolutelytest_Admin';
                HeaderLogin.passWord=configData.DataProviderAdminPassword__c;//'q{UfUzSJj7V,*Q$vw(Y_Sk2gyG,UVJG$';//
            }
            
        }
    }


}