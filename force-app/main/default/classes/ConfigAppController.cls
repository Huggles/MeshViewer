public with sharing class ConfigAppController {
public static PermissionSet ps;
    @AuraEnabled(cacheable=true)
    public static List<UserWrapper> getUserList(String searchKey, String searchParam, String sortedBy, String sortedDirection) {
        try{
            fflib_SecurityUtils.checkRead(Profile.SObjectType, new List<String>{'Id','Name'});

            list<String> enabledDutchBusinessUserIds = getDutchBusinessUserIds();
            list<UserWrapper> uwList = new list<UserWrapper>();
            list<User> userList;
            system.debug(searchParam);
            if(sortedby == null){sortedby = 'Name';}
            if(sortedDirection == null){sortedDirection = 'asc';}
            system.debug('sortedBy = ' + sortedby);
            system.debug('sortedDirection = ' + sortedDirection);
            if(searchParam == 'Name'){
                userList = UserSelector.newInstance().selectByNameLikeSearchKey(searchKey, sortedBy, sortedDirection);
            }else if(searchParam == 'ProfileName'){
                userList = UserSelector.newInstance().selectByProfileLikeSearchKey(searchKey, sortedBy, sortedDirection);
            }

            set<Id> profileIdSet = new set<Id>();
            for(User usr: userList){
                profileIdSet.add(usr.profileId);
            }
            system.debug('profileIdSet'+profileIdSet);
            map<Id, Profile> profileMap = new map<Id, Profile>();
            profileMap = new map<Id, Profile>([SELECT Name From Profile WHERE Id IN :profileIdSet]);

            for(User usr: userList){
                UserWrapper uw = new UserWrapper();
                uw.Id = usr.id;
                uw.Name = usr.name;
                uw.isActive = usr.isActive;
                try{uw.ProfileName = profileMap.get(usr.ProfileId).name;}catch(exception e){}
                system.debug('************* usr.Id = '+ usr.Id);
                
                system.debug('************* enabledDutchBusinessUserIds = '+ enabledDutchBusinessUserIds);
                system.debug('************* enabledDutchBusinessUserIds.contains(usr.Id) = '+ enabledDutchBusinessUserIds.contains(usr.Id));
                if(enabledDutchBusinessUserIds.contains(usr.Id)){
                    uw.DutchBusinessActive = true;
                }
                uwList.add(uw);
            }
            system.debug('************* uwList= '+ uwList);
            return uwList;
        }catch(BdsException ex){
            //throw ex; // we dont log bds exceptions, only throwing them further
            //TODO: implement error callback and reporting
            return null;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            //AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return null;
        }
    }
    @AuraEnabled(cacheable=true)
    public static boolean getUserOnboarded(){
       try{
           return DutchBusinessAccountingService.getUserOnboarded();
       }catch(BdsException ex){
            //throw ex; // we dont log bds exceptions, only throwing them further
            //TODO: implement error callback and reporting
            return false;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            //AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return false;
        } 
    }

    @AuraEnabled
    public static void addBudget(Double Amount){
        try{
            boolean resp = DutchBusinessAccountingService.addBudget(amount);
        }catch(BdsException ex){
            //throw ex; // we dont log bds exceptions, only throwing them further
            //TODO: implement error callback and reporting
           // return null;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            //AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            //return null;
        }

    }

    @AuraEnabled
    public static boolean enableTrial(){
        try{
            DutchBusinessAccountingDto.userCreateResponseDto resp = DutchBusinessAccountingService.onboardCustomer(UserInfo.getOrganizationId());
            system.debug(resp);
            return true;
        }catch(BdsException ex){
            AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return false;
        }catch(System.Exception ex){
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than BdsException type
            //AuraResponseWrapper output = new AuraResponseWrapper(null, 'ERROR', System.Label.BDS_WSCall_Generic_UI_Exception); // move the msg to label.
            //return output;
            return false;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getUserBalance(){
        Decimal balance = DutchBusinessAccountingService.getBalance();
        system.debug('balance is '+ balance);
        return balance;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean userCheckActive(){
        return DutchBusinessAccountingService.userCheckActive();
    }

    

    @AuraEnabled
    public static void assignUsers(List<String> UserIdList){
        fflib_SecurityUtils.checkRead(PermissionSet.SObjectType, new List<String>{'Id','Name'});
        fflib_SecurityUtils.checkRead(PermissionSetAssignment.SObjectType, new List<String>{'Id','AssigneeId','PermissionSetId'});
        fflib_SecurityUtils.checkObjectIsDeletable(PermissionSetAssignment.SObjectType);
        fflib_SecurityUtils.checkUpdate(PermissionSetAssignment.SObjectType, new List<String>{'AssigneeId','PermissionSetId'});
        fflib_SecurityUtils.checkInsert(PermissionSetAssignment.SObjectType, new List<String>{'AssigneeId','PermissionSetId'});
        ps = [SELECT Id FROM PermissionSet WHERE Name = 'Business_Data_For_Salesforce_User'];
        system.debug('pspspspspspspspspspspspsps = '+ps);
        list<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
        list<String> enabledDutchBusinessUserIds = getDutchBusinessUserIds();
        list<String> psaToDelete = new list<String>();
        
        for(String usrId: UserIdList){
            if(!enabledDutchBusinessUserIds.contains(usrId)){
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = usrId;
                psa.PermissionSetId = ps.Id;
                psaList.add(psa);
            }else{
                psaToDelete.add(usrId);
            }
        }
        upsert psaList;
        if(psaToDelete.size()>0){
            delete([SELECT ID FROM PermissionSetAssignment WHERE AssigneeId IN :psaToDelete AND PermissionSetId = :ps.Id]);
        }
        system.debug(logginglevel.error,'Users = '+UserIdList);
    }

    private static list<String> getDutchBusinessUserIds(){
        fflib_SecurityUtils.checkRead(PermissionSet.SObjectType, new List<String>{'Id','Name'});
        fflib_SecurityUtils.checkRead(PermissionSetAssignment.SObjectType, new List<String>{'Id','AssigneeId','PermissionSetId'});
        ps = [SELECT Id FROM PermissionSet WHERE Name = 'Business_Data_For_Salesforce_User'];
        system.debug('************* ps = '+ ps);
        list <PermissionSetAssignment> psaList = new list <PermissionSetAssignment>();
        psaList = [SELECT Id, AssigneeId From PermissionSetAssignment WHERE PermissionSetId = :ps.Id];
        list<String> result = new list<String>();
        system.debug('************* psalist = '+ psaList);
        for(PermissionSetAssignment psa: psaList){
            result.add(psa.assigneeId);
        }
        return result;

    }

    public class UserWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public boolean isActive;
        @AuraEnabled public String ProfileName;
        @AuraEnabled public boolean DutchBusinessActive = false;
    }
}

