public abstract class WebservicesNlSOAPImplTypes {
        
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
    public class intArray {
        public Integer[] item;
        private String[] item_type_info = new String[]{'item','http://www.webservices.nl/soap/',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }

}
