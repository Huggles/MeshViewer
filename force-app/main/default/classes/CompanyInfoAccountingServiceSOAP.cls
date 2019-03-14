public with sharing class CompanyInfoAccountingServiceSOAP {


    public class HeaderAuthenticateType {
        public String reactid;
        private String[] reactid_type_info = new String[]{'reactid','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'reactid'};
    }
    public class HeaderLoginType {
        public String username;
        public String password;
        private String[] username_type_info = new String[]{'username','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }
   public class userCreateV2ResponseType {
        public Integer id;
        public String nickname;
        public String password;
        private String[] id_type_info = new String[]{'id','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] nickname_type_info = new String[]{'nickname','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'id','nickname','password'};
    }

    public class userCreateV2RequestType {
        public Integer accountid;
        public String nickname;
        public String password;
        public CompanyInfoAccountingServiceSOAP.intArray usergroups;
        public String email;
        public String companyname;
        public String address;
        public String contactname;
        public String contactemail;
        public String telephone;
        public String fax;
        public String clientcode;
        public String comments;
        private String[] accountid_type_info = new String[]{'accountid','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] nickname_type_info = new String[]{'nickname','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] usergroups_type_info = new String[]{'usergroups','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] email_type_info = new String[]{'email','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] companyname_type_info = new String[]{'companyname','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] address_type_info = new String[]{'address','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] contactname_type_info = new String[]{'contactname','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] contactemail_type_info = new String[]{'contactemail','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] telephone_type_info = new String[]{'telephone','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] fax_type_info = new String[]{'fax','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] clientcode_type_info = new String[]{'clientcode','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] comments_type_info = new String[]{'comments','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'accountid','nickname','password','usergroups','email','companyname','address','contactname','contactemail','telephone','fax','clientcode','comments'};
    }
    public class intArray {
        public Integer[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }

    public class Webservices_nlPort {
        public String endpoint_x = 'https://ws1.webservices.nl:443/soap_doclit.php';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public CompanyInfoAccountingServiceSOAP.HeaderAuthenticateType HeaderAuthenticate;
        public CompanyInfoAccountingServiceSOAP.HeaderLoginType HeaderLogin;
        private String HeaderAuthenticate_hns = 'HeaderAuthenticate=http://www.webservices.nl/soap/';
        private String HeaderLogin_hns = 'HeaderLogin=http://www.webservices.nl/soap/';
        private String[] ns_map_type_info = new String[]{'http://www.webservices.nl/soap/', 'wwwWebservicesNlSoapVPROK'};

        public CompanyInfoAccountingServiceSOAP.userCreateV2ResponseType userCreateV2(Integer accountid,String nickname,String password,CompanyInfoAccountingServiceSOAP.intArray usergroups,String email,String companyname,String address,String contactname,String contactemail,String telephone,String fax,String clientcode,String comments) {
            CompanyInfoAccountingServiceSOAP.userCreateV2RequestType request_x = new CompanyInfoAccountingServiceSOAP.userCreateV2RequestType();
            request_x.accountid = accountid;
            request_x.nickname = nickname;
            request_x.password = password;
            request_x.usergroups = usergroups;
            request_x.email = email;
            request_x.companyname = companyname;
            request_x.address = address;
            request_x.contactname = contactname;
            request_x.contactemail = contactemail;
            request_x.telephone = telephone;
            request_x.fax = fax;
            request_x.clientcode = clientcode;
            request_x.comments = comments;
            CompanyInfoAccountingServiceSOAP.userCreateV2ResponseType response_x;
            Map<String, CompanyInfoAccountingServiceSOAP.userCreateV2ResponseType> response_map_x = new Map<String, CompanyInfoAccountingServiceSOAP.userCreateV2ResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'https://ws1.webservices.nl/soap_doclit.php/userCreateV2',
              'http://www.webservices.nl/soap/',
              'userCreateV2',
              'http://www.webservices.nl/soap/',
              'userCreateV2Response',
              'CompanyInfoAccountingServiceSOAP.userCreateV2ResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }


 




    }




 
}
