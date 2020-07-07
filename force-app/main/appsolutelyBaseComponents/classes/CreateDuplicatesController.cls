/**
 * Created by tejaswinidandi on 02/06/2020.
 */

public inherited sharing class CreateDuplicatesController {

    @AuraEnabled
    public static Id createDuplicateAccount(Account account) {
        try {
            Id accountId =  DuplicateManagementService.createDuplicate(account);
            return accountId;
        }catch (Exception e){
            ErrorLogUtil.logException(e);
            throw new AuraHandledException(e.getMessage());
        }

    }


}