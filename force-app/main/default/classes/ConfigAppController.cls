public with sharing class ConfigAppController {
public static PermissionSet ps;
    @AuraEnabled(cacheable=true)
    public static List<UserWrapper> getUserList(String searchKey, String searchParam, String sortedBy, String sortedDirection) {

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
    }
    @AuraEnabled(cacheable=true)
    public static boolean getUserOnboarded(){
       try{
           return DutchBusinessAccountingService.getUserOnboarded();
       }catch(exception e){
            // throw something
            return false;
        } 
    }

    @AuraEnabled
    public static void addBudged(Double Amount){
        system.debug('BEFORE CALLING*************');
        boolean resp = DutchBusinessAccountingService.addBudget(amount);
        system.debug('*************' + resp);
    }

    @AuraEnabled
    public static void enableTrial(){
        DutchBusinessAccountingDto.userCreateResponseDto resp = DutchBusinessAccountingService.onboardCustomer(UserInfo.getOrganizationId());
        system.debug(resp);
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getUserBalance(){
        Decimal balance = DutchBusinessAccountingService.getBalance();
        system.debug('balance is '+ balance);
        return balance;
    }

    

    @AuraEnabled
    public static void assignUsers(List<String> UserIdList){
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

