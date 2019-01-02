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

        System.debug(returnedResults);

        if(returnedResults != null && returnedResults.results != null && returnedResults.results.item != null && returnedResults.results.item.size()>0){
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
        if (dossierNumber == null) return null;
        stub=new wwwWebservicesNlSoap.Webservices_nlPort(); 
        stub.HeaderLogin= getAuthentication();
        try{
            wwwWebservicesNlSoap.DutchBusinessDossierV3 response;
            response = stub.dutchBusinessGetDossierV3(dossierNumber, null);
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
        List<Dutch_Business_Dossier__c> dbds = [SELECT Id, Account__c FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :Integer.valueOf(dossier.dossier_number)];
        Dutch_Business_Dossier__c d;

        String trade_names = '';
        if (dossier.trade_names != null && dossier.trade_names.item != null && dossier.trade_names.item.size() > 0) {
            // Condense all trade names into single field, seperated by new lines.
            for (Integer i = 0; i < dossier.trade_names.item.size(); i++) {
                trade_names += dossier.trade_names.item[i] + '/n';
            }
        }

        if (dbds.size() < 1) {
            d = new Dutch_Business_Dossier__c();
            d.Account__c = accountId;
        }
        else {
            d = dbds[0];
            if (d.Account__c !=  accountId) {
                throw new AuraHandledException('Dossier is already allocated to another Account');
            }
        }

        // @todo add addresses and everything from 'Contact person' on.
        d.Name = dossier.legal_name;
        d.Dossier_Number__c = Integer.valueOf(dossier.dossier_number);
        d.Establishment_Number__c = Integer.valueOf(dossier.establishment_number);
        d.Main_Establishment_Number__c = Integer.valueOf(dossier.main_establishment_number);
        d.Indication_Main_Establishment__c = Boolean.valueOf(dossier.indication_main_establishment);
        d.Rsin_Number__c = Integer.valueOf(dossier.rsin_number);
        d.Chamber_Number__c = Integer.valueOf(dossier.chamber_number);
        d.Legal_Form_Code__c = Integer.valueOf(dossier.legal_form_code);
        d.Legal_Form_Text__c = String.valueOf(dossier.legal_form_text);
        d.Indication_Organisation_Code__c = String.valueOf(dossier.indication_organisation_code);
        d.Trade_Name_45__c = dossier.trade_name_45;
        d.Trade_Name_Full__c = dossier.trade_name_full;
        d.Trade_Names__c = trade_names;
        d.Telephone_Number__c = dossier.telephone_number;
        d.Mobile_Number__c = dossier.mobile_number;
        d.Domain_Name__c = dossier.domain_name;

        // @todo add security checking
        upsert d;

        return d.Id;
    }

    public static boolean updateAccountDossier(Id accountId, Integer dossierNumber) {
        List<Account> accts = [SELECT Id, Dossier_Number__c FROM Account WHERE Id = :accountId];
        if (accts.size() > 0) {
            accts[0].Dossier_Number__c = dossierNumber;
            update accts;
            return true;
        }
        return false;
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