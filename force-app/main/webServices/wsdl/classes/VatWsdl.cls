//Generated by wsdl2apex

public class VatWsdl {
    public class vatValidateRequestType {
        public String vat_number;
        private String[] vat_number_type_info = new String[]{'vat_number','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'vat_number'};
    }
    public class vatViesProxyCheckVatResponseType {
        public VatWsdl.VatProxyViesCheckVatResponse out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class HeaderLoginType {
        public String username;
        public String password;
        private String[] username_type_info = new String[]{'username','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }
    public class loginRequestType {
        public String username;
        public String password;
        private String[] username_type_info = new String[]{'username','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }
    public class logoutResponseType {
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class vatViesProxyCheckVatRequestType {
        public String vat_number;
        private String[] vat_number_type_info = new String[]{'vat_number','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'vat_number'};
    }
    public class vatValidateResponseType {
        public VatWsdl.VatValidation out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class HeaderAuthenticateType {
        public String reactid;
        private String[] reactid_type_info = new String[]{'reactid','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'reactid'};
    }
    public class VatProxyViesCheckVatResponse {
        public String country_code;
        public String vat_number;
        public Date request_date;
        public Boolean valid;
        public String name;
        public String address;
        private String[] country_code_type_info = new String[]{'country_code','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] vat_number_type_info = new String[]{'vat_number','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] request_date_type_info = new String[]{'request_date','http://www.webservices.nl/soap/',null,'0','1','false'};
        private String[] valid_type_info = new String[]{'valid','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','http://www.webservices.nl/soap/',null,'0','1','false'};
        private String[] address_type_info = new String[]{'address','http://www.webservices.nl/soap/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'country_code','vat_number','request_date','valid','name','address'};
    }
    public class loginResponseType {
        public String reactid;
        private String[] reactid_type_info = new String[]{'reactid','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'reactid'};
    }
    public class logoutRequestType {
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class VatValidation {
        public String vat_number;
        public Boolean valid;
        private String[] vat_number_type_info = new String[]{'vat_number','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] valid_type_info = new String[]{'valid','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'vat_number','valid'};
    }
    public class Webservices_nlPort {
        public String endpoint_x = 'https://ws1.webservices.nl:443/vat/soap_doclit.php';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public VatWsdl.HeaderAuthenticateType HeaderAuthenticate;
        public VatWsdl.HeaderLoginType HeaderLogin;
        private String HeaderAuthenticate_hns = 'HeaderAuthenticate=http://www.webservices.nl/soap/';
        private String HeaderLogin_hns = 'HeaderLogin=http://www.webservices.nl/soap/';
        private String[] ns_map_type_info = new String[]{'http://www.webservices.nl/soap/', 'VatWsdl'};
        public VatWsdl.VatValidation vatValidate(String vat_number) {
            VatWsdl.vatValidateRequestType request_x = new VatWsdl.vatValidateRequestType();
            request_x.vat_number = vat_number;
            VatWsdl.vatValidateResponseType response_x;
            Map<String, VatWsdl.vatValidateResponseType> response_map_x = new Map<String, VatWsdl.vatValidateResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'https://ws1.webservices.nl/vat/soap_doclit.php/vatValidate',
              'http://www.webservices.nl/soap/',
              'vatValidate',
              'http://www.webservices.nl/soap/',
              'vatValidateResponse',
              'VatWsdl.vatValidateResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }
        public String login(String username,String password) {
            VatWsdl.loginRequestType request_x = new VatWsdl.loginRequestType();
            request_x.username = username;
            request_x.password = password;
            VatWsdl.loginResponseType response_x;
            Map<String, VatWsdl.loginResponseType> response_map_x = new Map<String, VatWsdl.loginResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'https://ws1.webservices.nl/vat/soap_doclit.php/login',
              'http://www.webservices.nl/soap/',
              'login',
              'http://www.webservices.nl/soap/',
              'loginResponse',
              'VatWsdl.loginResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.reactid;
        }
        public VatWsdl.VatProxyViesCheckVatResponse vatViesProxyCheckVat(String vat_number) {
            VatWsdl.vatViesProxyCheckVatRequestType request_x = new VatWsdl.vatViesProxyCheckVatRequestType();
            request_x.vat_number = vat_number;
            VatWsdl.vatViesProxyCheckVatResponseType response_x;
            Map<String, VatWsdl.vatViesProxyCheckVatResponseType> response_map_x = new Map<String, VatWsdl.vatViesProxyCheckVatResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'https://ws1.webservices.nl/vat/soap_doclit.php/vatViesProxyCheckVat',
              'http://www.webservices.nl/soap/',
              'vatViesProxyCheckVat',
              'http://www.webservices.nl/soap/',
              'vatViesProxyCheckVatResponse',
              'VatWsdl.vatViesProxyCheckVatResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.out;
        }
        public void logout() {
            VatWsdl.logoutRequestType request_x = new VatWsdl.logoutRequestType();
            VatWsdl.logoutResponseType response_x;
            Map<String, VatWsdl.logoutResponseType> response_map_x = new Map<String, VatWsdl.logoutResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'https://ws1.webservices.nl/vat/soap_doclit.php/logout',
              'http://www.webservices.nl/soap/',
              'logout',
              'http://www.webservices.nl/soap/',
              'logoutResponse',
              'VatWsdl.logoutResponseType'}
            );
            response_x = response_map_x.get('response_x');
        }

        /***** METHODS NEEDED IN IMPL */

        /**
         * Sets all relevant properties on the port for fallback
         */
        public void doFallBack() {
            endpoint_x = 'https://ws2.webservices.nl:443/accounting/soap_doclit.php';
        }
    }
}