/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/

public with sharing class CompanyDetailsController {

    public class CreateDossierResult {
        @AuraEnabled
        public Business_Dossier__c dossier {
            get; set;
        }

        @AuraEnabled
        public Boolean dossierExisting {
            get; set;
        }

        public CreateDossierResult(Business_Dossier__c dossier, Boolean dossierExisting) {
            this.dossier = dossier;
            this.dossierExisting = dossierExisting;
        }

    }

//    // This is really bad design since it checks for the faultcode and is specific to CI. Should be moved back to where the error originates
//    // TODO: move this
//    private static String formatError(String msg) {
//        // Format the error from the Company.info server if that's what it is. Otherwise just pass it through.
//        String actualError = msg;
//        if (actualError.contains('faultcode=')) {
//            List<String> parts = actualError.split(':');
//            if (parts.size() == 4) {
//                List<String> moreparts = parts[2].split('faultcode=');
//                if (moreparts.size() == 2) {
//                    actualError = moreparts[0];
//                }
//            }
//        }
//        return actualError;
//    }



    @AuraEnabled
    public static Object search(String searchParams){
        if(searchParams!=null){
            try{
                // TODO: remove the extreme strong relationship between the backend and the front end (the search params are created here in the format of the backend)
                DutchBusinessDto.dutchBusinessSearchParametersRequest params = (DutchBusinessDto.dutchBusinessSearchParametersRequest)JSON.deserialize(searchParams, DutchBusinessDto.dutchBusinessSearchParametersRequest.class);

                Object result = (Object) BusinessService.searchForDossiers(params);
                AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
                return output;
            } catch (CCException e) {
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
        return null;
    }

    @AuraEnabled
    public static Object createDossier(String dossierNumber, String establishmentNumber, Id accountId){

        Business_Dossier__c dossierFromDB = BusinessDuplicateService.checkSingleDuplicateDossier(dossierNumber, establishmentNumber);
        Boolean dossierExisting = dossierFromDB == null ? false : true;

        if(!dossierExisting){ //dossier doesn't exist already
            Savepoint sp = Database.setSavepoint();
            try{
                // TODO: wrap the three business service calls into one. This is functionality that should be defined on the serivce layer
                // fetch the dossier from the backend
                DutchBusinessDto.DutchBusinessGetDossierResponse dossier = BusinessService.getDossier(dossierNumber, establishmentNumber);

                // create an account if the account id is null
                if (accountId == null) {
                    // TODO: add validation exception handling
                    try {
                        List<InsertAccountResponseDTO> accountResponseDTOS = BusinessService.insertAccount(new List<DutchBusinessDto.DutchBusinessGetDossierResponse>{dossier});
                        accountId = accountResponseDTOS.get(0).account.Id;
                    } catch (CCDuplicateException e) { // multiple duplicates have been found
                        Database.rollback(sp);
                        return new AuraResponseWrapper(e);
                    }
                }

                // insert the dossier (and have the dossier be returned)
                List<Business_Dossier__c> dossierDBs = BusinessService.insertDossier(new List<InsertDossierRequestDTO>{new InsertDossierRequestDTO(dossier, accountId)});
                dossierFromDB = dossierDBs[0];
            } catch (CCException e) {
                Database.rollback(sp);
                return new AuraResponseWrapper(e);
            } catch (Exception e) {
                ErrorLogUtil.logException(e);
                Database.rollback(sp);
                return new AuraResponseWrapper(e, System.Label.WSCall_Generic_UI_Exception);
            }
        }
        CreateDossierResult result = new CreateDossierResult(dossierFromDB, dossierExisting);
        return new AuraResponseWrapper(result);
    }

    // JB: we don't use this so let's not maintain it...
//    @AuraEnabled
//    public static Object createDossier(String dossierNumber, String establishmentNumber){
//        try{
//            DutchBusinessDto.DutchBusinessGetDossierResponse dossier = BusinessService.getDossier(dossierNumber, establishmentNumber);
//            Account acc;// = BusinessService.getDossierAccount(dossier.dossier_number); // checking if there already is an account for this dossier number
//            String AccountId = '';
//            if(acc != null){
//                AccountId = acc.Id;
//            }
//            list<Object> result = new list<Object>();
//            result = createUpdateAccount(dossier, accountId);
//            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
//            return output;
//        }catch (CCException e) {
//            // TODO: remove the rollback and move it to the business service layer
//            Application.rollback(); // perform database rollback
//            return new AuraResponseWrapper(e);
//        } catch (Exception e) {
//            ErrorLogUtil.logException(e);
//            // TODO: remove the rollback and move it to the business service layer
//            Application.rollback();
//            return new AuraResponseWrapper(e, System.Label.WSCall_Generic_UI_Exception);
//        }
//    }

//    // TODO: rewrite...
//    public static list<Object> createUpdateAccount(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){
//        list<Object> result = new list<object>();
//        result = BusinessService.upsertAccountAndDossier(dossier, accountId);
//        BusinessService.updateAccountDossier(dossier); // will be gone later once fflib is updated
//        //AuraResponseWrapper output = new AuraResponseWrapper(result);
//        return result;
//    }

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

//    @AuraEnabled
//    public static Object checkDossier(String dossierNumber, String establishmentNumber){
//        try{
//            Boolean result = BusinessDuplicateService.checkDossier(dossierNumber,establishmentNumber);
//            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
//            return output;
//        }catch (CCException e) {
//            // TODO: remove the rollback and move it to the business service layer
//            Application.rollback(); // perform database rollback
//            return new AuraResponseWrapper(e);
//        } catch (Exception e) {
//            ErrorLogUtil.logException(e);
//            // TODO: remove the rollback and move it to the business service layer
//            Application.rollback();
//            return new AuraResponseWrapper(e, System.Label.WSCall_Generic_UI_Exception);
//        }
//    }

    @AuraEnabled
    public static Object getVATDetails(String dossierId){
        try{
            // 1. Get existing dossier from ID
            // TODO: remove this. Can be replaced by simple new Dossier(Id = dossierId)
            Business_Dossier__c result = BusinessService.selectDossier(dossierId);        
            // 2. WebService call to get VAT
            DutchBusinessDto.DutchBusinessVatNumber vatResponse = BusinessService.requestVAT(result.Dossier_Number__c);
            // 3. Add VAT number to dossier
            result.VAT_Number__c = vatResponse.vat_number;
            // 4. Save
            BusinessService.upsertDossier(result);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        } catch (CCException e) {
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

}