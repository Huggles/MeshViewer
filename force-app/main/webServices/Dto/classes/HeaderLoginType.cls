/**
 * Created by jaapbranderhorst on 2019-06-29.
 */

public with sharing class HeaderLoginType {
    public String username;
    public String password;
    private String[] username_type_info = new String[]{'username','http://www.webservices.nl/soap/','string','1','1','false'};
    private String[] password_type_info = new String[]{'password','http://www.webservices.nl/soap/','string','1','1','false'};
    private String[] apex_schema_type_info = new String[]{'http://www.webservices.nl/soap/','true','false'};
    private String[] field_order_type_info = new String[]{'username','password'};

}