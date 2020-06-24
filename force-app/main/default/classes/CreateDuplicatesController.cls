/**
 * Created by tejaswinidandi on 02/06/2020.
 */

public inherited sharing class CreateDuplicatesController {

    @AuraEnabled
    public static Id createDuplicateAccount(Account account) {
        return DuplicateManagementService.createDuplicate(account);
    }


}