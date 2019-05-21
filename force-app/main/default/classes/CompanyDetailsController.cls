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
                
                Object result = (Object)DutchBusinessService.searchForDossiers(params);
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
    public static Object getInfo(String dossierNumber, Id accountId){
        System.debug('getInfo');
        if(dossierNumber!=null){
            try{
                
                DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessService.getDossier(dossierNumber);
                //DutchBusinessService.createUpdateAccountAndDossier(dossier, accountId); 
            
                //return DutchBusinessService.updateAccountDossier(dossier);
                //AuraResponseWrapper output = new AuraResponseWrapper((Object)DutchBusinessService.createUpdateAccountAndDossier(dossier, accountId));
                AuraResponseWrapper output = new AuraResponseWrapper(createUpdateAccount(dossier, accountId));
                return output;

            }catch(BdsException ex){
                //throw ex; // we dont log bds exceptions, only throwing them further
                //ErrorLogUtil.logException(ex);
                system.debug('********************************** BDS cought - no logging');
                //AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
                AuraResponseWrapper output = new AuraResponseWrapper(ex); // move the msg to label.
                
                return output;
                //throw new AuraHandledException(ex.getMessage());
            }catch(System.Exception ex){
                ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
                system.debug('********************************** Unexpected cought cought -  logged');
                AuraResponseWrapper output = new AuraResponseWrapper(ex); // move the msg to label.
                return output;
                //throw new AuraHandledException(ex.getMessage());
                //throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
            }
        }
        return null;
    } 
    @AuraEnabled
    public static Object getInfoNoSaving(String dossierNumber){
        System.debug('getInfoNoSaving');
        try{
            DutchBusinessDto.DutchBusinessGetDossierResponse dossier = DutchBusinessService.getDossier(dossierNumber);
            Account acc = DutchBusinessService.getDossierAccount(dossier.dossier_number);
            String AccountId = '';
            if(acc != null){
                AccountId = acc.Id;
            }
            list<Object> result = new list<Object>();
            result = createUpdateAccount(dossier, accountId);
            
            
            System.debug('getInfoNoSavingResponse');
            System.debug(result);
            
            //result.add(dossier);
            //result.add(AccountId);
            //result.add(acc);
            //result.add();
            AuraResponseWrapper output = new AuraResponseWrapper((Object)result);
            return output;
        }catch(BdsException ex){
            //throw ex; // we dont log bds exceptions, only throwing them further
            //ErrorLogUtil.logException(ex);
            system.debug('********************************** BDS cought - no logging');
            AuraResponseWrapper output = new AuraResponseWrapper(ex);//null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            return output;
            //throw new AuraHandledException(ex.getMessage());
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            system.debug('********************************** Unexpected cought cought -  logged');
            AuraResponseWrapper output = new AuraResponseWrapper(ex);//null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            return output;
            //throw new AuraHandledException(ex.getMessage());
            //throw new BdsException(System.Label.BDS_DBSCall_Unknown_Exception+ex.getMessage(), ex);
        }

    }


    //@AuraEnabled
    public static list<Object>  createUpdateAccount(String dossierObj, String accountId){
        DutchBusinessDto.DutchBusinessGetDossierResponse dossier  = castToDossierDto(dossierObj);
        return createUpdateAccount(dossier, accountId);           
    }
    
    public static list<Object>  createUpdateAccount(DutchBusinessDto.DutchBusinessGetDossierResponse dossier, String accountId){
        //try{
            list<Object> result = new list<object>();

            result = DutchBusinessService.createUpdateAccountAndDossier(dossier, accountId);    
            DutchBusinessService.updateAccountDossier(dossier); // will be gone later once fflib is updated
            //AuraResponseWrapper output = new AuraResponseWrapper(result);
            return result;
       /* }catch(BdsException ex){
            AuraResponseWrapper output = new AuraResponseWrapper(ex);//null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            return output;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            AuraResponseWrapper output = new AuraResponseWrapper(ex);//null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            return output;

        }*/
    }
    private static DutchBusinessDto.DutchBusinessGetDossierResponse castToDossierDto(String str){
        DutchBusinessDto.DutchBusinessGetDossierResponse response = (DutchBusinessDto.DutchBusinessGetDossierResponse)JSON.deserialize(str, DutchBusinessDto.DutchBusinessGetDossierResponse.class); //= new DutchBusinessDto.DutchBusinessGetDossierResponse();
        return response;
    }
/*
    @AuraEnabled
    public static Id getDossierRecordId(Integer dossierNum){
        if (Schema.sObjectType.Dutch_Business_Dossier__c.fields.Id.isAccessible() == false) throw new NoAccessException();
        
         = [SELECT Id FROM Dutch_Business_Dossier__c WHERE Dossier_Number__c = :dossierNumber];
        if (results.size() > 0) {
            return results[0].Id;
        }

        List<Dutch_Business_Dossier__c> results = DutchBusinessDossierSelector.newInstance().selectByDossierNumber(new set<Integer>{dossierNum});
        if(results.size() >0){
            return results[0].Id;
        }
        return null;
    }
    */
}