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
                String trade_name = (String)jsonDeserialized.get('name');
                String city = (String)jsonDeserialized.get('city');
                String street = (String)jsonDeserialized.get('street');
                String postcode = (String)jsonDeserialized.get('postal_code');
                System.debug(jsonDeserialized.get('house_number'));
                Integer house_number = null;
                String houseNumberString = (String)jsonDeserialized.get('house_number');
                if (!String.isEmpty(houseNumberString) && houseNumberString.isNumeric()) {
                    house_number = Integer.valueOf(houseNumberString);
                }
                String house_number_addition = (String)jsonDeserialized.get('house_number_addition');
                String telephone_number = (String)jsonDeserialized.get('phone');
                String domain_name = (String)jsonDeserialized.get('domain');
                // (String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search) {
                List<SearchForDossiersResultDto> searchResults = BusinessService.searchForDossiers(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, false);
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
    public static Object createDossier(String dossierNumber, String establishmentNumber, Id accountId){
        try {
            InsertDossiersFromDataVendorResponseDTO responseDTO = BusinessService.insertSingleDossierFromDataVendorData(dossierNumber, establishmentNumber, accountId);
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