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
                DutchBusinessDto.dutchBusinessSearchParametersRequest params = (DutchBusinessDto.dutchBusinessSearchParametersRequest)JSON.deserialize(searchParams, DutchBusinessDto.dutchBusinessSearchParametersRequest.class);
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
//        Business_Dossier__c dossierFromDB = BusinessDuplicateService.checkSingleDuplicateDossier(dossierNumber, establishmentNumber);
//        Boolean dossierExisting = dossierFromDB == null ? false : true;
//
//        if(!dossierExisting){ //dossier doesn't exist already
//
//            try{
//                // TODO: wrap the three business service calls into one. This is functionality that should be defined on the serivce layer
//                // fetch the dossier from the backend
//                DutchBusinessDto.DutchBusinessGetDossierResponse dossier = BusinessService.getDossier(dossierNumber, establishmentNumber);
//
//                // create an account if the account id is null
//                if (accountId == null) {
//                    // TODO: add validation exception handling
//                    try {
//                        List<InsertAccountResponseDTO> accountResponseDTOS = BusinessService.insertAccount(new List<DutchBusinessDto.DutchBusinessGetDossierResponse>{dossier});
//                        accountId = accountResponseDTOS.get(0).account.Id;
//                    } catch (CCDuplicateException e) { // multiple duplicates have been found
//                        Database.rollback(sp);
//                        return new AuraResponseWrapper(e);
//                    }
//                }
//
//                // insert the dossier (and have the dossier be returned)
//                List<Business_Dossier__c> dossierDBs = BusinessService.insertDossier(new List<InsertDossierRequestDTO>{new InsertDossierRequestDTO(dossier, accountId)});
//                dossierFromDB = dossierDBs[0];
//            } catch (CCException e) {
//                Database.rollback(sp);
//                return new AuraResponseWrapper(e);
//            } catch (Exception e) {
//                ErrorLogUtil.logException(e);
//                Database.rollback(sp);
//                return new AuraResponseWrapper(e, System.Label.WSCall_Generic_UI_Exception);
//            }
//        }
    }


    @AuraEnabled
    public static Object deleteDossier(Id recordId){
        try{
            Boolean result = BusinessService.deleteDossier(recordId);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch (CCException e) {
            // TODO: remove the rollback and move it to the business service layer
            Application.rollback(); // perform database rollback
            return new AuraResponseWrapper(e);
        } catch (Exception e) {
            ErrorLogUtil.logException(e);
            // TODO: remove the rollback and move it to the business service layer
            Application.rollback();
            return new AuraResponseWrapper(e, System.Label.WSCall_Generic_UI_Exception);
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