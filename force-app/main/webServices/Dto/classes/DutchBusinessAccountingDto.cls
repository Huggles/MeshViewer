public with sharing class DutchBusinessAccountingDto {
    public class AccountViewResponseDto {
        public String companyInfoId;
        public String Name;
        public String Address;
        public String Environment;
        public boolean isReseller;
        public String ContactName;
        public String ContactEmail;
        public String Telephone;
        public String Fax;
        public String Description;
        public String CreationTime; // UMC format
        public String LastModified; // Datetime format
        public String ClientCode;
        public String Comments;
        public String UsernamePrefix;
        public Decimal Balance;
        public Decimal BalanceTreshold;

    }
    public class UserCreateRequestDto {
        public Integer accountid;
        public String nickname;
        public String password;
        public list<Integer> usergroups;
        public String email;
        public String companyname;
        public String address;
        public String contactname;
        public String contactemail;
        public String telephone;
        public String fax;
        public String clientcode;
        public String comments;
    }
    public class userCreateResponseDto {
        public Integer id;
        public String nickname;
        public String password;
    }
}
