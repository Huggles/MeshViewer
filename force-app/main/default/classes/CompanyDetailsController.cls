/**
* Created by Asifsayyed on 02/12/18.
* @param SearchString
*/ 

// TODO handle empty search System.Label.BDS_WSCall_Generic_UI_Exception

public with sharing class CompanyDetailsController {
    //private static list<WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2> searchResults;
    @AuraEnabled
    public static Object search(String searchParams){
        if(searchParams!=null){
            try{
                DutchBusinessDto.dutchBusinessSearchParametersRequest params = (DutchBusinessDto.dutchBusinessSearchParametersRequest)JSON.deserialize(searchParams, DutchBusinessDto.dutchBusinessSearchParametersRequest.class);
                Object result = (Object)DutchBusinessServiceImpl.searchForDossiers(params);
                AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
                return output;
            }catch(BdsException ex){
                AuraResponseWrapper output = new AuraResponseWrapper(ex);//null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
                return output;
            }catch(System.Exception ex){
                ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
                AuraResponseWrapper output = new AuraResponseWrapper(ex);//null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
                return output;
            }
        }
        return null; 
    }
    @AuraEnabled
    public static Object createDossier(String dossierNumber, Id accountId){
        System.debug('getInfo');
        if(dossierNumber!=null){
            try{
                
                DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessServiceImpl.getDossier(dossierNumber);
                AuraResponseWrapper output = new AuraResponseWrapper(createUpdateAccount(dossier, accountId));
                return output;

            }catch(BdsException ex){
                AuraResponseWrapper output = new AuraResponseWrapper(ex); // move the msg to label.
                return output;
            }catch(System.Exception ex){
                ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
                AuraResponseWrapper output = new AuraResponseWrapper(ex); // move the msg to label.
                return output;
                }
        }
        return null;
    } 
    @AuraEnabled
    public static Object createDossier(String dossierNumber){
        System.debug('getInfoNoSaving');
        try{
            DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessServiceImpl.getDossier(dossierNumber);
            Account acc = DutchBusinessServiceImpl.getDossierAccount(dossier.dossier_number); // checking if there already is an account for this dossier number
            String AccountId = '';
            if(acc != null){
                AccountId = acc.Id;
            }
            list<Object> result = new list<Object>();
            result = createUpdateAccount(dossier, accountId);
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch(BdsException ex){
            AuraResponseWrapper output = new AuraResponseWrapper(ex);//null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            return output;
            //throw new AuraHandledException(ex.getMessage());
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            AuraResponseWrapper output = new AuraResponseWrapper(ex);//null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            return output;
        }

    }



    //@AuraEnabled
    /*public static list<Object>  createUpdateAccount(String dossierObj, String accountId){
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier  = castToDossierDto(dossierObj);
        return createUpdateAccount(dossier, accountId);           
    }*/
     
    public static list<Object> createUpdateAccount(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){

        list<Object> result = new list<object>();
        result = DutchBusinessServiceImpl.upsertAccountAndDossier(dossier, accountId);
        DutchBusinessServiceImpl.updateAccountDossier(dossier); // will be gone later once fflib is updated
        //AuraResponseWrapper output = new AuraResponseWrapper(result);
        return result;
    }
    private static DutchBusinessDto.DutchBusinessGetDossierResponse castToDossierDto(String str){
        DutchBusinessDto.DutchBusinessGetDossierResponse response = (DutchBusinessDto.DutchBusinessGetDossierResponse)JSON.deserialize(str, DutchBusinessDto.DutchBusinessGetDossierResponse.class); //= new DutchBusinessDto.DutchBusinessGetDossierResponse();
        return response;
    }

}