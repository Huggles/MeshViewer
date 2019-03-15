public abstract class WebServicesNLSOAPAccountingImplTypes extends WebservicesNlSOAPImpl{
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
        public intArray usergroups;
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
    public class accountViewV2RequestType {
        public Integer accountid;
        private String[] accountid_type_info = new String[]{'accountid','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'accountid'};
    }
    public class accountViewV2ResponseType {
        public AccountV2 out;
        private String[] out_type_info = new String[]{'out','http://www.webservices.nl/soap/','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'out'};
    }
    public class AccountV2 {
        public Integer id;
        public String name;
        public String address;
        public String environment;
        public Boolean reseller;
        public String contactname;
        public String contactemail;
        public String telephone;
        public String fax;
        public String description;
        public String creationtime;
        public String lastmodified;
        public String clientcode;
        public String comments;
        public String usernameprefix;
        public Double balance;
        public Double balancethreshold;
        private String[] id_type_info = new String[]{'id','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] address_type_info = new String[]{'address','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] environment_type_info = new String[]{'environment','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] reseller_type_info = new String[]{'reseller','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] contactname_type_info = new String[]{'contactname','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] contactemail_type_info = new String[]{'contactemail','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] telephone_type_info = new String[]{'telephone','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] fax_type_info = new String[]{'fax','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] creationtime_type_info = new String[]{'creationtime','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] lastmodified_type_info = new String[]{'lastmodified','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] clientcode_type_info = new String[]{'clientcode','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] comments_type_info = new String[]{'comments','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] usernameprefix_type_info = new String[]{'usernameprefix','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] balance_type_info = new String[]{'balance','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] balancethreshold_type_info = new String[]{'balancethreshold','http://www.webservices.nl/soap/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'id','name','address','environment','reseller','contactname','contactemail','telephone','fax','description','creationtime','lastmodified','clientcode','comments','usernameprefix','balance','balancethreshold'};

    }
}
