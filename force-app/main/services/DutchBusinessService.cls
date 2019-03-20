/****************************************************************************************
Author          : ValerijsProkudins
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/
public with sharing class DutchBusinessService {
    
   private static WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2PagedResult returnedResults;
   private static list<WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2> searchResults; 
    
   public static WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2[] searchForDossiers(CompanySearchDto searchParams){
        // Handle valid postcodes that the web service does not like
        if (searchParams.postcode != null)
            searchParams.postcode = searchParams.postcode.replaceAll('(\\s+)', '').toUpperCase();

        IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
        try{
            returnedResults = service.dutchBusinessSearchParametersV2(searchParams.name,searchParams.city,searchParams.street,searchParams.postcode,null,null,searchParams.phone,searchParams.domain,Constants.Strict_Search,Constants.paramInt).DutchBusinessReferenceV2PagedResult;
            if(returnedResults != null && returnedResults.results != null && returnedResults.results.item != null && returnedResults.results.item.size()>0){
                searchResults=returnedResults.results.item;
            }
            else{
                System.debug('no items');
                // searchResults=returnedResults;
            }
            //return parsed result
            return searchResults;
        }catch(System.CalloutException ex){
            throw new CustomException('The call to the service was unsuccessfull'+ex.getMessage());
        }
    }
    
    public static DutchBusinessDto getInfo(String dossierNumber) {
        if (dossierNumber == null) return null;
         IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
        try{
            return service.dutchBusinessGetDossierV3(dossierNumber, null);//.dutchBusinessGetDossierV3Response;
        }catch(System.CalloutException ex){
            throw new CustomException('The call to the service was unsuccessfull'+ex.getMessage());
        }


    }
    public static void updateAccountDossier(Id accountId, Id dossierId) {
        List<Account> accts = [SELECT Id, Dutch_Business_Dossier__c FROM Account WHERE Id = :accountId];
        if (accts.size() == 1 && dossierId != NULL) {
            accts[0].Dutch_Business_Dossier__c = dossierId;
            update accts;
        }
    }
    
    
    private static Boolean checkAccess() {
         List<String> fields = new List<String>{'Name','Establishment_Number__c','Main_Establishment_Number__c',
        'Indication_Main_Establishment__c','Rsin_Number__c','Chamber_Number__c','Legal_Form_Code__c','Legal_Form_Text__c','Indication_Organisation_Code__c',
        'Trade_Name_45__c','Trade_Name_Full__c','Trade_Names__c','Telephone_Number__c','Mobile_Number__c','Domain_Name__c','Authorized_Share_Capital__c',
        'Authorized_Share_Capital_Currency__c','Class_Personnel__c','Class_Personnel_Fulltime__c','Continuation_Date__c','Discontinuation_Date__c','Establishment_Date__c',
        'Founding_Date__c','Issued_Share_Capital__c','Issued_Share_Capital_Currency__c','Paid_Up_Share_Capital__c','Paid_Up_Share_Capital_Currency__c',
        'Personnel__c','Personnel_Fulltime__c','Personnel_Reference_Date__c','Primary_Sbi_Code__c','Primary_Sbi_Code_Text__c','Secondary_Sbi_Code_1__c',
        'Secondary_Sbi_Code_1_Text__c','Secondary_Sbi_Code_2__c','Secondary_Sbi_Code_2_Text__c','Status__c'};

        Schema.sObjectType.Dutch_Business_Dossier__c.fields.getMap();

        Schema.DescribeSObjectResult a_desc = Dutch_Business_Dossier__c.sObjectType.getDescribe(); 
        //for the Account object, you can replace that with any object you have, standard or custom
        Map<String, Schema.SObjectField> a_fields = a_desc.fields.getMap();

        for(Schema.sObjectField fld: a_fields.values()){ 
            if (fld.getDescribe().isUpdateable() == false && fields.contains(fld.getDescribe().getName())) {
                return false;
            }
        }


        return true;
    }

    public static Id saveDutchBusinessDossier(WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessDossierV3 dossier, Id accountId) {
        if (Schema.sObjectType.Dutch_Business_Dossier__c.fields.Id.isAccessible() == false ||
            Schema.sObjectType.Dutch_Business_Dossier__c.fields.Account__c.isAccessible() == false ||
            checkAccess() == false) throw new NoAccessException();

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

        // @todo add addresses and contact.
        system.debug('VPROK tests dosier = '+ dossier);
        d.Name = dossier.legal_name;
        d.Dossier_Number__c = Integer.valueOf(dossier.dossier_number);
        d.Establishment_Number__c = Integer.valueOf(dossier.establishment_number);
        d.Main_Establishment_Number__c = Integer.valueOf(dossier.main_establishment_number);
        d.Indication_Main_Establishment__c = Boolean.valueOf(dossier.indication_main_establishment);
        if(dossier.rsin_number != null){d.Rsin_Number__c = Integer.valueOf(dossier.rsin_number);}
        if(dossier.chamber_number != null){d.Chamber_Number__c = Integer.valueOf(dossier.chamber_number);}
        if(dossier.legal_form_code != null){d.Legal_Form_Code__c = Integer.valueOf(dossier.legal_form_code);}
        if(dossier.legal_form_text != null){d.Legal_Form_Text__c = String.valueOf(dossier.legal_form_text);}
        if(dossier.indication_organisation_code != null){d.Indication_Organisation_Code__c = String.valueOf(dossier.indication_organisation_code);}
        d.Trade_Name_45__c = dossier.trade_name_45;
        d.Trade_Name_Full__c = dossier.trade_name_full;
        d.Trade_Names__c = trade_names;
        d.Telephone_Number__c = dossier.telephone_number;
        d.Mobile_Number__c = dossier.mobile_number;
        d.Domain_Name__c = dossier.domain_name;

        d.Authorized_Share_Capital__c = dossier.authorized_share_capital;
        d.Authorized_Share_Capital_Currency__c = dossier.authorized_share_capital_currency;
        if(dossier.class_personnel != null){d.Class_Personnel__c = String.valueOf(dossier.class_personnel);}
        if(dossier.class_personnel_fulltime != null){d.Class_Personnel_Fulltime__c = String.valueOf(dossier.class_personnel_fulltime);}
        if(dossier.continuation_date != null){d.Continuation_Date__c = convertDate(dossier.continuation_date);}
        if(dossier.discontinuation_date != null){d.Discontinuation_Date__c = convertDate(dossier.discontinuation_date);}
        if(dossier.establishment_date != null){d.Establishment_Date__c = convertDate(dossier.establishment_date);}
        if(dossier.founding_date != null){d.Founding_Date__c = convertDate(dossier.founding_date);}
        if(dossier.issued_share_capital != null){d.Issued_Share_Capital__c = Integer.valueOf(dossier.issued_share_capital);}
        d.Issued_Share_Capital_Currency__c = dossier.issued_share_capital_currency;
        if(dossier.paid_up_share_capital != null){d.Paid_Up_Share_Capital__c = Integer.valueOf(dossier.paid_up_share_capital);}
        d.Paid_Up_Share_Capital_Currency__c = dossier.paid_up_share_capital_currency;
        d.Personnel__c = dossier.personnel;
        d.Personnel_Fulltime__c = dossier.personnel_fulltime;
        if(dossier.personnel_reference_date != null){d.Personnel_Reference_Date__c = convertDate(dossier.personnel_reference_date);}
        d.Primary_Sbi_Code__c = dossier.primary_sbi_code;
        d.Primary_Sbi_Code_Text__c = dossier.primary_sbi_code_text;
        d.Secondary_Sbi_Code_1__c = dossier.secondary_sbi_code1;
        d.Secondary_Sbi_Code_1_Text__c = dossier.secondary_sbi_code1_text;
        d.Secondary_Sbi_Code_2__c = dossier.secondary_sbi_code2;
        d.Secondary_Sbi_Code_2_Text__c = dossier.secondary_sbi_code2_text;
        d.Status__c = determineStatus(dossier);

        upsert d;
        return d.Id;
    }
    private static String determineStatus(WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessDossierV3 dossier) {
        List<String> status = new List<String>();
        if (dossier.indication_import != null && Boolean.valueOf(dossier.indication_import) == true) status.add('Import');
        if (dossier.indication_export != null && Boolean.valueOf(dossier.indication_export) == true) status.add('Export');
        if (dossier.indication_economically_active != null && Boolean.valueOf(dossier.indication_economically_active) == true) status.add('Economically Active');
        if (dossier.indication_non_mailing != null && Boolean.valueOf(dossier.indication_non_mailing) == true) status.add('Non Mailing');
        if (dossier.indication_bankruptcy != null && Boolean.valueOf(dossier.indication_bankruptcy) == true) status.add('Bankruptcy');
        if (dossier.indication_dip != null && Boolean.valueOf(dossier.indication_dip) == true) status.add('DIP');
        return String.join(status, ';');
    }

    private static Date convertDate(WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessDateV3 d) {
        if (d != null) return Date.newInstance(d.year, d.month, d.day);
        return null;
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
