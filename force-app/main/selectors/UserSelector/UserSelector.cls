/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public inherited sharing class UserSelector  extends fflib_SObjectSelector implements IUserSelector  {

    public static IUserSelector newInstance() {
        return (IUserSelector) Application.Selector.newInstance(User.SObjectType);
    }

    public SObjectType getSObjectType() {
        return User.SObjectType;
    }


    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                User.Id,
                User.FirstName,
                User.LastName,
                User.ProfileId,
                User.UserRoleId
        };
    }

    public List<User> selectByPermissionSetGroup(String permissionSetGroup) {
        List<PermissionSetAssignment> assignments = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetGroup.DeveloperName = :permissionSetGroup];
        Set<Id> ids = new Set<Id>();
        for (PermissionSetAssignment permissionSetAssignment : assignments) {
            ids.add(permissionSetAssignment.AssigneeId);
        }
        return [SELECT Id, FirstName, LastName, ProfileId, Profile.Name, UserRole.Name FROM User WHERE Id IN :ids]; // don't use the queryfactory. Too complex
    }


}