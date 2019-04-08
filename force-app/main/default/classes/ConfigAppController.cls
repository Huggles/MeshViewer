public class ConfigAppController {
public static PermissionSet ps;
    @AuraEnabled(cacheable=true)
    public static List<UserWrapper> getUserList(String searchKey) {

        list<String> enabledDutchBusinessUserIds = getDutchBusinessUserIds();
        list<UserWrapper> uwList = new list<UserWrapper>();
        list<User> userList;
        if (String.isBlank(searchKey)) {
            userList =  [SELECT Id, Name, isActive, Email FROM User]; // TODO: move to selector
        }else{
            String key = '%' + searchKey + '%';
            userList =  [SELECT Id, Name, isActive, Email FROM User WHERE Name LIKE :key]; // TODO: move to selector
        }
            for(User usr: userList){
            UserWrapper uw = new UserWrapper();
            uw.Id = usr.id;
            uw.Name = usr.name;
            uw.isActive = usr.isActive;
            uw.Email = usr.Email;
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


    @AuraEnabled
    public static void assignUsers(List<String> UserIdList){
        ps = [SELECT Id FROM PermissionSet WHERE Name = 'Company_info_User'];
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
        ps = [SELECT Id FROM PermissionSet WHERE Name = 'Company_info_User'];
        system.debug('************* ps = '+ ps);
        list <PermissionSetAssignment> psaList = [SELECT Id, AssigneeId From PermissionSetAssignment WHERE PermissionSetId = :ps.Id];
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
        @AuraEnabled public String Email;
        @AuraEnabled public boolean DutchBusinessActive = false;
    }
}

