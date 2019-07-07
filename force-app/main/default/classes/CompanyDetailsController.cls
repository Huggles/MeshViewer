/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/

public with sharing class CompanyDetailsController {

    @AuraEnabled
    public static Object search(String searchParams){
        if(searchParams!=null){
            try{
                // List<SearchForDossiersResultDto> searchForDossiers(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search);
                Map<String, Object> jsonDeserialized = (Map<String, Object>)JSON.deserializeUntyped(searchParams);
                String country = (String)jsonDeserialized.get('country');
                String registration_number = (String)jsonDeserialized.get('registration_number');
                String vat_number = (String)jsonDeserialized.get('vat_number');
                String province = (String)jsonDeserialized.get('province');
                String trade_name = (String)jsonDeserialized.get('name');
                String city = (String)jsonDeserialized.get('city');
                String street = (String)jsonDeserialized.get('street');
                String postcode = (String)jsonDeserialized.get('postal_code');
                Integer house_number = null;
                String houseNumberString = (String)jsonDeserialized.get('house_number');
                if (!String.isEmpty(houseNumberString) && houseNumberString.isNumeric()) {
                    house_number = Integer.valueOf(houseNumberString);
                }
                String house_number_addition = (String)jsonDeserialized.get('house_number_addition');
                String telephone_number = (String)jsonDeserialized.get('phone');
                String domain_name = (String)jsonDeserialized.get('domain');
  //  public List<SearchForDossiersResultDto> searchForDossiers(String country, String trade_name, String registration_number, String vat_number, String city, String street, String postcode, Integer house_number, String house_number_addition, String province, String telephone_number, String domain_name) {
                List<SearchForDossiersResultDto> searchResults = BusinessService.searchForDossiers(country, trade_name, registration_number, vat_number, city, street, postcode, house_number, house_number_addition, province, telephone_number, domain_name);
                return new AuraResponseWrapper(searchResults);
            } catch (CCException e) {
                return new AuraResponseWrapper(e);
            } catch (Exception e) {
                ErrorLogUtil.logException(e);
                return new AuraResponseWrapper(e, System.Label.Error);
            }
        }
        return null;
    }

    @AuraEnabled
    public static Object createDossier(String creditSafeId, String dossierNumber, String establishmentNumber, String vendor, Id accountId){
        System.debug('credtSafeId: ' + creditSafeId);
        System.debug('dossierNumber: ' + dossierNumber);
        System.debug('estab nr: ' + establishmentNumber);
        System.debug('vendor ' + vendor);
        System.debug('account id ' + accountId);
        try {
            InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData(creditSafeId, dossierNumber, establishmentNumber, vendor, accountId);
            return new AuraResponseWrapper(responseDTO);
        } catch (Exception ex) {
            return new AuraResponseWrapper(ex);
        }
    }


    @AuraEnabled
    public static Object deleteDossier(Id recordId){
        try{
            Boolean result = BusinessService.deleteDossier(recordId);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch (CCException e) {
            return new AuraResponseWrapper(e);
        }
    }

    @AuraEnabled
    public static Object getVATDetails(Id dossierId){
        try{
            Business_Dossier__c dossier = BusinessService.setVatNumber(dossierId);
            return new AuraResponseWrapper(dossier);
        } catch (CCException e) {
            return new AuraResponseWrapper(e);
        } catch (Exception e) {
            ErrorLogUtil.logException(e);
            return new AuraResponseWrapper(e, System.Label.Error);
        }
    }

}