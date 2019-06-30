/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/

public with sharing class CompanyDetailsController {

    @AuraEnabled
    public static Object search(String searchParams){
        if(searchParams!=null){
            try{
                // TODO: remove the extreme strong relationship between the backend and the front end (the search params are created here in the format of the backend)
                BusinessService.searchForDossiers();
                DutchBusinessWsdl.dutchBusinessSearchParametersRequest params = (DutchBusinessWsdl.dutchBusinessSearchParametersRequest)JSON.deserialize(searchParams, DutchBusinessWsdl.dutchBusinessSearchParametersRequest.class);
                AuraResponseWrapper output = new AuraResponseWrapper(BusinessService.searchForDossiers(params));
                return output;
            } catch (CCException e) {
                return new AuraResponseWrapper(e);
            } catch (Exception e) {
                ErrorLogUtil.logException(e);
                return new AuraResponseWrapper(e, System.Label.WSCall_Generic_UI_Exception);
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
        } catch (CCVatNotFoundException e) {
            return new AuraResponseWrapper(e);
        } catch (Exception e) {
            ErrorLogUtil.logException(e);
            return new AuraResponseWrapper(e, System.Label.WSCall_Generic_UI_Exception);
        }
    }

}