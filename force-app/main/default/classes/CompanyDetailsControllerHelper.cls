/**
* Created by Asifsayyed on 02/12/18.
* @Description:Helper to CompanyDetailsController
* TBD make generic class to take request based on new form params
* TBD Mapping of parameters
* TBD Error Handling
*/
public with sharing class CompanyDetailsControllerHelper {

    private static wwwWebservicesNlSoap.Webservices_nlPort stub;
    private static list<wwwWebservicesNlSoap.DutchBusinessReferenceV2> searchResults;
    private static wwwWebservicesNlSoap.DutchBusinessReferenceV2PagedResult returnedResults;
    private static wwwWebservicesNlSoap.HeaderLoginType header;
    private static string param,postCode,telephoneNumber,domainName;
    public  static Credentials__c cs;

    /**
    * @description :Sets username and password in header
    */
    @AuraEnabled
    public static wwwWebservicesNlSoap.HeaderLoginType getAuthentication(){
        CS = Credentials__c.getOrgDefaults();
        header= new wwwWebservicesNlSoap.HeaderLoginType();
        header.userName=cs.Username__c;//'appsolutelytest_bfc9bbb2';
        header.passWord=cs.Password__c;//'5Z9wwVa-hYzy*mFY)VW.-U$!5Vu}Ymc{';//
        return header;
    }

    /**
    * @description :Sets header
    * @param String searchText
    */
    @AuraEnabled
    public static wwwWebservicesNlSoap.DutchBusinessReferenceV2[] search(String searchText){
        param=searchText;
        domainName='';//TBD
        if(checkTelephone(searchText)==True){
            telephoneNumber=searchText;
        }
        else{
            telephoneNumber='';
        }
        if(checkPostCode(searchText)==True){
            postCode=searchText;
        }
        else {
            postCode='';
        }

        stub=new wwwWebservicesNlSoap.Webservices_nlPort();
        stub.HeaderLogin= getAuthentication();
        try{
            returnedResults=stub.dutchBusinessSearchParametersV2(param,param,param,postCode,Constants.paramInt,param,telephoneNumber,domainName,Constants.Strict_Search,Constants.paramInt);
        }
        catch (System.CalloutException ex){

            System.debug('ERROR:' + ex.getMessage());



        }

        if(returnedResults.results.item.size()>0){
            searchResults=returnedResults.results.item;
        }
        else{
            //TBD
        }
        //return parsed result
        return searchResults;
    }

    /**
    * @description :Validates string whether it's dutch telephone or PostCode
    * @param String str
    */
    public static Boolean checkTelephone (String str)
    {
        return Pattern.compile('^((\\+|00(\\s|\\s?\\-\\s?)?)31(\\s|\\s?\\-\\s?)?(\\(0\\)[\\-\\s]?)?|0)[1-9]((\\s|\\s?\\-\\s?)?[0-9])((\\s|\\s?-\\s?)?[0-9])((\\s|\\s?-\\s?)?[0-9])\\s?[0-9]\\s?[0-9]\\s?[0-9]\\s?[0-9]\\s?[0-9]').matcher(str).matches();
    }
    public static Boolean checkPostCode (String str)
    {
        return Pattern.compile('\\d{4}[ ]?[A-Z]{2}').matcher(str).matches();
    }


}