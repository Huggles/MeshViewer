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
    public static wwwWebservicesNlSoap.HeaderLoginType getAuthentication(){
        CS = Credentials__c.getOrgDefaults();
        header= new wwwWebservicesNlSoap.HeaderLoginType();
        header.userName=cs.Username__c;//'appsolutelytest_bfc9bbb2';
        header.passWord=cs.Password__c;//'5Z9wwVa-hYzy*mFY)VW.-U$!5Vu}Ymc{';//
        System.debug('get auth');
        System.debug(header);
        return header;
    }

    /**
    * @description :Sets header
    * @param String searchText
    */
    public static wwwWebservicesNlSoap.DutchBusinessReferenceV2[] search(CompanyDetailsControllerHelper.CompanySearchDto searchParams){
        // Handle valid postcodes that the web service does not like
        searchParams.postcode = searchParams.postcode.replaceAll('(\\s+)', '').toUpperCase();

        stub=new wwwWebservicesNlSoap.Webservices_nlPort();
        stub.HeaderLogin= getAuthentication();
        try{
            returnedResults=stub.dutchBusinessSearchParametersV2(searchParams.name,searchParams.city,searchParams.street,searchParams.postcode,null,null,searchParams.phone,searchParams.domain,Constants.Strict_Search,Constants.paramInt);
        }
        catch (System.CalloutException ex){
            System.debug('ERROR:' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }

        if(returnedResults.results.item.size()>0){
            searchResults=returnedResults.results.item;
        }
        else{
            System.debug('no items');
            // searchResults=returnedResults;
        }
        //return parsed result
        return searchResults;
    }

    public static wwwWebservicesNlSoap.DutchBusinessDossierV3 getInfo(String dossierNumber) {
        System.debug('getInfo');
        System.debug(dossierNumber);
        stub=new wwwWebservicesNlSoap.Webservices_nlPort(); 
        stub.HeaderLogin= getAuthentication();
        try{
            wwwWebservicesNlSoap.DutchBusinessDossierV3 response = stub.dutchBusinessGetDossierV3(dossierNumber, '000036043249');
            System.debug('RETURNED');
            System.debug(response);
            return response;
        }
        catch (System.CalloutException ex){
            System.debug('ERROR:' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public static Id saveDutchBusinessDossier(wwwWebservicesNlSoap.DutchBusinessDossierV3 dossier, Id accountId) {
        // Condense all trade names into single field, seperated by new lines.
        String trade_names = '';
        for (Integer i = 0; i < dossier.trade_names.item.size(); i++) {
            trade_names += dossier.trade_names.item[i] + '/n';
        }

        // @todo add addresses and everything from 'Contact person' on.
        Dutch_Business_Dossier__c d = new Dutch_Business_Dossier__c(
            Account__c = accountId,
            Name = dossier.legal_name,
            Dossier_Number__c = Integer.valueOf(dossier.dossier_number),
            Establishment_Number__c = Integer.valueOf(dossier.establishment_number),
            Main_Establishment_Number__c = Integer.valueOf(dossier.main_establishment_number),
            Indication_Main_Establishment__c = Boolean.valueOf(dossier.indication_main_establishment),
            Rsin_Number__c = Integer.valueOf(dossier.rsin_number),
            Chamber_Number__c = Integer.valueOf(dossier.chamber_number),
            Legal_Form_Code__c = Integer.valueOf(dossier.legal_form_code),
            Legal_Form_Text__c = String.valueOf(dossier.legal_form_text),
            Indication_Organisation_Code__c = String.valueOf(dossier.indication_organisation_code),
            Trade_Name_45__c = dossier.trade_name_45,
            Trade_Name_Full__c = dossier.trade_name_full,
            Trade_Names__c = trade_names,
            Telephone_Number__c = dossier.telephone_number,
            Mobile_Number__c = dossier.mobile_number,
            Domain_Name__c = dossier.domain_name
        );

        // @todo add security checking
        insert d;

        return d.Id;
    }

    public class CompanySearchDto {
        public string name;
        public string domain;
        public string phone;
        public string street;
        public string city;
        public string postcode;
        public string province;
        public string country;
    }


}