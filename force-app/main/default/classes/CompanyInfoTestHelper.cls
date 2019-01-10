public with sharing class CompanyInfoTestHelper {
    public CompanyInfoTestHelper() {

    }
    public static Account CreateAccount() {
        Account a = new Account(Name = 'Test Account');
        insert a;
        return a;
    }
}
